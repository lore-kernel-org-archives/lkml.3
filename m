Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334AbaLHJj0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 04:39:26 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051AbaLHJjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 04:39:25 -0500
Message-ID: <548571CA.90803@nod.at>
Date: Mon, 08 Dec 2014 10:39:22 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Tanya Brokhman <tlinder@codeaurora.org>, dedekind1@gmail.com
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] UBI: Fastmap: Don't allocate new ubi_wl_entry objects
References: <1417347340-6872-1-git-send-email-richard@nod.at> <1417347340-6872-3-git-send-email-richard@nod.at> <54856305.2070408@codeaurora.org> <54856BE6.5090003@nod.at> <54857155.3040801@codeaurora.org>
In-Reply-To: <54857155.3040801@codeaurora.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 08.12.2014 um 10:37 schrieb Tanya Brokhman:
> On 12/8/2014 11:14 AM, Richard Weinberger wrote:
>> Am 08.12.2014 um 09:36 schrieb Tanya Brokhman:
>>> On 11/30/2014 1:35 PM, Richard Weinberger wrote:
>>>> There is no need to allocate new ones every time, we can reuse
>>>> the existing ones.
>>>> This makes the code cleaner and more easy to follow.
>>>>
>>>> Signed-off-by: Richard Weinberger <richard@nod.at>
>>>> ---
>>>>    drivers/mtd/ubi/fastmap.c | 31 +++++--------------------------
>>>>    drivers/mtd/ubi/wl.c      | 11 +++++++----
>>>>    2 files changed, 12 insertions(+), 30 deletions(-)
>>>>
>>>> diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
>>>> index db3defd..9507702 100644
>>>> --- a/drivers/mtd/ubi/fastmap.c
>>>> +++ b/drivers/mtd/ubi/fastmap.c
>>>> @@ -1446,19 +1446,6 @@ int ubi_update_fastmap(struct ubi_device *ubi)
>>>>        }
>>>>
>>>>        new_fm->used_blocks = ubi->fm_size / ubi->leb_size;
>>>
>>> Not related to this patch, but looking at this function it got me thinking: why do we need to re-calculate new_fm->used_blocks (and check calculated value) each time? fm_size
>>> doesn't changed at runtime. leb_size sure does not, so fm->used_blocks can be ubi device parameter and calculated & tested only once, and not each time we write fastmap. Correct?
>>
>> If you dig deeper into the patch set you'll notice that the fastmap size can change. :-)
>>
> 
> oh, ok. sorry, still in the middle of the review.

This is perfectly fine.
I really a appreciate your reviews!

Thanks,
//richard
