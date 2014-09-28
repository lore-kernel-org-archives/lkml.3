Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865AbaI1Kq3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 06:46:29 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:59540 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbaI1Kq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 06:46:27 -0400
Message-ID: <5427E6FE.3090906@codeaurora.org>
Date: Sun, 28 Sep 2014 13:46:22 +0300
From: Tanya Brokhman <tlinder@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>, dedeking1@gmail.com
CC: Artem Bityutskiy <dedekind1@gmail.com>, linux-arm-msm@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        linux-mtd@lists.infradead.org,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [RFC/PATCH 1/5] mtd: ubi: Read disturb infrastructure
References: <1411886220-8208-1-git-send-email-tlinder@codeaurora.org> <5427C45C.2080506@nod.at> <5427CB6E.7010007@codeaurora.org> <5427CCD8.2090605@nod.at>
In-Reply-To: <5427CCD8.2090605@nod.at>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/28/2014 11:54 AM, Richard Weinberger wrote:
> Am 28.09.2014 10:48, schrieb Tanya Brokhman:
>>>> @@ -424,6 +440,8 @@ struct ubi_fm_sb {
>>>>        __be32 used_blocks;
>>>>        __be32 block_loc[UBI_FM_MAX_BLOCKS];
>>>>        __be32 block_ec[UBI_FM_MAX_BLOCKS];
>>>> +    __be32 block_rc[UBI_FM_MAX_BLOCKS];
>>>> +    __be64 block_let[UBI_FM_MAX_BLOCKS];
>>>
>>> Doesn't this break the fastmap on-disk layout?
>>
>> What do you mean "break"? I verified fastmap feature is working. the whole read-disturb depends on it so I tested this thoroughly.
>
> Did you write a fastmap with your changes applied and then an attach using a fastmap implementation *without*
> you changes?
> I bet it will not work because the disk layout is now different.

you're right, it wont work. I did a set of attach/detach tests to verify 
fastmap, but of course with my changes.

> Linux is not the only user of fastmap. We need to be very careful here.

Could you please elaborate here? I'm not sure I understand the use case 
you're referring to.

>
> Thanks,
> //richard
>
> ______________________________________________________
> Linux MTD discussion mailing list
> http://lists.infradead.org/mailman/listinfo/linux-mtd/
>


-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, 
hosted by The Linux Foundation
