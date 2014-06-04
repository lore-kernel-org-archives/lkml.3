Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbaFDOMR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 10:12:17 -0400
Received: from 8bytes.org ([85.214.48.195]:50179 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751782AbaFDOMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 10:12:16 -0400
Date: Wed, 4 Jun 2014 16:12:11 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Tejun Heo <tj@kernel.org>
Cc: Shuah Khan <shuah.kh@samsung.com>, Eli Billauer <eli.billauer@gmail.com>,
        devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        bhelgaas@google.com, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org,
        discuss@x86-64.org
Subject: Re: [PATCH v2 1/4] dma-mapping: Add devm_ interface for
 dma_map_single()
Message-ID: <20140604141211.GC23880@8bytes.org>
References: <1401606077-1739-1-git-send-email-eli.billauer@gmail.com>
 <1401606077-1739-2-git-send-email-eli.billauer@gmail.com>
 <538E3D04.9060808@samsung.com>
 <20140603233907.GB23880@8bytes.org>
 <20140604140408.GC5004@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140604140408.GC5004@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Jun  4 16:12:13 2014
X-DSPAM-Confidence: 0.9995
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 538f293d20863268771489
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 10:04:08AM -0400, Tejun Heo wrote:
> Hmmm?  Don't we have drivers which map dma buffers on device init and
> release them on exit?  For dynamic usages, its usefulness is limited
> especially given that dynamic tracking of buffers usually would
> involve tracking of other information too in addition to dma buffer
> pointer themselves.  If alloc on init and free on exit is a very rare
> usage pattern, I have no objection against not adding devm interface
> for dma mappings.

Yes, but those drivers usually get DMA buffers at init time with the
dma_alloc_* interfaces. The dma_map_* interfaces discussed here belong
to the streaming DMA-API, so they are usually used for only one DMA
transaction before dma_unmap_* is called on them.

A devm interface for the dma_alloc_* family of functions would
actually make sense, but not for the dma_map_* functions.


	Joerg


