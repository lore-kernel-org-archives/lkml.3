Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398AbaLHNU0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 08:20:26 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144AbaLHNUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 08:20:25 -0500
Message-ID: <5485A596.3020304@nod.at>
Date: Mon, 08 Dec 2014 14:20:22 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Tanya Brokhman <tlinder@codeaurora.org>, dedekind1@gmail.com
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] UBI: Fastmap: Notify user in case of an ubi_update_fastmap()
 failure
References: <1417347340-6872-1-git-send-email-richard@nod.at> <1417347340-6872-4-git-send-email-richard@nod.at> <54845D53.1070903@codeaurora.org> <548462A8.2010107@nod.at> <54854C28.4050107@codeaurora.org> <54856B54.7020306@nod.at> <5485A0E8.4050901@codeaurora.org>
In-Reply-To: <5485A0E8.4050901@codeaurora.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 08.12.2014 um 14:00 schrieb Tanya Brokhman:
>>>>> Why do you fail the whole function (ubi_wl_get_peb) if fastmap update failed? Its possible that the fm_pools were refilled correctly, and the actual fastmap_write failed, so
>>>>> there
>>>>> is nothing preventing the user to get peb allocated and continue working. You invalidate the fastmap, so if powercut occurs a full scan will be performed. So its possible to
>>>>> allocate from fm_pools (although fastmap is not valid on disc) and try writing fastmap again when the pools filled up.
>>>>> I'm for the ubi_msg but against "return -ENOSPC;"
>>>>
>>>> Maybe the case you've described is powercut safe, but there can be other unsafe cases.
>>>> Let's stay on the safe side and be paranoid, it does not hurt.
>>>> If fastmap has proven stable we can start with tricky optimizations.
>>>
>>> I'm sorry that I'm being petty here but the commit msg states that you "notify the user in case of update fastamap failure". It says nothing about you failing ubi_wl_get_peb as
>>> well. And this is a major change. At least divide this into 2 patches (so I can disagree to the function failing and agree to the msg to user :) )
>>
>> With user I meant users of that function.
> 
> I still don't like it.
> Leaving this one for Artem... sorry

BTW: With my latest patch applied "[PATCH] UBI: Fastmap: Fix possible fastmap inconsistency" your assumption that we
can have the pools refilled in case if an ubi_update_fastmap() error is no longer correct.
Before my patch ubi_update_fastmap() the pools have been refilled much too early, this is an bug and got fixed.

Thanks,
//richard
