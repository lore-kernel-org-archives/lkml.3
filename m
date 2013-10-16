Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759992Ab3JPHDu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 03:03:50 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:43564 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722Ab3JPHDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 03:03:48 -0400
Date: Wed, 16 Oct 2013 09:03:44 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Tejun Heo <tj@kernel.org>,
        Zhang Yanfei <zhangyanfei.yes@gmail.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Toshi Kani <toshi.kani@hp.com>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH part2 v2 0/8] Arrange hotpluggable memory as ZONE_MOVABLE
Message-ID: <20131016070343.GD22509@gmail.com>
References: <20131014145131.GJ4722@htj.dyndns.org>
 <525C0866.2010808@gmail.com>
 <20131014151902.GL4722@htj.dyndns.org>
 <525C0EFE.2010409@gmail.com>
 <CAE9FiQX0xeR61ehPy2SfWfN-fgSZVS=dtaWT-QQ+RR12tx+A0w@mail.gmail.com>
 <20131014200437.GA5720@htj.dyndns.org>
 <CAE9FiQXCG6gR-XL9fVudpNVEdS-3MHPObfWQ=Uf=q7pv33QBOA@mail.gmail.com>
 <525C5727.7000603@zytor.com>
 <20131015065040.GB24584@gmail.com>
 <525D7BDE.4070400@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <525D7BDE.4070400@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 10/14/2013 11:50 PM, Ingo Molnar wrote:
> > 
> > So if anyone can implement it using huge pages, with a really fast 
> > __va() and __pa() implementation, then it might be possible. But 
> > that's a pretty major surgery on x86.
> 
> Well, we already *have* a way to deal with that for Xen (by inserting an 
> otherwise nonexistent logical level.)  I'm wondering if those interfaces 
> could be (ab)used for this as well, or if that is functionally 
> equivalent to saying that this should be done in a hypervisor.

It's not _that_ complex, and it does not need a separate security layer.

I have this distinct memory that I saw working patches that have paged all 
of the kernel's data, more than a decade ago. It was all rather 
disgusting, because those patches worked on the 4K level - but if a 2MB 
granular solution can be found in an elegant fashion then I think we could 
reconsider.

It definitely wasn't hypervisor thick. It probably needs a good hash for 
virtual address transformations, and all DMA has to be managed [these days 
we do that via the IOMMU anyway] but that's pretty much all - kernel 
virtual memory is reconfigured extremely rarely, so all that could be sped 
up for reads and mirrored per node and kept lockless, etc. etc. [Plus a 
metric ton of details.]

Thanks,

	Ingo
