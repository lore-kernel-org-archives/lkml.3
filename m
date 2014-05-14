Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751614AbaENTC7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 15:02:59 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:37288 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626AbaENTCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 15:02:14 -0400
Date: Wed, 14 May 2014 12:02:10 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] Input: pmic8xxx-pwrkey - Set sane default for debounce
 time
Message-ID: <20140514190210.GJ30089@core.coreip.homeip.net>
References: <1396289664-31893-1-git-send-email-sboyd@codeaurora.org>
 <20140331182315.GA9198@core.coreip.homeip.net>
 <5339B407.1050308@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5339B407.1050308@codeaurora.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 11:29:27AM -0700, Stephen Boyd wrote:
> On 03/31/14 11:23, Dmitry Torokhov wrote:
> > On Mon, Mar 31, 2014 at 11:14:24AM -0700, Stephen Boyd wrote:
> >> If the debounce time is 0 our usage of ilog2() later on in this
> >> driver will cause undefined behavior. If CONFIG_OF=n this fact is
> >> evident to the compiler, and it emits a call to ____ilog2_NaN()
> >> which doesn't exist. Fix this by setting a sane default for
> >> debounce.
> >>
> >> Reported-by: Arnd Bergmann <arnd@arndb.de>
> >> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> >> ---
> >>  drivers/input/misc/pmic8xxx-pwrkey.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/input/misc/pmic8xxx-pwrkey.c b/drivers/input/misc/pmic8xxx-pwrkey.c
> >> index 1cb8fda7a166..27add04676e1 100644
> >> --- a/drivers/input/misc/pmic8xxx-pwrkey.c
> >> +++ b/drivers/input/misc/pmic8xxx-pwrkey.c
> >> @@ -92,7 +92,7 @@ static int pmic8xxx_pwrkey_probe(struct platform_device *pdev)
> >>  	bool pull_up;
> >>  
> >>  	if (of_property_read_u32(pdev->dev.of_node, "debounce", &kpd_delay))
> >> -		kpd_delay = 0;
> >> +		kpd_delay = 15625;
> > What if somebody supplied 0 via DT? Can we check and return -EINVAL?
> 
> Sure. Here's a v2.
> 
> -----8<------
> From: Stephen Boyd <sboyd@codeaurora.org>
> Subject: [PATCH v2] Input: pmic8xxx-pwrkey - Set sane default for debounce
>  time
> 
> If the debounce time is 0 our usage of ilog2() later on in this
> driver will cause undefined behavior. If CONFIG_OF=n this fact is
> evident to the compiler, and it emits a call to ____ilog2_NaN()
> which doesn't exist. Fix this by setting a sane default for
> debounce and failing to probe if debounce is 0 in the DT.
> 
> Reported-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Applied, thank you. Sorry for the delay.

-- 
Dmitry
