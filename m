Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191AbaKTLl2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 06:41:28 -0500
Received: from smtp.nue.novell.com ([195.135.221.5]:55681 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbaKTLl1 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:8:1>);
	Thu, 20 Nov 2014 06:41:27 -0500
X-Greylist: delayed 1200 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Nov 2014 06:41:27 EST
Message-Id: <546DDCC302000078000494C9@smtp.nue.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Thu, 20 Nov 2014 12:21:23 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "David Vrabel" <david.vrabel@citrix.com>
Cc: <x86@kernel.org>, "Thomas Gleixner" <tglx@linutronix.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        <xen-devel@lists.xenproject.org>,
        "Boris Ostrovsky" <boris.ostrovsky@oracle.com>,
        "Ingo Molnar" <mingo@redhat.com>, <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] [PATCH 4/4] x86/xen: use the maximum MFN to
 calculate the required DMA mask
References: <1416412921-23671-1-git-send-email-david.vrabel@citrix.com>
 <1416412921-23671-5-git-send-email-david.vrabel@citrix.com>
In-Reply-To: <1416412921-23671-5-git-send-email-david.vrabel@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 19.11.14 at 17:02, <david.vrabel@citrix.com> wrote:
> On a Xen PV guest the DMA addresses and physical addresses are not 1:1
> (such as Xen PV guests) and the generic dma_get_required_mask() does
> not return the correct mask (since it uses max_pfn).
> 
> Some device drivers (such as mptsas, mpt2sas) use
> dma_get_required_mask() to set the device's DMA mask to allow them to
> use only 32-bit DMA addresses in hardware structures.  This results in
> unnecessary use of the SWIOTLB if DMA addresses are more than 32-bits,
> impacting performance significantly.
> 
> Provide a get_required_mask op that uses the maximum MFN to calculate
> the DMA mask.
> 
> Signed-off-by: David Vrabel <david.vrabel@citrix.com>

Reviewed-by: Jan Beulich <jbeulich@suse.com>

