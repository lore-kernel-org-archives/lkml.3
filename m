Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610AbaFDOES (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 10:04:18 -0400
Received: from mail-qg0-f50.google.com ([209.85.192.50]:61396 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbaFDOEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 10:04:13 -0400
Date: Wed, 4 Jun 2014 10:04:08 -0400
From: Tejun Heo <tj@kernel.org>
To: Joerg Roedel <joro@8bytes.org>
Cc: Shuah Khan <shuah.kh@samsung.com>, Eli Billauer <eli.billauer@gmail.com>,
        devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        bhelgaas@google.com, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org,
        discuss@x86-64.org
Subject: Re: [PATCH v2 1/4] dma-mapping: Add devm_ interface for
 dma_map_single()
Message-ID: <20140604140408.GC5004@htj.dyndns.org>
References: <1401606077-1739-1-git-send-email-eli.billauer@gmail.com>
 <1401606077-1739-2-git-send-email-eli.billauer@gmail.com>
 <538E3D04.9060808@samsung.com>
 <20140603233907.GB23880@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140603233907.GB23880@8bytes.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jun 04, 2014 at 01:39:07AM +0200, Joerg Roedel wrote:
> I fully agree with the points Shuah brought up here. I don't think it is
> a good idea to add this kind of resource management to runtime-allocated
> (and de-allocated) resources of device drivers.
>
> Also DMA handles are not something that could be garbage collected at
> driver unload time. They are a limited resource that may be used up at
> some point. And the whole point of a devm-API is that code can be
> simpler because we don't need to de-allocate everything on the
> error-path or at unload time, no?

Hmmm?  Don't we have drivers which map dma buffers on device init and
release them on exit?  For dynamic usages, its usefulness is limited
especially given that dynamic tracking of buffers usually would
involve tracking of other information too in addition to dma buffer
pointer themselves.  If alloc on init and free on exit is a very rare
usage pattern, I have no objection against not adding devm interface
for dma mappings.

Thanks.

-- 
tejun
