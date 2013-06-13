Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690Ab3FMRh5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 13:37:57 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42695 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754860Ab3FMRh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 13:37:56 -0400
Date: Thu, 13 Jun 2013 18:37:23 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Colin Cross <ccross@android.com>
Cc: linux-arm-kernel@lists.infradead.org,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: convert max_pfn and max_low_pfn to be relative to
	PFN0
Message-ID: <20130613173723.GK18614@n2100.arm.linux.org.uk>
References: <1371089603-22601-1-git-send-email-ccross@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371089603-22601-1-git-send-email-ccross@android.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 07:13:23PM -0700, Colin Cross wrote:
> >From code inspection, I believe this will also improve block device
> performance where the bounce limit was set to BLK_BOUNCE_HIGH, which
> was bouncing unnecessarily for the top PHYS_PFN_OFFSET pages of low
> memory.

This has the potential to break platforms.  The problem is the duality
of the dma_mask - is it a mask of the bits which the device can drive,
or a PFN limit.  The block layer interprets it as a PFN limit, because
of course everywhere starts their memory at physical address zero.

This gets into a world of pain if you have any of these conditions:
(a) RAM not starting at physical address zero
(b) Any translation between physical addresses and bus addresses

What we know is that the existing stuff works.  What we don't know is
whether changing it will break anything which falls into the above
two categories.
