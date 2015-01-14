Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200AbbANTm4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 14:42:56 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:56108 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbbANTmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 14:42:55 -0500
From: Mitchel Humpherys <mitchelh@codeaurora.org>
To: Will Deacon <will.deacon@arm.com>, Joerg Roedel <jroedel@suse.de>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu\@lists.linux-foundation.org" 
	<iommu@lists.linux-foundation.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Matt Wagantall <mattw@codeaurora.org>, Robert Elliott <elliott@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v10] iopoll: Introduce memory-mapped IO polling macros
References: <1418687243-16395-1-git-send-email-mitchelh@codeaurora.org>
	<20141216094527.GC6580@arm.com>
Date: Wed, 14 Jan 2015 11:42:53 -0800
In-Reply-To: <20141216094527.GC6580@arm.com> (Will Deacon's message of "Tue,
	16 Dec 2014 09:45:27 +0000")
Message-ID: <vnkwtwztp2rm.fsf@mitchelh-linux.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16 2014 at 01:45:27 AM, Will Deacon <will.deacon@arm.com> wrote:
> On Mon, Dec 15, 2014 at 11:47:23PM +0000, Mitchel Humpherys wrote:
>> From: Matt Wagantall <mattw@codeaurora.org>
>> 
>> It is sometimes necessary to poll a memory-mapped register until its value
>> satisfies some condition. Introduce a family of convenience macros that do
>> this. Tight-looping, sleeping, and timing out can all be accomplished using
>> these macros.
>> 
>> Cc: Thierry Reding <thierry.reding@gmail.com>
>> Cc: Will Deacon <will.deacon@arm.com>
>> Cc: Arnd Bergmann <arnd@arndb.de>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Robert Elliott <elliott@hp.com>
>> Signed-off-by: Matt Wagantall <mattw@codeaurora.org>
>> Signed-off-by: Mitchel Humpherys <mitchelh@codeaurora.org>
>> ---
>> v9..10:
>>   - Actually added the comments mentioned in v8..v9 (doh!)
>> 
>> v8..v9:
>>   - Added note in comments about max sleep time (Rob Elliott)
>> 
>> v7..v8:
>>   - sorted helper macros by size (b, w, l, q)
>>   - removed some of the more esoteric (or flat-out bogus) helper macros
>> 
>> This patch was originally part of a series [1] for adding support for IOMMU
>> address translations through an ARM SMMU hardware register.  The other
>> patch in the series (the one that actually uses these macros and implements
>> said hardware address translations) was Ack'd by the driver maintainer
>> there (Will Deacon) so I've pulled this patch out to avoid resending an
>> already Ack'd patch over and over again.
>> 
>> In short, please see [1] for previous discussion and the first user of
>> these macros.
>> 
>> Will also acked this patch in [2].  I didn't retain his Ack here because I
>> added to the macro comments.
>
> You can keep the ack, it still looks good to me and I'm not really fussed
> about the comments.
>
> Will

This hasn't gotten any further comments.  Would someone be willing to
take it?

Joerg, maybe you could take this through the IOMMU tree since the first
user is an IOMMU driver?  Currently we can't move [1] forward because of
this dependency...

[1] http://thread.gmane.org/gmane.linux.kernel.iommu/7837


-Mitch

-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
