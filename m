Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751164Ab3JOGup (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 02:50:45 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:60215 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085Ab3JOGuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 02:50:44 -0400
Date: Tue, 15 Oct 2013 08:50:40 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Tejun Heo <tj@kernel.org>,
        Zhang Yanfei <zhangyanfei.yes@gmail.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Toshi Kani <toshi.kani@hp.com>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH part2 v2 0/8] Arrange hotpluggable memory as ZONE_MOVABLE
Message-ID: <20131015065040.GB24584@gmail.com>
References: <20131014142719.GI4722@htj.dyndns.org>
 <525C02DC.4050706@gmail.com>
 <20131014145131.GJ4722@htj.dyndns.org>
 <525C0866.2010808@gmail.com>
 <20131014151902.GL4722@htj.dyndns.org>
 <525C0EFE.2010409@gmail.com>
 <CAE9FiQX0xeR61ehPy2SfWfN-fgSZVS=dtaWT-QQ+RR12tx+A0w@mail.gmail.com>
 <20131014200437.GA5720@htj.dyndns.org>
 <CAE9FiQXCG6gR-XL9fVudpNVEdS-3MHPObfWQ=Uf=q7pv33QBOA@mail.gmail.com>
 <525C5727.7000603@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <525C5727.7000603@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 10/14/2013 01:37 PM, Yinghai Lu wrote:
> >>
> >> Optimizing NUMA boot just requires moving the heavy lifting to
> >> appropriate NUMA nodes.  It doesn't require that early boot phase
> >> should strictly follow NUMA node boundaries.
> > 
> > At end of day, I like to see all numa system (ram/cpu/pci) could have
> > non boot nodes to be hot-removed logically. with any boot command
> > line.
> > 
> 
> I don't think that is realistic without hardware support, simply because 
> all it takes is a single page of kernel locked memory to prevent a page 
> from being removed.  The only realistic way around that, I believe, is 
> to remove the identity-mapping in the kernel, but it still has all kinds 
> of funnies involving devices and DMA.

We played with virtual kernel memory a decade ago and it's doable. The 
only complication was DMA from the kernel stack - that was done with some 
really broken old ISA drivers IIRC. Those should be a distant memory, in 
terms of practical impact.

So if anyone can implement it using huge pages, with a really fast __va() 
and __pa() implementation, then it might be possible. But that's a pretty 
major surgery on x86.

Thanks,

	Ingo
