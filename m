Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142AbaBEA7V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 19:59:21 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:55167 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbaBEA7T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 19:59:19 -0500
X-AuditID: cbfee68d-b7fcd6d00000315b-c5-52f18ce6cfe8
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <52F18CE4.1070700@samsung.com>
Date: Wed, 05 Feb 2014 09:59:16 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120411
 Thunderbird/11.0.1
To: Kyungmin Park <kmpark@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "thomas.abraham@linaro.org" <thomas.abraham@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        =?UTF-8?B?7LWc7LCs7Jqw?= <cw00.choi@samsung.com>
Subject: Re: [PATCH] clocksource: exynos4: Fix wrong bit operation in
 exynos4_mct_write()
References: <1391510892-27467-1-git-send-email-jonghwa3.lee@samsung.com>
 <CAH9JG2Ut4J=fQJ26RBafpB1WNe2Sd4Wv04L7xHns1=UxrhYoOQ@mail.gmail.com>
In-reply-to: <CAH9JG2Ut4J=fQJ26RBafpB1WNe2Sd4Wv04L7xHns1=UxrhYoOQ@mail.gmail.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsWyRsSkWPdZz8cggzMX2Cyuf3nOajHvs6zF
	rcurWCwu75rDZnG7cQWbxeZNU5ktjs1YwujA7rF5hZbHnWt72DzenTvH7tG3ZRWjx+dNcgGs
	UVw2Kak5mWWpRfp2CVwZ3dsPMxd0Clf8nXWDsYGxh6+LkZNDQsBE4vXL+cwQtpjEhXvr2boY
	uTiEBJYySnSsm8vSxcgBVrTyOSNIjZDAIkaJhb+dQWxeAUGJH5PvsYDYzALqEpPmLWKGsEUk
	jh35xQpha0ssW/iaGaL3NaPEq9XiEL1aEvt7XoLFWQRUJS7enAU2h01ATuJt0zewXaICYRJX
	JxwHi4sIaEhc3nWIGeQ2ZoHDTBInr7WwgySEBaIl7rxcyARxdD+jxI3d88A2cwoES8xdd5QF
	4rNL7BJrVmtAbBOQ+Db5ENRjshKbDkA9LylxcMUNlgmM4rOQ/DYLyW+zkPw2C8lvCxhZVjGK
	phYkFxQnpRcZ6hUn5haX5qXrJefnbmIERujpf896dzDePmB9iDEZaP1EZinR5HxghOeVxBsa
	mxlZmJqYGhuZW5qRJqwkzpv0MClISCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA+OBptcnBHJf
	b93+XdtJyKkxYPub9Znst22/CJ98P43NYMqCCZ2caqc8t+x1XuiksX7fUa5/826dvuSn7fyw
	OXWNu2hWncv1tmCR1peG77Xb3BiFG9elZs0rXp514lvT4mnt/5mf810+Hqq0THNJRaSiwusX
	7Byxqtbl83u8Pgc0peXv4979WUWJpTgj0VCLuag4EQAsdGTQ5gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOKsWRmVeSWpSXmKPExsVy+t9jAd2nPR+DDG4+s7a4/uU5q8W8z7IW
	ty6vYrG4vGsOm8XtxhVsFps3TWW2ODZjCaMDu8fmFVoed67tYfN4d+4cu0ffllWMHp83yQWw
	RjUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAXaGk
	UJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxhzOhtnc1a8FqoYtXMbUwNjO94
	uxg5OCQETCRWPmfsYuQEMsUkLtxbzwZiCwksYpRY+NsZxOYVEJT4MfkeC0g5s4C8xJFL2SBh
	ZgF1iUnzFjFDlL9mlHi1WhyiXEtif89LsDiLgKrExZuzWEBsNgE5ibdN38BWiQqESVydcBws
	LiKgIXF51yGgei6gmYeZJE5ea2EHSQgLREvcebmQCSQhJNDPKHFj9zxWkASnQLDE3HVHWSYw
	CsxCct8shPtmIblvASPzKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzgaH4mvYNxVYPFIUYB
	DkYlHl4D4Y9BQqyJZcWVuYcYJTiYlUR417YBhXhTEiurUovy44tKc1KLDzEmA703kVlKNDkf
	mGjySuINjU3MjCyNzA0tjIzNSRNWEuc92GodKCSQnliSmp2aWpBaBLOFiYNTqoGxN/boj5ML
	IzYF3vtoseqsFIPTzM6nEfNL9H/m3d5osnBf7jrzhUFJ2ZXGAraBue/c575YFeqyYt+jjJ/d
	ggF/5p7nMNNPYT37WNVx3oMV6bZLC6RVLvo6M4lFLtn5rJbJcPPlxeK7lyXFf7+89fKHmb3h
	806fWRn8L1muSHBK/73N9T/WLjlyQomlOCPRUIu5qDgRACKX52IqAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014년 02월 04일 22:01, Kyungmin Park wrote:

> 
> 
> On Tuesday, February 4, 2014, Jonghwa Lee <jonghwa3.lee@samsung.com
> <mailto:jonghwa3.lee@samsung.com>> wrote:
> 
>     There was a faulty bit operation during checking offset in exynos4_mct_write().
>     This patch fixes it correctly.
> 
> What's the issue? What's happened with current code? 


Whether it would be applied or not, current code looks working fine. Because
those things are just needed to confirm writing to certain register. The
technical reference manual recommends users to check write status register for
some specified registers, e.g. control register. However current code always
skip checking write status even we access the registers required. It will just
executed writing operation only and leave write status uncleared.

Thanks,
Jonghwa

> 
> Thank you,
> Kyungmin Park
> 
> 
>     Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com <javascript:;>>
>     Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com <javascript:;>>
>     ---
>      drivers/clocksource/exynos_mct.c |    4 ++--
>      1 file changed, 2 insertions(+), 2 deletions(-)
> 
>     diff --git a/drivers/clocksource/exynos_mct.c b/drivers/clocksource/exynos_mct.c
>     index 62b0de6..e60b019 100644
>     --- a/drivers/clocksource/exynos_mct.c
>     +++ b/drivers/clocksource/exynos_mct.c
>     @@ -94,8 +94,8 @@ static void exynos4_mct_write(unsigned int value, unsigned
>     long offset)
>             __raw_writel(value, reg_base + offset);
> 
>             if (likely(offset >= EXYNOS4_MCT_L_BASE(0))) {
>     -               stat_addr = (offset & ~EXYNOS4_MCT_L_MASK) + MCT_L_WSTAT_OFFSET;
>     -               switch (offset & EXYNOS4_MCT_L_MASK) {
>     +               stat_addr = (offset & EXYNOS4_MCT_L_MASK) + MCT_L_WSTAT_OFFSET;
>     +               switch (offset & ~EXYNOS4_MCT_L_MASK) {
>                     case MCT_L_TCON_OFFSET:
>                             mask = 1 << 3;          /* L_TCON write status */
>                             break;
>     --
>     1.7.9.5
> 
>     --
>     To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>     the body of a message to majordomo@vger.kernel.org <javascript:;>
>     More majordomo info at  http://vger.kernel.org/majordomo-info.html
>     Please read the FAQ at  http://www.tux.org/lkml/
> 


