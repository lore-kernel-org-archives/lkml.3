Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978Ab3AKQ4X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 11:56:23 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:60558 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946Ab3AKQ4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 11:56:22 -0500
MIME-Version: 1.0
In-Reply-To: <20130111145059.GJ25591@8bytes.org>
References: <1357545112-17375-1-git-send-email-aik@ozlabs.ru>
	<20130110170941.GA2556@8bytes.org>
	<CAKocOOP=V=kZ=4661YSs4b+7GLcNqzVvvhb+ONBO=LiR3txvTA@mail.gmail.com>
	<20130111145059.GJ25591@8bytes.org>
Date: Fri, 11 Jan 2013 09:56:20 -0700
Message-ID: <CAKocOOOzzpN_ZdN9owv5tb-28qtvXc9KvF7WuyZdxYrAYxnNTw@mail.gmail.com>
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

On Fri, Jan 11, 2013 at 7:50 AM, Joerg Roedel <joro@8bytes.org> wrote:
> On Thu, Jan 10, 2013 at 01:40:17PM -0700, Shuah Khan wrote:
>> I am currently debugging IO_PAGE_FAULTS on 3.6.11 (happens on all
>> pre-3.7 releases). I root-caused the reason 3.7 works is because in
>> 3.7 amd iommu driver moving up the early iommu initialization from
>> irq_remap_ops with the irq remapping feature.
>
> Have you investigated the reason for those IO_PAGE_FAULTS? I guess they
> come from the USB controlers and happen between the time the IOMMU is
> enabled and the USB controlers are taken over by the Linux kernel from
> the BIOS.
>
> But I don't see why this patch can have any impact on the IO_PAGE_FAULTS
> you are seeing.

USB is one of them and SATA is another. I know with my back-port to
split dma ops initialization and this patch Alexey sent, the problem
goes away on 3.6.11 and I don't see the problem on 3.7. Same system,
and two different boots. I will investigate do more investigation into
the nature of these faults I am seeing and get back to you.

Thanks,
-- Shuah
