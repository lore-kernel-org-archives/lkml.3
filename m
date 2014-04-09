Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964875AbaDIQhZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 12:37:25 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:55739 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933100AbaDIQhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 12:37:24 -0400
Date: Wed, 9 Apr 2014 17:36:47 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: David Miller <davem@davemloft.net>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, rth@twiddle.net,
        ink@jurassic.park.msu.ru, mattst88@gmail.com, starvik@axis.com,
        jesper.nilsson@axis.com, dhowells@redhat.com, tony.luck@intel.com,
        fenghua.yu@intel.com, takata@linux-m32r.org, gerg@uclinux.org,
        geert@linux-m68k.org, monstr@monstr.eu,
        yasutake.koichi@jp.panasonic.com, cmetcalf@tilera.com,
        gxt@mprc.pku.edu.cn, arnd@arndb.de
Subject: Re: [RFC PATCH] Remove flush_icache_user_range()
Message-ID: <20140409163647.GX16119@n2100.arm.linux.org.uk>
References: <20140409100150.GO16119@n2100.arm.linux.org.uk> <20140409.120926.1586922018370125781.davem@davemloft.net> <20140409161554.GV16119@n2100.arm.linux.org.uk> <20140409.123358.348743774307868735.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140409.123358.348743774307868735.davem@davemloft.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 12:33:58PM -0400, David Miller wrote:
> From: Russell King - ARM Linux <linux@arm.linux.org.uk>
> Date: Wed, 9 Apr 2014 17:15:55 +0100
> 
> > On Wed, Apr 09, 2014 at 12:09:26PM -0400, David Miller wrote:
> >> From: Russell King - ARM Linux <linux@arm.linux.org.uk>
> >> Date: Wed, 9 Apr 2014 11:01:50 +0100
> >> 
> >> > What has been proposed for uprobes is a uprobe specific function -
> >> > flush_uprobe_xol_access() which is used after uprobes writes via the
> >> > kmap_atomic() mapping of the page:
> >> > 
> >> > +       xol_page_kaddr = kmap_atomic(area->page);
> >> > +
> >> > +       /* Initialize the slot */
> >> > +       memcpy(xol_page_kaddr + (xol_vaddr & ~PAGE_MASK),
> >> > +              &uprobe->arch.ixol,
> >> > +              sizeof(uprobe->arch.ixol));
> >> > +
> >> > +       arch_uprobe_flush_xol_access(area->page, xol_vaddr,
> >> > +                                    xol_page_kaddr + (xol_vaddr & ~PAGE_MASK),
> >> > +                                    sizeof(uprobe->arch.ixol));
> >> > +
> >> > +       kunmap_atomic(xol_page_kaddr);
> >> > 
> >> > Comments?
> >> 
> >> ptrace() accesses (via __access_remote_vm()) already use an existing
> >> helper function for these sorts of situations, in the form of
> >> copy_{to,from}_user_page().  I would suggest that uprobes uses that
> >> as well.
> > 
> > Yes, I agree with you.
> > 
> > I made that suggestion too (because it's really the same problem)
> > but uprobes people are concerned that it's too much of an overhead:
> 
> They should use it at first, then if there is a problem we can identify
> exactly what can be optimized or needs to be, and expand the interface
> as needed.
> 
> Let's not optimize first.

I have forwarded your comments, thanks.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
