Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965815AbaDJKiU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 06:38:20 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:19996 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934795AbaDJKiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 06:38:16 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-3b-53467497d6e2
Message-id: <53467499.5000909@samsung.com>
Date: Thu, 10 Apr 2014 19:38:17 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, kgene.kim@samsung.com,
        t.figa@samsung.com, linux-samsung-soc@vger.kernel.org,
        hyunhee.kim@samsung.com, sw0312.kim@samsung.com,
        linux-kernel@vger.kernel.org, yj44.cho@samsung.com,
        inki.dae@samsung.com, kyungmin.park@samsung.com
Subject: Re: [PATCH 06/27] ARM: EXYNOS:: Enter a15 lowpower mode for Exynos3250
 based on Cortex-a7
References: <1397122124-15690-1-git-send-email-cw00.choi@samsung.com>
 <1397122124-15690-7-git-send-email-cw00.choi@samsung.com>
 <4896629.u0Ek9zNPG2@wuerfel>
In-reply-to: <4896629.u0Ek9zNPG2@wuerfel>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsWyRsSkQHdGiVuwwZYuRou/k46xW3z+0MJu
	Men+BBaL3gVX2SzONr1ht9j0+BqrxeVdc9gsZpzfx2QxY/JLNov1M16zWOzdOZnRgdvj969J
	jB6bl9R79G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8abJY8ZCyYyVZycsJipgfEkYxcjJ4eE
	gInEt/drWSFsMYkL99azdTFycQgJLGWUWHF9KTNM0ezNq6ASixgljk7bANYhJPCaUeLkX4Mu
	Rg4OXgEtif8zhEBMFgFViX+vQ0Aq2ICi+1/cYAOxRQXCJFZOv8ICYvMKCEr8mHwPzBYRUJSY
	+uIZ2CpmgUlMEpPPcIHYwgIpEhN6IOqFBBYwSkx4kw0ynlNAU+LnXQGIch2J/a3T2CBseYnN
	a94yg1wpIfCIXeL37ZtgCRYBAYlvkw+xgPRKCMhKbDoA9ZWkxMEVN1gmMIrNQnLRLCRjZyEZ
	u4CReRWjaGpBckFxUnqRqV5xYm5xaV66XnJ+7iZGYDSe/vds4g7G+wesDzEmA62cyCwlmpwP
	jOa8knhDYzMjC1MTU2Mjc0sz0oSVxHnTHyUFCQmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamC0
	+qWVIfPqdZ/f+TVFHBscd/Ktq/SL3D3BzvBHoPgpgwk//7mbK0/inPCo6eMDc7lpj25NPKdu
	smva9496s9M5VOLmlwfP/7brXnkoG/8d316z/7c6p+1rP9x38uxbvR1J5VfyeV9IpLT2+RWI
	OK5/UrRqm1mWGvd7PZZD3zifHDH2XrT4b/d1JZbijERDLeai4kQAZYdA6dwCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGKsWRmVeSWpSXmKPExsVy+t9jAd3pJW7BBtdmmVn8nXSM3eLzhxZ2
	i0n3J7BY9C64ymZxtukNu8Wmx9dYLS7vmsNmMeP8PiaLGZNfslmsn/GaxWLvzsmMDtwev39N
	YvTYvKTeo2/LKkaPz5vkAliiGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU
	8hJzU22VXHwCdN0yc4CuUlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBm
	vFnymLFgIlPFyQmLmRoYTzJ2MXJySAiYSMzevIoNwhaTuHBvPZDNxSEksIhR4ui0DawgCSGB
	14wSJ/8adDFycPAKaEn8nyEEYrIIqEr8ex0CUsEGFN3/4gbYGFGBMImV06+wgNi8AoISPybf
	A7NFBBQlpr54xgxiMwtMYpKYfIYLxBYWSJGY0ANRLySwgFFiwptskPGcApoSP+8KQJTrSOxv
	ncYGYctLbF7zlnkCo8AsJBtmISmbhaRsASPzKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzg
	WH8mtYNxZYPFIUYBDkYlHt4Dy1yDhVgTy4orcw8xSnAwK4nw7s50CxbiTUmsrEotyo8vKs1J
	LT7EmAz0/0RmKdHkfGAayiuJNzQ2MTOyNDI3tDAyNidNWEmc90CrdaCQQHpiSWp2ampBahHM
	FiYOTqkGRpVEvr9Kz0vapzxs3bHK/JV0SLucudGHZ/sCq1s+HnCN0D2wcrWv0fIl0xc0XLm5
	IrdyYYfShUPrC6IzuIqtU+2ndxxzmxhxr/hE+xKug6r5/rO6JA5ceskrP/PM9/WP6p7L3pyo
	c+jg2p9TG0rzjjrF2nJc/F8fdEq9/r5/x98+Fr2zVmrqxUosxRmJhlrMRcWJAFRuh5k5AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2014 06:40 PM, Arnd Bergmann wrote:
> On Thursday 10 April 2014 18:28:23 Chanwoo Choi wrote:
>> +        * while Exynos5 is A15/Exynos7 is A7; check the CPU part
>>
> 
> Exynos7 -> Exynos3 ?
> 

You're right. I'll fix it.

Best Regards,
Chanwoo Choi

