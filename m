Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433AbbAZLyO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 06:54:14 -0500
Received: from 8bytes.org ([81.169.241.247]:45958 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753823AbbAZLyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 06:54:10 -0500
Date: Mon, 26 Jan 2015 12:54:08 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Baoquan He <bhe@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH 2/3] x86, swiotlb: Try coherent allocations with
 __GFP_NOWARN
Message-ID: <20150126115408.GE30345@8bytes.org>
References: <1420555874-11506-1-git-send-email-joro@8bytes.org>
 <1420555874-11506-3-git-send-email-joro@8bytes.org>
 <20150123170306.GH22635@pd.tnic>
 <20150126032236.GN2461@dhcp-16-105.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150126032236.GN2461@dhcp-16-105.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 11:22:36AM +0800, Baoquan He wrote:
> > Ok, so this practically does all allocations __GFP_NOWARN now. Shouldn't
> > you be doing this before swiotlb_alloc_coherent() and not before
> > dma_generic_alloc_coherent()?
> 
> I think this patch mainly suppress warning from buddy allocation
> failure because it tried buddy allocation several times before the final
> try of bounce buffer allocation. Buddy allocation failure will call
> dump_stack.

Yes, exactly. The default low-memory available to the page-allocator
with crashkernel=high is 8MB. This is up pretty fast and then we start
to get warnings, even when there is still memory left in the swiotlb
space. The __GFP_WARN is there to suppress the warnings from the
page-allocator, so it has to be set before it is called.


	Joerg

