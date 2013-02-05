Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676Ab3BEI4b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 03:56:31 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:64975 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754379Ab3BEI43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 03:56:29 -0500
X-AuditID: cbfec7f4-b7f6d6d000001620-5b-5110c93bdced
Message-id: <5110C935.6020308@samsung.com>
Date: Tue, 05 Feb 2013 09:56:21 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107
 Thunderbird/17.0.2
MIME-version: 1.0
To: Mel Gorman <mgorman@suse.de>
Cc: Kyungmin Park <kmpark@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, minchan@kernel.org
Subject: Re: [PATCH] mm: cma: fix accounting of CMA pages placed in high memory
References: <1359973626-3900-1-git-send-email-m.szyprowski@samsung.com>
 <20130204150657.6d05f76a.akpm@linux-foundation.org>
 <CAH9JG2Usd4HJKrBXwX3aEc3i6068zU=F=RjcoQ8E8uxYGrwXgg@mail.gmail.com>
 <20130205082822.GE21389@suse.de>
In-reply-to: <20130205082822.GE21389@suse.de>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkluLIzCtJLcpLzFFi42I5/e/4ZV3rkwKBBmuncVtc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mu2cLC3p4KxrPPGFqYFzO1cXIwSEhYCJxuYeli5ETyBSTuHBv
	PVsXIxeHkMBSRonlfRuhnCVMEjta5zCCVPEKaEl8eHyPGaSZRUBV4mNnOUiYTcBQouttFxuI
	LSoQKrF23xpmiHJBiR+T77GAlIsIKEjMfW8OEmYWmMso0TsdbK+wgL/EkYftTBCrnjNKbD/V
	AbaKU0BXYklLDxNEg5nEo5Z1zBC2vMTmNW+ZJzAKzEKyYhaSsllIyhYwMq9iFE0tTS4oTkrP
	NdQrTswtLs1L10vOz93ECAm+LzsYFx+zOsQowMGoxMMbeI0/UIg1say4MvcQowQHs5II78cb
	QCHelMTKqtSi/Pii0pzU4kOMTBycUg2MKqmW3I+/T2ha/3inSXmPq9uVm75B2xr/PLiw+ccW
	x3WzDJb/5TuwvyQxOUgt6Z6GRfWKsqSZnnGxC9ufRLvICSSYLug+vTQpsdB52wyDo2K2DqUb
	551beGs386f+XY812yI5qt76T9My1N1nePmrtYVVe65JpMfut/vEArT2hnbcrNBNrL6uxFKc
	kWioxVxUnAgAj6kV9BwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2/5/2013 9:28 AM, Mel Gorman wrote:
> On Tue, Feb 05, 2013 at 08:29:26AM +0900, Kyungmin Park wrote:
> > >
> > > (This information is needed so that others can make patch-scheduling
> > > decisions and should be included in all bugfix changelogs unless it is
> > > obvious).
> >
> > CMA Highmem support is new feature. so don't need to go stable tree.
> >
>
> You could have given a lot more information to that question!
>
> How new a feature is it?

ARM DMA-mapping, the only in-kernel client of CMA, will gain himem 
support in
v3.9. On the other hand, there might be out of tree clients of
alloc_contig_migrate_range()/dma_alloc_from_contiguous() API. If you think
we should care about them, then this patch might need to be backported
to stable kernels.

>   Does this mean that this patch must go in before
> 3.8 releases or is it a fix against a patch that is only in Andrew's tree?
> If the patch is only in Andrew's tree, which one is it and should this be
> folded in as a fix?
>
> On a semi-related note; is there a plan for backporting highmem support for
> the LTSI kernel considering it's aimed at embedded and CMA was highlighted
> in their announcment for 3.4 support?

I've just noticed recently that LTSI released v3.4 kernel with CMA support.
I've checked that code only briefly and noticed that it didn't have all the
CMA related patches which are available in v3.8-rc1. I will take a look at
that code and maybe I will find some time to backport some more patches from
mainline, but please note that mainline kernel has higher priority.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


