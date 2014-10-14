Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932230AbaJNMOz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 08:14:55 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:60959 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073AbaJNMOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 08:14:53 -0400
Message-ID: <543D13B8.6010006@codeaurora.org>
Date: Tue, 14 Oct 2014 15:14:48 +0300
From: Tanya Brokhman <tlinder@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: dedekind1@gmail.com, Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
CC: linux-arm-msm@vger.kernel.org, open list <linux-kernel@vger.kernel.org>,
        linux-mtd@lists.infradead.org, Richard Weinberger <richard@nod.at>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH v3] mtd: ubi: Extend UBI layer debug/messaging capabilities
References: <1412593268-12377-1-git-send-email-tlinder@codeaurora.org>	 <1413214637.7906.49.camel@sauron.fi.intel.com> <1413215953.7906.63.camel@sauron.fi.intel.com>
In-Reply-To: <1413215953.7906.63.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2014 6:59 PM, Artem Bityutskiy wrote:
> On Mon, 2014-10-13 at 18:37 +0300, Artem Bityutskiy wrote:
>> On Mon, 2014-10-06 at 14:01 +0300, Tanya Brokhman wrote:
>>> If there is more then one UBI device mounted, there is no way to
>>> distinguish between messages from different UBI devices.
>>> Add device number to all ubi layer message types.
>>
>> Looks good to me, pushed to the master branch of the linux-ubifs.git
>> tree. Later, when the merge window is closed, I'll merge this patch to
>> the linux-next branch too.
>
> Tanya,
>
> sorry, I was not careful enough, I merged it and tested against the
> Linuses head, it is fine.
>
> But it does not apply the the linux-ubifs.git tree. There are conflicts.
>
> But more importantly, you did not get the 'block.c' right. There we use
> the same printing macros, but we do not have 'struct ubi_info' there at
> all.
>
> Please, enable the R/O block layer feature and try to compile, it'll
> fail.
>
> The block driver is in 'drivers/mtd/ubi', but it is kind of a separate
> driver - it does not access the internal UBI data structures.
>
> I guess the solution would be to just use pr_* functions there instead.
>
> CCing Ezequiel.
>
> Please, submit a patch against the 'linux-next' branch of this tree:
>
> git://git.infradead.org/linux-ubifs.git
>
>
> Artem.
>

Ok, will do ASAP.

Thanks,
Tanya Brokhman
-- 
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
