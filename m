Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932514AbaIIPaf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 11:30:35 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:28297 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932237AbaIIPaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 11:30:30 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-57-540f1d12d26f
Message-id: <540F1D11.9030400@samsung.com>
Date: Tue, 09 Sep 2014 17:30:25 +0200
From: Jacek Anaszewski <j.anaszewski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
MIME-version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Kamil Debski <k.debski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 2/3] [media] s5p-jpeg: Fix compilation with COMPILE_TEST
References: <20140909124306.2d5a0d76@canb.auug.org.au>
 <6cbd00c5f2d342b573aaf9c0e533778374dd2e1e.1410273306.git.m.chehab@samsung.com>
 <b7343e6296b5d1d68b7229b8307442fd4141bcb3.1410273306.git.m.chehab@samsung.com>
 <540F15B2.3000902@samsung.com> <20140909120936.527bd852.m.chehab@samsung.com>
In-reply-to: <20140909120936.527bd852.m.chehab@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCLMWRmVeSWpSXmKPExsVy+t/xy7pCsvwhBp8uG1v8eH2BzaJ3wVU2
	i7NNb9gtNj2+xmpxedccNoueDVtZLQ4ubGO0mHF+H5PFxXXyFjtOLWK2OPymndVi696r7A48
	Ho03brB5bF6h5bF5Sb1H35ZVjB6fN8kFsEZx2aSk5mSWpRbp2yVwZTy+u5KxYDpPxczdixkb
	GOdxdTFyckgImEj8+tvNBmGLSVy4tx7I5uIQEljKKLHg5RxWCOcjo8T+Tf2MXYwcHLwCWhJT
	vuaAmCwCqhJXtgeC9LIJGEr8fPGaCcQWFYiQ+HN6HyuIzSsgKPFj8j0WEFtEwEDi8aKT7CAj
	mQWOMEvs6p4GViQs4CPReege1K4VTBJvHl1iB0lwClhLTPi5Aew6ZiB75aRtjBC2vMTmNW+Z
	JzAKzEKyZBaSsllIyhYwMq9iFE0tTS4oTkrPNdIrTswtLs1L10vOz93ECImJrzsYlx6zOsQo
	wMGoxMM7sYwvRIg1say4MvcQowQHs5IIr/ULoBBvSmJlVWpRfnxRaU5q8SFGJg5OqQbGpR8l
	D5095dw4PeGigoTnnOff8n5YSVxWEtqh8CTdadLpE8/iPkdvubTpwtEjrQ1vt72XfLyqi+W5
	/YyuhNNhKpzXzyeKfZFt+LzkvuG1tFetu6e+MZ+0yiTt+7zsN7k1OzeXn76VoL5T5cH5UoMA
	xwIbr2QxmRsV6sxbVq6x/Tx1Jdvl+auT65RYijMSDbWYi4oTAeJAQzJnAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro, Sylwester,

On 09/09/2014 05:09 PM, Mauro Carvalho Chehab wrote:
> Em Tue, 09 Sep 2014 16:58:58 +0200
> Sylwester Nawrocki <s.nawrocki@samsung.com> escreveu:
>
>> On 09/09/14 16:38, Mauro Carvalho Chehab wrote:
>>> ERROR: "__bad_ndelay" [drivers/media/platform/s5p-jpeg/s5p-jpeg.ko] undefined!
>>>
>>> Yet, it sounds a bad idea to use ndelay to wait for 100 us
>>> for the device to reset.
>>>
>>> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
>>> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
>>>
>>> diff --git a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
>>> index e51c078360f5..01eeacf28843 100644
>>> --- a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
>>> +++ b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
>>> @@ -23,7 +23,9 @@ void exynos4_jpeg_sw_reset(void __iomem *base)
>>>   	reg = readl(base + EXYNOS4_JPEG_CNTL_REG);
>>>   	writel(reg & ~EXYNOS4_SOFT_RESET_HI, base + EXYNOS4_JPEG_CNTL_REG);
>>>
>>> +#ifndef CONFIG_COMPILE_TEST
>>>   	ndelay(100000);
>>> +#endif
>>
>> Wouldn't be a better fix to replace ndelay(100000); with udelay(100),
>> rather than sticking in a not so pretty #ifndef ?
>
> Works for me. I'll submit a new version.
>
>> I guess usleep_range() couldn't simply be used, since
>> exynos4_jpeg_sw_reset() is called with a spinlock held.
>
> Ok.

Within few days I will perform some hardware tests, to verify
if there is more room for improvement here.

Best Regards,
Jacek Anaszewski
