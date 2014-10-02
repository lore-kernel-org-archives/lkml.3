Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705AbaJBOOi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 10:14:38 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:51909 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919AbaJBOOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 10:14:37 -0400
Message-ID: <542D5DC9.1000206@codeaurora.org>
Date: Thu, 02 Oct 2014 17:14:33 +0300
From: Tanya Brokhman <tlinder@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>, dedekind1@gmail.com
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] UBI: Fastmap: Care about the protection queue
References: <1412029248-22454-1-git-send-email-richard@nod.at> <1412029248-22454-4-git-send-email-richard@nod.at> <542D5314.3050701@codeaurora.org> <542D540B.5010808@nod.at>
In-Reply-To: <542D540B.5010808@nod.at>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/2/2014 4:32 PM, Richard Weinberger wrote:
> Am 02.10.2014 15:28, schrieb Tanya Brokhman:
>> Hi Richard
>>
>> On 9/30/2014 1:20 AM, Richard Weinberger wrote:
>>> Fastmap can miss a PEB if it is in the protection queue
>>> and not jet in the used tree.
>>> Treat every protected PEB as used.
>>>
>>> Signed-off-by: Richard Weinberger <richard@nod.at>
>>> ---
>>>    drivers/mtd/ubi/fastmap.c | 13 +++++++++++++
>>>    1 file changed, 13 insertions(+)
>>>
>>> diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
>>> index 2b0d8d6..2853a69 100644
>>> --- a/drivers/mtd/ubi/fastmap.c
>>> +++ b/drivers/mtd/ubi/fastmap.c
>>> @@ -1195,6 +1195,19 @@ static int ubi_write_fastmap(struct ubi_device *ubi,
>>>            fm_pos += sizeof(*fec);
>>>            ubi_assert(fm_pos <= ubi->fm_size);
>>>        }
>>> +
>>> +    for (i = 0; i < UBI_PROT_QUEUE_LEN; i++) {
>>> +        list_for_each_entry(wl_e, &ubi->pq[i], u.list) {
>>
>> why not list_for_each_entry_safe?
>
> Because we don't delete elements from this list while iterating over it.
>
>>> +            fec = (struct ubi_fm_ec *)(fm_raw + fm_pos);
>>> +
>>> +            fec->pnum = cpu_to_be32(wl_e->pnum);
>>> +            fec->ec = cpu_to_be32(wl_e->ec);
>>> +
>>> +            used_peb_count++;
>>> +            fm_pos += sizeof(*fec);
>>> +            ubi_assert(fm_pos <= ubi->fm_size);
>>
>> Is fm_size ok with this addition or does it needs updating as well?
>
> It is okay. The fastmap size calculation reserves enough space for all possible
> PEBs.
>
> Thanks,
> //richard
>
> ______________________________________________________
> Linux MTD discussion mailing list
> http://lists.infradead.org/mailman/listinfo/linux-mtd/
>

Reviewed-by: Tanya Brokhman <tlinder@codeaurora.org>

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, 
hosted by The Linux Foundation
