Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbaI1IYn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 04:24:43 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:55642 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbaI1IYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 04:24:41 -0400
Message-ID: <5427C5C4.40508@codeaurora.org>
Date: Sun, 28 Sep 2014 11:24:36 +0300
From: Tanya Brokhman <tlinder@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>,
        Artem Bityutskiy <dedekind1@gmail.com>
CC: linux-arm-msm@vger.kernel.org, open list <linux-kernel@vger.kernel.org>,
        linux-mtd@lists.infradead.org,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] mtd: ubi: Extend UBI layer debug/messaging capabilities
References: <1411886185-7838-1-git-send-email-tlinder@codeaurora.org> <5427C046.5030608@nod.at>
In-Reply-To: <5427C046.5030608@nod.at>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/28/2014 11:01 AM, Richard Weinberger wrote:
> Tanya,
>
> Am 28.09.2014 08:36, schrieb Tanya Brokhman:
>> If there is more then one UBI device mounted, there is no way to
>> distinguish between messages from different UBI devices.
>> Add device number to all ubi layer message types.
>>
>>
>> Signed-off-by: Tanya Brokhman <tlinder@codeaurora.org>
>
> Artem's mail is dedekind1@ not dedeking1@. :)

oops.... sorry about that. thanks for the fix.

> Anyway, instead of passing ubi->ubi_num down to every log function you can
> just pass the ubi object itself and let the log function access ->ubi_num.

This is how I first implemented this patch. But then I cam across some 
ubi_err prints during the init process (in build.c ubi_init()) when we 
still don't have the ubi structure, so we need to pass some number to 
the message. I overcame this by using UBI_MAX_DEVICES.


-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, 
hosted by The Linux Foundation
