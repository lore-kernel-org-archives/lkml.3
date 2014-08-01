Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbaHAQML (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 12:12:11 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:38300 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714AbaHAQMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 12:12:09 -0400
X-Originating-IP: 50.43.15.134
Date: Fri, 1 Aug 2014 09:11:54 -0700
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
Message-ID: <20140801161154.GA1258@thin>
References: <20140730192331.GA23730@jtriplet-mobl1>
 <20140731103110.GC15082@console-pimps.org>
 <20140731161133.GA12663@cloud>
 <20140801091949.GD15082@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140801091949.GD15082@console-pimps.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2014 at 10:19:49AM +0100, Matt Fleming wrote:
> (Including akpm, the __GFP_NOWARN police)

Andrew suggested __GFP_NOWARN here in the first place.

> On Thu, 31 Jul, at 09:11:33AM, Josh Triplett wrote:
> > 
> > I started to add an explicit limit, but any reasonable limit (large
> > enough for modern screens) would be large enough that there's still a
> > non-trivial possibility of allocation failure.  And I think it makes
> > sense for BGRT image allocation to be non-fatal and minimally noisy
> > (just a single-line error, not a scary-looking allocation warning),
> > considering the highly optional and cosmetic nature of BGRT.  So, I
> > believe __GFP_NOWARN makes sense.
> 
> Yes, I agree that we don't want to trigger the page allocator warning,
> but I don't agree that passing __GFP_NOWARN is OK, which is why I'm
> advocating some size limit checks.
> 
> We need to distinguish between "Your BGRT image size is huge, and
> assumed buggy" and "Your BGRT looks valid, but we ran out of memory".
> 
> We've already got enough problems with the EFI code because we silently
> paper over bugs, and using the page allocator's failure path as a way to
> check for buggy BGRT images just doesn't make any sense to me at all.
> 
> If we get the limit wrong, it's not the end of the world, we can change
> it later, but it's a safe bet that if the firmware engineers start
> seeing "BGRT is buggy" in the kernel log they're going to start a
> dialogue with us.

The original bug report was about an allocation failure for a fairly
reasonable BGRT size.  We can certainly prohibit absurdly huge ones (for
instance, bigger than the maximum likely screen resolution times 4 bytes
per pixel), but allocation failures may well occur for smaller sizes,
and I don't think we want to spew a massive warning for that either.

- Josh Triplett
