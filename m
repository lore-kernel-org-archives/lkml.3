Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbaI1Oy3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 10:54:29 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:36491 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbaI1Oy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 10:54:27 -0400
Message-ID: <5428211D.5090005@codeaurora.org>
Date: Sun, 28 Sep 2014 17:54:21 +0300
From: Tanya Brokhman <tlinder@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: linux-arm-msm@vger.kernel.org, open list <linux-kernel@vger.kernel.org>,
        dedeking1@gmail.com, linux-mtd@lists.infradead.org,
        Richard Weinberger <richard@nod.at>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [RFC/PATCH 1/5] mtd: ubi: Read disturb infrastructure
References: <1411886220-8208-1-git-send-email-tlinder@codeaurora.org> <1411906276.11836.21.camel@karhu>
In-Reply-To: <1411906276.11836.21.camel@karhu>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/28/2014 3:11 PM, Artem Bityutskiy wrote:
> On Sun, 2014-09-28 at 09:37 +0300, Tanya Brokhman wrote:
>> The need for performing read disturb is determined according to new
>> statistics collected per eraseblock:
>> - read counter: incremented at each read operation
>>                  reset at each erase
>> - last erase time stamp: updated at each erase
>>
>> This patch adds the infrastructure for the above statistics
>
> Would you please provide some kind of high level description for this
> stuff. What is the problem at hand, how is it solved. Right off-the top
> of my head I have the following comment.
>
> Adding more fields to 'struct ubi_wl_entry' should be well-justified.
> These objects are per-PEB, so there may be really a lot of them, and
> they may consume a lot of memory. Increasing the size of the object may
> be affect the memory consumption a lot.
>
> So I wonder if these read counters solve a big enough problem, so that
> they are worth having in this data structure.
>
> So I am really missing the bigger picture here.
>

Sure, will add a documentation file to describe the need for this and 
the algorithm itself.

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, 
hosted by The Linux Foundation
