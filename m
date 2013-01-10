Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323Ab3AJXQ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 18:16:29 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:59731 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822Ab3AJXQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 18:16:28 -0500
MIME-Version: 1.0
In-Reply-To: <CAKocOOP=V=kZ=4661YSs4b+7GLcNqzVvvhb+ONBO=LiR3txvTA@mail.gmail.com>
References: <1357545112-17375-1-git-send-email-aik@ozlabs.ru>
	<20130110170941.GA2556@8bytes.org>
	<CAKocOOP=V=kZ=4661YSs4b+7GLcNqzVvvhb+ONBO=LiR3txvTA@mail.gmail.com>
Date: Thu, 10 Jan 2013 16:16:27 -0700
Message-ID: <CAKocOOMAfkv_a71gKhGRwTM-pZsfd8qG7VVWn22Yuv6pkcdQLQ@mail.gmail.com>
Subject: Re: [PATCH] iommu: moving initialization earlier
From: Shuah Khan <shuahkhan@gmail.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>, Joerg Roedel <joerg.roedel@amd.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        Shuah Khan <shuah.khan@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 1:40 PM, Shuah Khan <shuahkhan@gmail.com> wrote:
> On Thu, Jan 10, 2013 at 10:09 AM, Joerg Roedel <joro@8bytes.org> wrote:
>> On Mon, Jan 07, 2013 at 06:51:52PM +1100, Alexey Kardashevskiy wrote:
>>> The iommu_init() initializes IOMMU internal structures and data
>>> required for the IOMMU API as iommu_group_alloc().
>>> It is registered as a subsys_initcall now.
>>>
>>> One of the IOMMU users is going to be a PCI subsystem on POWER.
>>> It discovers new IOMMU tables during the PCI scan so the logical
>>> place to call iommu_group_alloc() is the moment when a new group
>>> is discovered. However PCI scan is done from subsys_initcall hook
>>> as IOMMU does so PCI hook can be (and is) called before the IOMMU one.
>>>
>>> The patch moves IOMMU subsystem initialization one step earlier
>>> to make sure that IOMMU is initialized before PCI scan begins.
>>>
>>> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
>>
>> Applied, thanks.
>
> Joerg,
>
> Could you please consider this patch for stable releases.

The patch applies cleanly only on 3.6.y which is EOL. Guess I am out
of luck with this patch.

-- Shuah

-- Shuah
