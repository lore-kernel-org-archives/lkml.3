Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbaH1LvI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 07:51:08 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:25240 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbaH1LvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 07:51:06 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-5a-53ff17a74ae5
Message-id: <53FF17A0.1030100@samsung.com>
Date: Thu, 28 Aug 2014 15:50:56 +0400
From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Icedove/24.7.0
MIME-version: 1.0
To: Will Deacon <will.deacon@arm.com>, Jassi Brar <jassisinghbrar@gmail.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vitaly Andrianov <vitalya@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/2] ARM: LPAE: load upper bits of early TTBR0/TTBR1
References: <20140722153623.25088.37742.stgit@buzz>
 <20140728181224.GN15536@arm.com>
 <CALYGNiNrK1d32ecz4rw0sgn0GyN-M6hTBuTLGQV53Z4Br-bpYQ@mail.gmail.com>
 <20140728184741.GT15536@arm.com>
 <CALYGNiOd+Dy-2q_woZ9UDbMO24q58jN1Nsq7E8cJMMg_YBK9pA@mail.gmail.com>
 <CABb+yY17Y18oAivi_VxPJqDEGLTbEy_PfsdeK9jXWZ0iV3vZ=w@mail.gmail.com>
 <CALYGNiN-SHr6YJ53_deizb1VoXTBzD7dn8hcwqd4zLjx6utCDw@mail.gmail.com>
 <CABb+yY1VsEwDi5XCRkKbSNPW_+_MgL4gdAChKgX_NGHRzXq6qw@mail.gmail.com>
 <20140828110300.GJ22580@arm.com>
In-reply-to: <20140828110300.GJ22580@arm.com>
Content-type: multipart/mixed; boundary=------------090800030109080201040602
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMLMWRmVeSWpSXmKPExsVy+t/xy7rLxf8HG8xu57C4tmIuu8XKzges
	FpseX2O1uLxrDpvF7cu8Fn2f7rNYvPx4gsWB3WPNvDWMHi3NPWweO2fdZffYvKTe4/iN7Uwe
	nzfJBbBFcdmkpOZklqUW6dslcGUsP76HreCIdMX8ly2MDYz/RLsYOTkkBEwknt94zgJhi0lc
	uLeerYuRi0NIYCmjxMfONSwQzidGiZdLZ7CBVPEKaEl8uNzJDmKzCKhKbHn8ghXEZhMwk9i2
	7zYjiC0qECLx5Okxdoh6QYkfk++BbRAR8JF4u28d2AZmgR4miTP3loEVCQt4SJy8vIoZYtt/
	Zolvj/cwgyQ4BXQlpk97AGYzA3Uf/HiPZQIj/ywkg2chSc1i5ACyrSW+7S6CCMtLbH87hxnC
	LpRY2drIgioOckcDo8TMtt1sCxjZVzGKppYmFxQnpeca6RUn5haX5qXrJefnbmKERM7XHYxL
	j1kdYhTgYFTi4VU4/SdYiDWxrLgy9xCjCtCgRxtWX2CUYsnLz0tVEuGd9udfsBBvSmJlVWpR
	fnxRaU5q8SFGJg5OqQbGOYpPTfTeTXm37Hra+a/L3l1inNy0Om5C6z4nv7Ay5rVVWmt8HLQ/
	e9ysuLC0ab9BZ/ljY4bjKQF/bgptLbzt1bzl+mXRR1fXTQk/zL9F4ESKwLVZ3mIpzdsMNRnb
	pl8XOvos1klBvm1mmPn86+nF540n2+durr0Qc/vbv4ov7SbW3UueFb2Zr8RSnJFoqMVcVJwI
	AFV1gqKGAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090800030109080201040602
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


