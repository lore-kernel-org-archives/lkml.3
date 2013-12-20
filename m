Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab3LTXKH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 18:10:07 -0500
Received: from adsl-gw.arm.linux.org.uk ([78.32.30.217]:50513 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751463Ab3LTXKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 18:10:05 -0500
X-Greylist: delayed 591 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Dec 2013 18:10:05 EST
Date: Fri, 20 Dec 2013 22:55:41 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm/ARM: fix ARMs __ffs() to conform to avoid warning
	with NO_BOOTMEM
Message-ID: <20131220225541.GN4360@n2100.arm.linux.org.uk>
References: <1386981486-3173-1-git-send-email-santosh.shilimkar@ti.com> <52B4C71D.9030904@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52B4C71D.9030904@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 20, 2013 at 05:39:25PM -0500, Santosh Shilimkar wrote:
> Russell,
> 
> On Friday 13 December 2013 07:38 PM, Santosh Shilimkar wrote:
> > Building ARM with NO_BOOTMEM generates below warning.
> > 
> > mm/nobootmem.c: In function _____free_pages_memory___:
> > mm/nobootmem.c:88:11: warning: comparison of distinct pointer types lacks a cast
> > 
> > 	order = min(MAX_ORDER - 1UL, __ffs(start));
> > 
> > ARM's __ffs() differs from other architectures in that it ends up being
> > an int, whereas almost everyone else is unsigned long.
> > 
> > So fix ARMs __ffs() to conform to other architectures. Suggested by
> > Russell King <linux@arm.linux.org.uk>
> > 
> > Some more details in below thread -
> > 	https://lkml.org/lkml/2013/12/9/807
> > 
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Russell King <linux@arm.linux.org.uk>
> > Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> > ---
> Is this patch inline with what we discussed off-list ?

It is.

> If you ack it, it can go into the Andrews tree to kill that one last
> warning with the memblock series. Thanks

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

Please note that I'm rather busy at the moment dealing with a complete
change in networking here (I've not read much in the way of email over
the last couple of days).  Also note that my Internet connection is
highly unstable and experiencing a large amount of packet loss due to
this wonderful thing called "FTTC"... which when working properly only
gives me around 5Mbps.
