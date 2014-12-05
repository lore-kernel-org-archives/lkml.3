Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049AbaLEVaC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 16:30:02 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53008 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbaLEV37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 16:29:59 -0500
Date: Fri, 5 Dec 2014 13:29:58 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: David Vrabel <david.vrabel@citrix.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, xen-devel@lists.xenproject.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCHv5 0/4] dma, x86, xen: reduce SWIOTLB usage in Xen guests
Message-ID: <20141205212958.GA3012@kroah.com>
References: <1417788483-662-1-git-send-email-david.vrabel@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417788483-662-1-git-send-email-david.vrabel@citrix.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2014 at 02:07:59PM +0000, David Vrabel wrote:
> On systems where DMA addresses and physical addresses are not 1:1
> (such as Xen PV guests), the generic dma_get_required_mask() will not
> return the correct mask (since it uses max_pfn).
> 
> Some device drivers (such as mptsas, mpt2sas) use
> dma_get_required_mask() to set the device's DMA mask to allow them to use
> only 32-bit DMA addresses in hardware structures.  This results in
> unnecessary use of the SWIOTLB if DMA addresses are more than 32-bits,
> impacting performance significantly.
> 
> This series allows Xen PV guests to override the default
> dma_get_required_mask() with a more suitable one.
> 
> Changes in v5:
> - xen_swiotlb_get_required_mask() is x86 only.
> 
> Changes in v4:
> - Assume 64-bit mask is required.
> 
> Changes in v3:
> - fix off-by-one in xen_dma_get_required_mask()
> - split ia64 changes into separate patch.
> 
> Changes in v2:
> - split x86 and xen changes into separate patches
> 
> David

Why are you sending these to me?  Am I the DMA maintainer and forgot
about it?

/me digs in MAINTAINERS...

Nope, not me!  Patches are now deleted from my queue, go use
scripts/get_maintainer.pl like you should have done...

greg k-h