On 2014-08-28 15:03, Will Deacon wrote:
> On Wed, Aug 27, 2014 at 04:45:24PM +0100, Jassi Brar wrote:
>> On Wed, Aug 27, 2014 at 9:01 PM, Konstantin Khlebnikov <koct9i@gmail.com> wrote:
>>> On Wed, Aug 27, 2014 at 7:26 PM, Jassi Brar <jassisinghbrar@gmail.com> wrote:
>>>> It seems the patch wasn't tested on any real platform, I did on my
>>>> CA15 based platform - it breaks boot. Simply reverting the patch gets
>>>> it going again. I am happy to try any fix.
>>>>
>>> Please try to remove adcls line.
>>> Seems like this affects only systems where PHYS_OFFSET == PAGE_OFFSET.
>>>
>>> --- a/arch/arm/mm/proc-v7-3level.S
>>> +++ b/arch/arm/mm/proc-v7-3level.S
>>> @@ -146,7 +146,6 @@ ENDPROC(cpu_v7_set_pte_ext)
>>>          mov     \tmp, \ttbr1, lsr #(32 - ARCH_PGD_SHIFT)        @ upper bits
>>>          mov     \ttbr1, \ttbr1, lsl #ARCH_PGD_SHIFT             @ lower bits
>>>          addls   \ttbr1, \ttbr1, #TTBR1_OFFSET
>>> -       adcls   \tmp, \tmp, #0
>>>          mcrr    p15, 1, \ttbr1, \tmp, c2                        @ load TTBR1
>>>          mov     \tmp, \ttbr0, lsr #(32 - ARCH_PGD_SHIFT)        @ upper bits
>>>          mov     \ttbr0, \ttbr0, lsl #ARCH_PGD_SHIFT             @ lower bits
>>>
>> Yup, restores boot.
> Can somebody write this up as a proper patch and put it in the patch system
> please?

Ok. Done.

http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=8132/1

>
> Will
>


--------------090800030109080201040602
Content-Type: text/plain; charset=UTF-8;
 name="arm-lpae-remove-carry-flag-correction-after-adding-ttbr1_offset"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="arm-lpae-remove-carry-flag-correction-after-adding-ttbr1_off";
 filename*1="set"

ARM: LPAE: drop wrong carry flag correction after adding TTBR1_OFFSET

From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>

In commit 7fb00c2fca4b6c58be521eb3676cf4b4ba8dde3b ("ARM: 8114/1: LPAE:
load upper bits of early TTBR0/TTBR1") part which fixes carrying in adding
TTBR1_OFFSET to TTRR1 was wrong:

	addls   \ttbr1, \ttbr1, #TTBR1_OFFSET
	adcls   \tmp, \tmp, #0

addls doesn't update flags, adcls adds carry from cmp above:

	cmp	\ttbr1, \tmp			@ PHYS_OFFSET > PAGE_OFFSET?

Condition 'ls' means carry flag is clear or zero flag is set, thus only one
case is affected: when PHYS_OFFSET == PAGE_OFFSET.

It seems safer to remove this fixup. Bug is here for ages and nobody
complained. Let's fix it separately.

Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Reported-and-tested-by: Jassi Brar <jassisinghbrar@gmail.com>
---
 arch/arm/mm/proc-v7-3level.S |    1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/mm/proc-v7-3level.S b/arch/arm/mm/proc-v7-3level.S
index 1a24e92..b64e67c 100644
--- a/arch/arm/mm/proc-v7-3level.S
+++ b/arch/arm/mm/proc-v7-3level.S
@@ -146,7 +146,6 @@ ENDPROC(cpu_v7_set_pte_ext)
 	mov	\tmp, \ttbr1, lsr #(32 - ARCH_PGD_SHIFT)	@ upper bits
 	mov	\ttbr1, \ttbr1, lsl #ARCH_PGD_SHIFT		@ lower bits
 	addls	\ttbr1, \ttbr1, #TTBR1_OFFSET
-	adcls	\tmp, \tmp, #0
 	mcrr	p15, 1, \ttbr1, \tmp, c2			@ load TTBR1
 	mov	\tmp, \ttbr0, lsr #(32 - ARCH_PGD_SHIFT)	@ upper bits
 	mov	\ttbr0, \ttbr0, lsl #ARCH_PGD_SHIFT		@ lower bits

--------------090800030109080201040602--
