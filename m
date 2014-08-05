Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703AbaHEQj4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 12:39:56 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:54376 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbaHEQjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 12:39:54 -0400
X-Originating-IP: 50.43.15.134
Date: Tue, 5 Aug 2014 09:39:39 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Matt Fleming <matt.fleming@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Srihari Vijayaraghavan <linux.bug.reporting@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] efi-bgrt: Add error handling; inform the user when
 ignoring the BGRT
Message-ID: <20140805163932.GA3146@thin>
References: <20140730192331.GA23730@jtriplet-mobl1>
 <20140731103110.GC15082@console-pimps.org>
 <20140731161133.GA12663@cloud>
 <20140801091949.GD15082@console-pimps.org>
 <20140801161154.GA1258@thin>
 <20140804121959.GG15082@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140804121959.GG15082@console-pimps.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2014 at 01:19:59PM +0100, Matt Fleming wrote:
> On Fri, 01 Aug, at 09:11:54AM, Josh Triplett wrote:
> > 
> > The original bug report was about an allocation failure for a fairly
> > reasonable BGRT size.  We can certainly prohibit absurdly huge ones (for
> > instance, bigger than the maximum likely screen resolution times 4 bytes
> > per pixel), but allocation failures may well occur for smaller sizes,
> > and I don't think we want to spew a massive warning for that either.
> 
> Oh, dammit, that's my bad. I misread the allocation size and thought it
> was huge, but now realise it was only 6MB or so. Sorry Josh.
> 
> I was worried that this was the first reported instance of a BGRT
> claiming to be valid but with a bogusly large image size. I've never
> been so happy to be wrong.

:)

> However, the fact that the allocation failed is worth investigating -
> this machine appears to have GBs of ram. Perhaps we should switch to
> requesting pages directly instead of relying on kmalloc()? 
> 
> I appreciate that the BGRT code isn't mission critical or anything like
> that, and that failing the alloc isn't the end of the world, but if we
> have code in the kernel it should really be as robust as possible. I
> don't think trying to kmalloc() ~6MB can claim to be robust.

vmalloc or flex_array could potentially help here.  However, I'd suggest
we go ahead and merge this patch to improve the existing error handling
before doing a more extensive rewrite to use one of those.

Would anything go horrifically wrong if this allocation used vmalloc?
We really don't care deeply about the performance of this memory; it
just needs a single copy in and a small number of copies out in the
lifetime of a system.

- Josh Triplett
