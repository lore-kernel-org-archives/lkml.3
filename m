Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910AbaFDVZb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 17:25:31 -0400
Received: from 8bytes.org ([85.214.48.195]:50912 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363AbaFDVZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 17:25:29 -0400
Date: Wed, 4 Jun 2014 23:25:25 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Eli Billauer <eli.billauer@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Shuah Khan <shuah.kh@samsung.com>,
        devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        bhelgaas@google.com, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org,
        discuss@x86-64.org
Subject: Re: [PATCH v2 1/4] dma-mapping: Add devm_ interface for
 dma_map_single()
Message-ID: <20140604212525.GE23880@8bytes.org>
References: <1401606077-1739-1-git-send-email-eli.billauer@gmail.com>
 <1401606077-1739-2-git-send-email-eli.billauer@gmail.com>
 <538E3D04.9060808@samsung.com>
 <20140603233907.GB23880@8bytes.org>
 <20140604140408.GC5004@htj.dyndns.org>
 <20140604141211.GC23880@8bytes.org>
 <20140604141416.GD5004@htj.dyndns.org>
 <538F3548.4050101@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538F3548.4050101@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Jun  4 23:25:27 2014
X-DSPAM-Confidence: 0.9995
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 538f8ec720861989511335
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jun 04, 2014 at 06:03:36PM +0300, Eli Billauer wrote:
> I believe that I need a managed dma_map_single() my own driver,
> which doesn't fall in the case of a single use: The driver allocates
> its buffers with __get_free_pages() (or the to-be managed version of
> it). Then it cuts the allocated memory into smaller buffers (in some
> cases, and with certain alignment rules), and  then calls
> dma_map_single() to do the DMA mapping for each. The buffers are
> held along the driver's lifetime, with DMA sync API juggling control
> back and forth to the hardware. Note that the DMA is noncoherent.

What you are trying to do should work with dma_alloc_noncoherent(). The
API allows partial syncs on this memory, so you should be fine.

The problem with a devm variant of dma_map_* is that it is too easy to
misuse or to use it wrong so that a driver could eat up all available
DMA handles on some platforms.


	Joerg


