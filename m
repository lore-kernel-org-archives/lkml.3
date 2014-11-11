Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117AbaKKIYq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 03:24:46 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:46109 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794AbaKKIYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 03:24:44 -0500
Message-ID: <5461C7C6.6060604@codeaurora.org>
Date: Tue, 11 Nov 2014 10:24:38 +0200
From: Tanya Brokhman <tlinder@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, Richard Weinberger <richard@nod.at>
CC: dedekind1@gmail.com, linux-mtd@lists.infradead.org,
        linux-arm-msm@vger.kernel.org,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V6] UBI: Extend UBI layer debug/messaging capabilities
References: <1415023112-21704-1-git-send-email-tlinder@codeaurora.org>	 <5460F7D8.2030100@nod.at> <1415642273.8868.8.camel@perches.com>
In-Reply-To: <1415642273.8868.8.camel@perches.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2014 7:57 PM, Joe Perches wrote:
> On Mon, 2014-11-10 at 18:37 +0100, Richard Weinberger wrote:
>> Am 03.11.2014 um 14:58 schrieb Tanya Brokhman:
>>> If there is more then one UBI device mounted, there is no way to
>>> distinguish between messages from different UBI devices.
>>> Add device number to all ubi layer message types.
>
> Adding "error" and "warning" to the message logs is
> duplicative to the KERN_<LEVEL> logging information.
>
>>> Changes from V5:
>>> 	- Added ptr verification @ ubi_err/ubi_msg/ubi_warn
>>> 	Removed extra printing of ubi number
>>> 	Removed new messages.
>
> Did you all ever look at what I posted?

I did. Its not my place to re-post your change in my patch. I personally 
prefer it the way I've done it but it's just a matter of opinion and 
personal preference. Artem took this one in...

>
> https://lkml.org/lkml/2014/10/14/280
>
> smaller code, consistent prefixing, consistent with
> typical kernel style, etc.
>
>> While testing I noticed that the log output looks quite different.
>>
>> e.g.
>> [   26.564111] UBI-0: ubi_attach_mtd_dev:default fastmap pool size: 256
>> [   26.565438] UBI-0: ubi_attach_mtd_dev:default fastmap WL pool size: 128
>
> If __func__ is really desired, it's generally better to
> put a space after the "%s:", __func__ so there's visual
> separation between the prefixes and the content.
>
> I agree that emitting function names isn't particularly
> useful.

I have to disagree here, but again - this is personal preference.

>
> (and Richard, do please remember to trim your posts,
>   you sent > 100KB of unnecessary quoted stuff)
>


Thanks,
Tanya Brokhman
-- 
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
