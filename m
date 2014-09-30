Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873AbaI3ICb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 04:02:31 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:51586 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbaI3IC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 04:02:28 -0400
Message-ID: <542A638F.6090703@codeaurora.org>
Date: Tue, 30 Sep 2014 11:02:23 +0300
From: Tanya Brokhman <tlinder@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: dedeking1@gmail.com, linux-mtd@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mtd: ubi: Extend UBI layer debug/messaging capabilities
References: <1411886185-7838-1-git-send-email-tlinder@codeaurora.org> <1411905665.11836.15.camel@karhu>
In-Reply-To: <1411905665.11836.15.camel@karhu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/28/2014 3:01 PM, Artem Bityutskiy wrote:
> On Sun, 2014-09-28 at 09:36 +0300, Tanya Brokhman wrote:
>> If there is more then one UBI device mounted, there is no way to
>> distinguish between messages from different UBI devices.
>> Add device number to all ubi layer message types.
>
> Hi, the goal looks legit to me, but the patch is so large that I do not
> think that I can really review it in this form.
>
> a) A patch which changes the macros (ubi_err(), etc)

If I divide the patches like this, patch (a) wont compile

> b) A set of patches which do not change messages at all, but add the
> 'ubi' parameter to the places where it is missing.
> c) A patch which changes the messages.

I think patches (b)+(C) can be combined into one patch. Don't you agree? 
I changed ~2 or 3 messages that were printing ubi number by themselves. 
No need for a separate patch for this. Don't you agree?

>
> So a) will be the most important patch for the reviewer. b) - more or
> less mechanical changes of a similar kind. c) - the same.
>
> Also, if you add a parameter to 'ubi_err()' and the other printing
> wrappers, add 'ubi' there, not 'ubi_num'. This will allow to prefix
> messages with vary different things, not just the device number in the
> future. So the calls would look like
>
> ubi_err(ubi, "inconsistent used_ebs");
>
> Once this is done, the series should be more reviewable. The next thing
> I'd check is whether we really need to change all the messages, or most
> of them, or we actually need to change only a small part of them. In the
> former case, it is OK to do what you do, I guess. In the latter case we
> probably better off with introducing a separate set of printing macros
> and leave the existing ones as they are.

Large portion of the messages needs updating. I think perhaps I'll 
overcome the messages during init (when I don't' have the ubi yet) in a 
different manner and add "ubi" not "ubi_num" parameter to the macros, as 
you suggested

>
> Thanks!
>


-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, 
hosted by The Linux Foundation
