Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab3IZXSh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 19:18:37 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:42354 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab3IZXSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 19:18:35 -0400
Message-ID: <5244C0C4.2030004@wwwdotorg.org>
Date: Thu, 26 Sep 2013 17:18:28 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>,
        Grant Likely <grant.likely@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kumar Gala <galak@codeaurora.org>, Pawel Moll <pawel.moll@arm.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Balaji T K <balajitk@ti.com>, Tony Lindgren <tony@atomide.com>,
        Jon Hunter <jgchunter@gmail.com>, linux-gpio@vger.kernel.org,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, r.sricharan@ti.com, holler@ahsoftware.de
Subject: Re: [RFC v2] gpio/omap: auto-setup a GPIO when used as an IRQ
References: <1380009480-4975-1-git-send-email-javier.martinez@collabora.co.uk>
In-Reply-To: <1380009480-4975-1-git-send-email-javier.martinez@collabora.co.uk>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2013 01:58 AM, Javier Martinez Canillas wrote:
> The OMAP GPIO controller HW requires a pin to be configured in GPIO
> input mode in order to operate as an interrupt input. Since drivers
> should not be aware of whether an interrupt pin is also a GPIO or not,
> the HW should be fully configured/enabled as an IRQ if a driver solely
> uses IRQ APIs such as request_irq(), and never calls any GPIO-related
> APIs. As such, add the missing HW setup to the OMAP GPIO controller's
> irq_chip driver.
> 
> Since this bypasses the GPIO subsystem we have to ensure that another
> caller won't be able to request the same GPIO pin that is used as an
> IRQ and set its direction as output. Requesting the GPIO and setting
> its direction as input is allowed though.

FWIW, the concept of this patch,
Acked-by: Stephen Warren <swarren@nvidia.com>

I didn't review the code; just skimmed it to see where the new
functionality was implemented.
