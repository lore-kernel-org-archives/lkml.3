Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932422Ab3BIQoc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 11:44:32 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:56035 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760762Ab3BIQoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 11:44:30 -0500
Message-ID: <51167CE5.6060303@dawncrow.de>
Date: Sat, 09 Feb 2013 17:44:21 +0100
From: =?ISO-8859-1?Q?Andr=E9_Hentschel?= <nerv@dawncrow.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] arm: Preserve TPIDRURW on context switch
References: <5112DC7E.4020108@dawncrow.de> <20130206225150.GL17833@n2100.arm.linux.org.uk> <5112E0C3.1080706@dawncrow.de> <20130208154809.GF3495@mudshark.cambridge.arm.com>
In-Reply-To: <20130208154809.GF3495@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Provags-ID: V02:K0:5wHcZbCOOVFtdX8yzhaE0K6uYLyk+gj9EyxiA6GRvn2
 PnVcS0scnnBpkCMH5ukvMeKD0FnrW+XtixpM8COL+wHIbmBiFo
 Uz+gL+PrLvmvOhVjkvuFIlcHlQlWKBo8tGtChc6Zs1gi3LEPn0
 wL7MHqMbqE0qAyqhoPu1a+zvIipBvZLOyTzSSlKOaHNMBVutEx
 oOcgkLMVwWMOEIGFmwyAttCfHYppSyMUwUlBfzmpFgedwc2RMi
 IFgjlKvK+uxBamLtr+X3iNvzZnUQqVWDaVxk3qIliF8GKZpRZW
 NRONczPta8xxEYr+1T+aW1121jv2piR06jh18lZ4YaABfBqovg
 RWrtXlXH96iEBvgFaqS0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 08.02.2013 16:48, schrieb Will Deacon:
> On Wed, Feb 06, 2013 at 11:01:23PM +0000, André Hentschel wrote:
>> Am 06.02.2013 23:51, schrieb Russell King - ARM Linux:
>>> On Wed, Feb 06, 2013 at 11:43:10PM +0100, André Hentschel wrote:
>>>> There are more and more applications coming to WinRT, Wine could support them,
>>>> but mostly they expect to have the thread environment block (TEB) in TPIDRURW.
>>>> This register must be preserved per thread instead of being cleared.
>>>
>>> I'd prefer this was done a little more sensitively to those CPUs where
>>> loads/stores are expensive, namely:
>>>
>>>> +
>>>> +	@ preserve TPIDRURW register state
>>>> +	get_tls2	r3, r4, r5
>>>> +	str	r3, [r1, #TI_TP2_VALUE]
>>>> +	ldr	r3, [r2, #TI_TP2_VALUE]
>>>> +	set_tls2	r3, r4, r5
>>>
>>> those two loads/stores get omitted from the thread switching if the CPU
>>> doesn't support it.  Do you think that's something you could do?
>>
>> No, i'm not sure how to improve this. How does the process can continue, can you or someone else fix that and add his Signed-off-by?
> 
> How about something like the (completely untested) diff below?
> 
> Andre: if this works for you, I'm happy to write a commit message etc.
> 
> Cheers,
> 
> Will
> 
> --->8

I'll try the next days and report back, thx.
-- 

Best Regards, André Hentschel
