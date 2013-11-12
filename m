Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387Ab3KLRGk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 12:06:40 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:49123 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756319Ab3KLRGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 12:06:39 -0500
Message-ID: <5282601D.9010109@codeaurora.org>
Date: Tue, 12 Nov 2013 09:06:37 -0800
From: Olav Haugan <ohaugan@codeaurora.org>
Organization: Qualcomm Innovation Center, Inc.
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: ngupta@vflare.org, sjenning@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, minchan@kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v2] staging: zsmalloc: Ensure handle is never 0 on success
References: <1383875883-30597-1-git-send-email-ohaugan@codeaurora.org> <20131112001902.GA1043@kroah.com>
In-Reply-To: <20131112001902.GA1043@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On 11/11/2013 4:19 PM, Greg KH wrote:
> On Thu, Nov 07, 2013 at 05:58:03PM -0800, Olav Haugan wrote:
>> zsmalloc encodes a handle using the pfn and an object
>> index. On hardware platforms with physical memory starting
>> at 0x0 the pfn can be 0. This causes the encoded handle to be
>> 0 and is incorrectly interpreted as an allocation failure.
> 
> Please list the known hardware platforms that have this issue, so that
> people have a chance to know if this patch is relevant for them or not.
> 
> For example, should I include this in the stable releases because it
> affects systems that are shipping?  Or is it just in "future" chips and
> it doesn't need to go there or not?
> 
> Please make it easy for me to do this type of determination, I already
> asked you this question before, why didn't you include the information
> here as well (hint, that is why I asked you...)

I don't think it would be the best to mention specific hardware
platforms in the commit text. If I saw this patch listing specific
hardware platforms I would have made the wrong decision (I would look at
the list and decide that I am not running on those platforms so I don't
need this patch). The problem could happen on any hardware platform. It
just depends on how the memory map of the platform is configured. Hence,
I re-worded the commit text to make it clear that this will happen when
you have memory starting at 0x0.

If I list out specific hardware platforms it would be only a sample (I
do not know all hardware platforms and their memory maps). However,
having said that there are products already shipping with physical
address starting at 0.

Thanks,

Olav Haugan

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
