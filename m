Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964827Ab3HHJ3I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 05:29:08 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:55368 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934118Ab3HHJ3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 05:29:06 -0400
Subject: Re: [PATCH 4/5] omap: Avoid crashes in the case of hwmod misconfiguration
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <87siyl19uk.fsf@linaro.org>
Date: Thu, 8 Aug 2013 12:29:00 +0300
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        =?iso-8859-1?Q?Beno=EEt_Coussno?= <b-cousson@ti.com>,
        Paul Walmsley <paul@pwsan.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sourav Poddar <sourav.poddar@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        Felipe Balbi <balbi@ti.com>, Koen Kooi <koen@circuitco.com>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <AB1CC181-58F8-4C58-9789-71A9A90B2E17@antoniou-consulting.com>
References: <1375775624-12250-1-git-send-email-panto@antoniou-consulting.com> <1375775624-12250-5-git-send-email-panto@antoniou-consulting.com> <87siyl19uk.fsf@linaro.org>
To: Kevin Hilman <khilman@linaro.org>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,

On Aug 8, 2013, at 12:15 AM, Kevin Hilman wrote:

> Pantelis Antoniou <panto@antoniou-consulting.com> writes:
> 
>> omap hwmod is really sensitive to hwmod misconfiguration.
>> Getting a minor clock wrong always ended up in a crash.
>> Attempt to be more resilient by not assigning variables with
>> error codes and then attempting to use them.
>> 
>> Without this patch, missing a clock ends up with something like this:
>> omap_hwmod: ehrpwm0: cannot clk_get opt_clk ehrpwm0_tbclk!
> 
> Definitely agree we should not be crashing when given bad data.
> 
> nit Re: "missing clock".  I don't think there will be any crash if a
> clock is missing.  This looks to me more like the clock name is wrong
> (tbclk instead of dbclk?), not missing.
> 

Yes, I'll rephrase.

> [...]
> 
>> index 7341eff..42cb7d4 100644
>> --- a/arch/arm/mach-omap2/omap_hwmod.c
>> +++ b/arch/arm/mach-omap2/omap_hwmod.c
>> @@ -784,7 +784,9 @@ static int _init_interface_clks(struct omap_hwmod *oh)
>> 		if (IS_ERR(c)) {
>> 			pr_warning("omap_hwmod: %s: cannot clk_get interface_clk %s\n",
>> 				   oh->name, os->clk);
>> -			ret = -EINVAL;
>> +			if (ret == 0)
>> +				ret = -EINVAL;
>> +			continue;
> 
> the 'if (ret == 0)' adds confusion IMO.  If we don't care additional
> failures, errors, then just add a 'break' instead of these 3 lines.
> 
> [...]
> 


I tried to carry on as much as possible even on the presence of errors.
The remaining clocks won't be initialized, but that might be OK.

> Kevin

Regards

-- Pantelis

