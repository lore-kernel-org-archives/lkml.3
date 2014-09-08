Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbaIHOgE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 10:36:04 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:51310 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938AbaIHOgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 10:36:01 -0400
Date: Mon, 8 Sep 2014 15:35:54 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, wim@iguana.be, linux-watchdog@vger.kernel.org,
        David Paris <david.paris@st.com>
Subject: Re: [PATCH 4/4] watchdog: st_wdt: Add new driver for ST's LPC
 Watchdog
Message-ID: <20140908143554.GD30307@lee--X1>
References: <1409841592-18890-1-git-send-email-lee.jones@linaro.org>
 <1409841592-18890-6-git-send-email-lee.jones@linaro.org>
 <20140905155811.GA12374@roeck-us.net>
 <20140908123246.GB26284@lee--X1>
 <540DAFBC.1010502@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <540DAFBC.1010502@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 08 Sep 2014, Guenter Roeck wrote:

> On 09/08/2014 05:32 AM, Lee Jones wrote:
> >On Fri, 05 Sep 2014, Guenter Roeck wrote:
> ...
> >>>+
> >>>+static struct st_wdog_syscfg stid127_syscfg = {
> >>>+	.type_mask	= BIT(2),
> >>>+	.enable_mask	= BIT(2),
> >>>+};
> >>>+
> >>>+static struct st_wdog_syscfg stih415_syscfg = {
> >>>+	.type_mask	= BIT(6),
> >>>+	.enable_mask	= BIT(7),
> >>>+};
> >>>+
> >>>+static struct st_wdog_syscfg stih416_syscfg = {
> >>>+	.type_mask	= BIT(6),
> >>>+	.enable_mask	= BIT(7),
> >>>+};
> >>>+
> >>>+static struct st_wdog_syscfg stih407_syscfg = {
> >>>+	.enable_mask	= BIT(19),
> >>>+};
> >>>+
> ...
> 
> >>>+	/* Mask/unmask watchdog reset */
> >>>+	regmap_update_bits(st_wdog->syscfg->regmap,
> >>>+			   st_wdog->syscfg->enable_reg,
> >>>+			   st_wdog->syscfg->enable_mask,
> >>>+			   !enable);
> >>
> >>enable is a bool, but is supposed to provide the value to be put into the
> >>register, masked with enable_mask. Unless I am missing something, the value
> >>is not shifted in regmap_update_bits. So I don't think this can work, but
> >>effectively always writes zero into the mask unless the mask happens to be
> >>at bit position 0 - which never happens.
> >>
> >>Same is true for warm_reset above, which also has values 0 or 1.
> >>
> >>I know it does not really matter in C (at least when it comes to handling
> >>0 and 1), but I would suggest to avoid mixing booleans with bit masks.
> >
> >You're right of course, great spot.
> >
> >How about?
> >
> >   !enable << ffs(st_wdog->syscfg->enable_mask).
> >
> Seems to add a lot of complexity (as in 'makes it difficult to understand')
> to avoid a conditional, and assumes that enable_mask will never have more
> than one bit set. I would go with
> 	enable ? st_wdog->syscfg->enable_mask : 0
> to avoid confusion, but your call.

Actually, it would be the other way round, but the implementation is
nice.  I'll use that instead.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
