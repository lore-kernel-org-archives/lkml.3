Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933139Ab3HGNfu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 09:35:50 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:55858 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933040Ab3HGNft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 09:35:49 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: [PATCH] ARM: fix wrong address when loading PRM_FRAC_INCREMENTOR_DENUMERATOR_RELOAD
From: Chen Baozi <baozich@gmail.com>
In-Reply-To: <20130807110945.GL7656@atomide.com>
Date: Wed, 7 Aug 2013 21:35:43 +0800
Cc: linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <4F20F648-FED2-4877-8896-EF6F12295615@gmail.com>
References: <1375356474-24203-1-git-send-email-baozich@gmail.com> <C635EF21-CD18-4633-AA39-16209F8EE231@gmail.com> <20130807110945.GL7656@atomide.com>
To: Tony Lindgren <tony@atomide.com>
X-Mailer: Apple Mail (2.1508)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 7, 2013, at 7:09 PM, Tony Lindgren <tony@atomide.com> wrote:

> * Chen Baozi <baozich@gmail.com> [130805 08:33]:
>> ping?
>> 
>> On Aug 1, 2013, at 7:27 PM, Chen Baozi <baozich@gmail.com> wrote:
>> 
>>> The denominator should be load from INCREMENTOR_DENUMERATOR_RELOAD_OFFSET
>>> rather than INCREMENTER_NUMERATOR_OFFSET.
> 
> Maybe describe what exactly happens without this fix?

I think it is more likely a typo, since 
INCREMENTER_DENUMERATOR_RELOAD[23:17] is reserved. It seems
that it won't make much trouble without this fix because
the useful [11:0] bit is mask and set the right value later.

Cheers,

Baozi

> 
> Also we should get few acks for this for the -rc series.
> 
> Regards,
> 
> Tony
> 
>>> Signed-off-by: Chen Baozi <baozich@gmail.com>
>>> ---
>>> arch/arm/mach-omap2/timer.c | 2 +-
>>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>> 
>>> diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
>>> index b37e1fc..9265e03 100644
>>> --- a/arch/arm/mach-omap2/timer.c
>>> +++ b/arch/arm/mach-omap2/timer.c
>>> @@ -537,7 +537,7 @@ static void __init realtime_counter_init(void)
>>> 	reg |= num;
>>> 	__raw_writel(reg, base + INCREMENTER_NUMERATOR_OFFSET);
>>> 
>>> -	reg = __raw_readl(base + INCREMENTER_NUMERATOR_OFFSET) &
>>> +	reg = __raw_readl(base + INCREMENTER_DENUMERATOR_RELOAD_OFFSET) &
>>> 			NUMERATOR_DENUMERATOR_MASK;
>>> 	reg |= den;
>>> 	__raw_writel(reg, base + INCREMENTER_DENUMERATOR_RELOAD_OFFSET);
>>> -- 
>>> 1.8.1.4
>>> 
>> 

