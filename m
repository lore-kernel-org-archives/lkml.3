Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318AbaJNMVb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 08:21:31 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:32893 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932227AbaJNMV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 08:21:29 -0400
Message-ID: <543D1545.8090209@codeaurora.org>
Date: Tue, 14 Oct 2014 15:21:25 +0300
From: Tanya Brokhman <tlinder@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: dedekind1@gmail.com, Richard Weinberger <richard@nod.at>
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] UBI: Fastmap: Care about the protection queue
References: <1412029248-22454-1-git-send-email-richard@nod.at> <1412029248-22454-4-git-send-email-richard@nod.at> <1412346676.3795.62.camel@sauron.fi.intel.com> <542EF3BF.1070401@nod.at> <1413206263.7906.18.camel@sauron.fi.intel.com> <543BE21F.5020504@nod.at> <1413213803.7906.45.camel@sauron.fi.intel.com> <543C3E60.4080507@nod.at> <1413282203.7906.72.camel@sauron.fi.intel.com>
In-Reply-To: <1413282203.7906.72.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2014 1:23 PM, Artem Bityutskiy wrote:
> On Mon, 2014-10-13 at 23:04 +0200, Richard Weinberger wrote:
>> Am 13.10.2014 um 17:23 schrieb Artem Bityutskiy:
>>> Well, used and free are RB-trees, looking them up is slow.
>>
>> This is true but we'd have to look it up in multiple trees and the protection queue...
>
> Right. 2 RB-trees, and one list. The list is empty most of the time, or
> contains one element.
>
> So we'd look-up 2 RB-trees most of the time. Very rarely we'd need to
> look at the list containing very few elements.
>
> Not that bad, I think.
>
>> ubi_update_fastmap() takes ubi->wl_lock anyway to block any changes in the free, used, etc. trees
>> to make sure that the to be taken state snapshot is consistent.
>
> I think this is fine.
>
>>> But there is a price - memory consumption. We do not want to pay it just
>>> for making the inter-subsystems boundaries better, there ought to be a
>>> better reason.
>>>
>>> Say, for an (imaginary) 8GiB NAND chip with 128KiB PEB size this would
>>> cost 256KiB of RAM.
>>
>> Is 128KiB PEB size still realistic on modern NANDs?
>> Even if, 256KiB are not much and the kernel consumes this additionally with
>> every new release.
>
> Right, but the point is that bigger systems use eMMC and wouldn't bother
> with raw flash. Raw flash trending down the smaller systems, where a
> hundred of kilobytes matters.
>
>> But I can understand your concerns.
>
> Thanks, yes, my point is to be careful about the RAM we consume, and try
> to avoid growing this data structure, an only do it if we have to.
>
>> Okay, I'll try harder to make you happy.
>
> Well, making me happy is not the point of course :-)
>
> Thanks!
>
> --
> Artem
>
>
> ______________________________________________________
> Linux MTD discussion mailing list
> http://lists.infradead.org/mailman/listinfo/linux-mtd/
>

Hi Artem/Richard

I think your discussion here stopped being relevant to this specific 
patch but went on to the fastmap feature design in general :)
This patch fixes a real bug in the current implementation of the 
feature. What you're discussing requires a re-writing and re-design of 
the feature. Perhaps this one can be merged and will be "fixed" later on 
when you agree on how you would like FM to access WL data structures in 
general?

Thanks,
Tanya Brokhman
-- 
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
