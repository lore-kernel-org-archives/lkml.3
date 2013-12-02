Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103Ab3LBIaf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 03:30:35 -0500
Received: from mail-bk0-f41.google.com ([209.85.214.41]:52937 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029Ab3LBIae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 03:30:34 -0500
Message-ID: <529C4527.3040707@gmail.com>
Date: Mon, 02 Dec 2013 09:30:31 +0100
From: =?ISO-8859-1?Q?Philippe_R=E9tornaz?= <philippe.retornaz@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130923 Thunderbird/17.0.9
MIME-Version: 1.0
To: Alexander Shiyan <shc_work@mail.ru>
CC: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Sascha Hauer <kernel@pengutronix.de>, Shawn Guo <shawn.guo@linaro.org>,
        Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RESEND] mfd: mc13xxx: Fix null pointer dereference in
 mc13xxx_common_init
References: <1385805188-5597-1-git-send-email-shc_work@mail.ru>
In-Reply-To: <1385805188-5597-1-git-send-email-shc_work@mail.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 30/11/2013 10:53, Alexander Shiyan a écrit :
> If this driver being loaded from devicetree, the pdata is NULL. This
> cause kernel Oops when "fsl,mc13xxx-uses-codec" and/or
> "fsl,mc13xxx-uses-touch" properties is specified.
>

Well, the codec and touch are not supported if DT is used, thus why
bothering ? Just don't specify thoses properties.

IMHO it would be better to either implement full DT support in the
subdevices or removing the check for the fsl,mc13xxx-uses-codec and
fsl,mc13xxx-uses-touch in mc13xxx_probe_flags_dt().
If it's not supported let's not lie about it.


Regards,

Philippe
