Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbaAWK5Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 05:57:24 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:51299 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbaAWK5V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 05:57:21 -0500
Date: Thu, 23 Jan 2014 11:56:32 +0100
From: Lothar =?UTF-8?B?V2HDn21hbm4=?= <LW@KARO-electronics.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, Shawn Guo <shawn.guo@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] PWM: let of_xlate handlers check args count
Message-ID: <20140123115632.6d3f1a58@ipc1.ka-ro>
In-Reply-To: <1390467898-9216-2-git-send-email-s.hauer@pengutronix.de>
References: <20140123083714.3c6e86ae@ipc1.ka-ro>
	<1390467898-9216-1-git-send-email-s.hauer@pengutronix.de>
	<1390467898-9216-2-git-send-email-s.hauer@pengutronix.de>
Organization: Ka-Ro electronics GmbH
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sascha Hauer wrote:
> of_pwm_n_cells for the of_xlate handler is stored in struct pwm_chip,
> but it is only ever used by the of_xlate handler itsel. Remove
> of_pwm_n_cells from struct pwm_chip and let the handler do the argument
> count checking to simplify the code.
> 
This still does not make the PWM_POLARITY flag in the pwms node
optional as was the goal because of_parse_phandle_with_args() requires
at least #pwm-cells arguments in the node.

So, with a DT configuration like:
pwm0: pwm@0 {
	#pwm-cells = <3>;
};
backlight {
	pwms = <&pwm0 0 100000>;
};
the driver will bail out at of_parse_phandle_with_args() in
of_pwm_get() with the error message:
"/backlight: arguments longer than property" and never reach your
clever xlate function.

Thus you will still need to replace of_parse_phandle_with_args()
with different code that copies most but not all of the functionality.


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
