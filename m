Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbaIOQr5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 12:47:57 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:33056 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073AbaIOQr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 12:47:56 -0400
Date: Mon, 15 Sep 2014 17:47:38 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jon Masters <jcm@redhat.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: "dma-coherent" property inheritance (arm vs arm64)
Message-ID: <20140915164738.GJ5415@arm.com>
References: <5414FF8F.5040409@redhat.com>
 <20140915155216.GG5415@arm.com>
 <54171485.5010803@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54171485.5010803@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 05:32:05PM +0100, Jon Masters wrote:
> On 09/15/2014 11:52 AM, Catalin Marinas wrote:
> > Hi Jon,
> > 
> > On Sun, Sep 14, 2014 at 03:38:07AM +0100, Jon Masters wrote:
> >> commit 6ecba8eb51b7d23fda66388a5420be7d8688b186
> >> Author: Catalin Marinas <catalin.marinas@arm.com>
> >> Date:   Fri Apr 25 15:31:45 2014 +0100
> >>
> >>     arm64: Use bus notifiers to set per-device coherent DMA ops
> >>
> >> Thus at this point, on 32-bit systems, we have defined this function:
> >>
> >> 	set_arch_dma_coherent_ops
> > 
> > It was a timing issue that they are not in sync. I would have used
> > set_arch_dma_coherent_ops() but it wasn't very clear when it gets merged
> > and changing the default on arm64 broke some other assumptions, so a
> > temporary fix.
> 
> Ok. So arm64 will automatically switch over to set_arch_dma_coherent_ops
> (once it's there, it will be called automatically anyway because it's in
> the callchain anyway already).

I still need to figure out if set_arch_dma_coherent_ops() is called for
AMBA devices.

> For the moment, on our internal PCI trees, we'll add a notifier and wait
> for upstream to get PCI support and figure this out as part of that
> activity. In the case of ACPI, I'm still pushing for _CCA methods to be
> added by default because it makes sense to be verbose in describing
> platform hardware devices, even in spite of default.

Anyway, with ACPI it would probably make sense to keep the hooks
(with the recursive parent check), so set_arch_dma_coherent_ops()
wouldn't buy us much (especially if it's only for platform devices).

-- 
Catalin
