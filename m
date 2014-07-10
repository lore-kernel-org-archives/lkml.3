Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829AbaGJLUG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 07:20:06 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:49849 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbaGJLUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 07:20:01 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-59-53be76dd39e4
Message-id: <53BE7691.3080604@samsung.com>
Date: Thu, 10 Jul 2014 14:18:41 +0300
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Marek Vasut <marex@denx.de>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-ima-devel@lists.sourceforge.net,
        linux-security-module <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-crypto <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH v3 1/3] ima: use ahash API for file hash calculation
References: <cover.1404475462.git.d.kasatkin@samsung.com>
 <201407092300.25224.marex@denx.de>
 <CACE9dm87U+Cc=jmbFiC=TuZ4D2mDNMUhbwVW64k14stXybZdHw@mail.gmail.com>
 <201407101002.07535.marex@denx.de>
In-reply-to: <201407101002.07535.marex@denx.de>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsVy+t/xq7p3y/YFG0x4a23xZWmdxf17P5ks
	Xs6Yx25xedccNosPPY/YLN60NTJafFoxidmB3WPerBMsHjtn3WX3eHBoM4vH7gWfmTw+b5IL
	YI3isklJzcksSy3St0vgyri65TtTwULBiq/ftjM3MD7k7WLk5JAQMJG4cPE+K4QtJnHh3nq2
	LkYuDiGBpYwSLVefsUA4jUwSv062MUI4sxgl7l86xwjSwiugJXFg4jYWEJtFQFVizeP5TCA2
	m4CexIbmH+wgtqhAhMSBvmesEPWCEj8m3wOrFxHwkfg/axUTyFBmgWYmiZ5/7WANwgIeEjdf
	f2GG2HaKUWLRiXNA3RwcnAL6Em/fgd3NLKAjsb91GhuELS+xec1bZhBbCOiI7rVr2SD+UZQ4
	Pfkc8wRG4VlIds9C0j4LSfsCRuZVjKKppckFxUnpuUZ6xYm5xaV56XrJ+bmbGCER83UH49Jj
	VocYBTgYlXh4X+zeEyzEmlhWXJl7iFGCg1lJhHeb3b5gId6UxMqq1KL8+KLSnNTiQ4xMHJxS
	DYzh87ROcH+Pl7BJNNoSeWwH75UPL510i2s0vp5LyVriVfF6W2hH84Xr/qsPxpcu+VGT+PnG
	Q8s/ArfcL3ecXFQgy7vZy89wo3Dog3TJ3Hu+3bw9zLceyhRPe72+xeKI1YHbm5wf3Uq7pVH/
	ysk8+r/4zIBsw/fLV98tSGu83RFbrVNyLsHCNEqJpTgj0VCLuag4EQA7FXUsdgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/14 11:02, Marek Vasut wrote:
> On Thursday, July 10, 2014 at 01:05:39 AM, Dmitry Kasatkin wrote:
>> On 10 July 2014 00:00, Marek Vasut <marex@denx.de> wrote:
>>> On Tuesday, July 08, 2014 at 10:07:16 AM, Dmitry Kasatkin wrote:
>>> [...]
>>>
>>>>> Right, but my concern is not about unloading the kernel module, but
>>>>> about the IMA module parameters left initialized.  The existing code
>>>>> will continue using ahash (software version), even though the kernel
>>>>> module was unloaded, not shash.  My question is about the software
>>>>> implementations of ahash vs. shash performance.
>>>>>
>>>>> Mimi
>>>> If HW driver will not be available, ahash loads generic driver which is
>>>> using shash.
>>>> Performance of that will be the same as for using shash directly.
>>> Hi Dmitry, I think Mimi is concerned about the crypto accelerator dying
>>> mid- flight.
>>>
>>> Imagine a situation where you have a hardware crypto accelerator
>>> connected via USB. You happily use IMA with this setup for days and then
>>> someone comes around and pulls the USB cable out. Will this be able to
>>> cope with such situation, for example by switching to software
>>> operations or such in some sane way ?
>>>
>>> I presume that's the concern here.
>>>
>>> Best regards,
>>> Marek Vasut
>> Hi Marek,
> Hi!
>
>> Nice to here from you. How was your rest stay at Japan?
> Thanks for asking, not sure there is a super-positive ultra-awesome word to 
> express that, so in short, I had the time of my life. Love that country ;-)
>
>> I have not seen any expression of such concern.
> All right, that was my understanding of the entire discussion -- an accelerator 
> dying mid-way and what will IMA do about that.
>
>> But as we fallback to early allocated shash, which is not USB yet,
>> then there is no problem.
>> ahash itself does not bring any other additional problem than shash itself.
>> They are compiled builtin together.
> Sure, I understood that. But what will happen if the ahash accelerator stops 
> working mid-flight, will IMA also go bonkers or is there some graceful stop?

shash fallback will be used.

> Best regards,
> Marek Vasut
>

