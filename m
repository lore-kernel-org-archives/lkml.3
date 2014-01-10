Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165AbaAJQ6I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 11:58:08 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:43301 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbaAJQ6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 11:58:04 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-b2-52d0269a56a1
Message-id: <52D02693.1040003@samsung.com>
Date: Fri, 10 Jan 2014 17:57:55 +0100
From: Tomasz Figa <t.figa@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.1
MIME-version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Mj Embd <mj.embd@gmail.com>
Cc: linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc@vger.kernel.org
Subject: Re: Arndale Timer Interrupt Question
References: <CAPUj1OM=Zn2nd98aXRCRUJrLknkS0o44V1BfuJhz5i19w+M5Ow@mail.gmail.com>
 <1437466.9hkS4zH5MN@amdc1032>
In-reply-to: <1437466.9hkS4zH5MN@amdc1032>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsVy+t/xy7qz1C4EGdxZJG6xccZ6Vov3h54x
	W1zeNYfNYsb5fUwWB3oOsTmweuycdZfd4/a/x8wefVtWMXp83iQXwBLFZZOSmpNZllqkb5fA
	lbHuy2XWgn9cFacnrGRuYLzK0cXIySEhYCJxp+crO4QtJnHh3nq2LkYuDiGBpYwSh162MUE4
	nxkltjx5xwJSxSugJbH2zztGEJtFQFXi3PyXTCA2m4CaxOeGR2wgtqhAhMTfeesZIeoFJX5M
	vgfUy8EhIhAucbVDH2Qms8AMRokZf5+B1QsL6Eo8/3KNGcQWEiiSmHv9KNguTqBd8/5NA6th
	FjCTeNSyjhnClpfYvOYt8wRGgVlIVsxCUjYLSdkCRuZVjKKppckFxUnpuYZ6xYm5xaV56XrJ
	+bmbGCGB/GUH4+JjVocYBTgYlXh4A0QuBAmxJpYVV+YeYpTgYFYS4RWWAgrxpiRWVqUW5ccX
	leakFh9iZOLglGpgFOjScwthiVxww8u3f0P5b7cvWRUXDm94NmPBlNrT+y2yBIs/+V4sNBRd
	+4BxZhF/gpW1rvGBn1cWdGhYf9NXCpn8Pvhq1O5J/NtMKpwMdz1q1rUt3s7HWdarHaUQccnE
	O1vs8LJJP+ZmHmB2F58Z92Xh2te/3l23sDJef+pma425odyJY9enKLEUZyQaajEXFScCAP1H
	PqNCAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 09.01.2014 13:52, Bartlomiej Zolnierkiewicz wrote:
>
> added linux-samsung-soc to cc:,
> it is a better suited list for this question
>
> On Thursday, January 09, 2014 10:30:56 AM Mj Embd wrote:
>> I am a bit confused on the interrupt number for CNTVIRQ..CNTHPIRQ. Can
>> you please help here.
>>
>> As per the exynos5 public manual
>> What is the difference between  CPU_nCNTHPIRQ[0] and CNTHPIRQ.

I'm not sure if this is really what I think it is, but looking at the 
manual, CPU_nCNTHPIRQ[0] and [1] SPI ports and CNTHPIRQ PPI port seem to 
be the same signals, with the difference that the first two are shared 
interrupts connected through the combiner, while the last one is a 
per-processor interrupt, directly connected to GIC PPI port, allowing 
each CPU to get its own CNTHPIRQ signal ([0] for CPU 0 and [1] for CPU 1).

Best regards,
Tomasz

>>
>> While the later has an interrupt ID 26, the former is part of a group
>> with combined interrupt id as 33 for core 0 and 54 for core 1.
>>
>> For a timer interrupt which goes to PL2, which id should be used 26 or
>> 33 for core 0 ?
>>
>> Please clear this confusion.
>>
>> Many Thanks
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
