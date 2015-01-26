Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925AbbAZLtt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 06:49:49 -0500
Received: from 8bytes.org ([81.169.241.247]:45922 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbbAZLtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 06:49:47 -0500
Date: Mon, 26 Jan 2015 12:49:45 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH 1/3] swiotlb: Warn on allocation failure in
 swiotlb_alloc_coherent
Message-ID: <20150126114945.GD30345@8bytes.org>
References: <1420555874-11506-1-git-send-email-joro@8bytes.org>
 <1420555874-11506-2-git-send-email-joro@8bytes.org>
 <20150123170425.GI22635@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150123170425.GI22635@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 06:04:25PM +0100, Borislav Petkov wrote:
> On Tue, Jan 06, 2015 at 03:51:12PM +0100, Joerg Roedel wrote:
> > +
> > +err_warn:
> > +	pr_warn("swiotlb: coherent allocation failed for device %s size=%zu\n",
> > +		dev_name(hwdev), size);
> > +	dump_stack();
> 
> Are we really sure we want to be that noisy about it? What happens if
> that fails, we can't do DMA anymore or should we free some precious DMA
> memory, as a compromise?

Hmm, I don't think there is a way to request drivers to free DMA memory.
What this patch does is to keep the same noisiness as before, just not
from the page allocator but from the very end of the DMA allocation
process, when everything failed.
We can of course discuss whether this is too noisy and put some kind of
ratelimit around.


	Joerg

