Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab3F0SP7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 14:15:59 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46720 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712Ab3F0SP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 14:15:58 -0400
Date: Thu, 27 Jun 2013 19:15:46 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Greg KH <greg@kroah.com>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] delayed kobject release: help find buggy code
Message-ID: <20130627181545.GC12530@flint.arm.linux.org.uk>
References: <20130627140613.GB12530@flint.arm.linux.org.uk> <20130627153612.GA25244@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130627153612.GA25244@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 08:36:12AM -0700, Greg KH wrote:
> On Thu, Jun 27, 2013 at 03:06:14PM +0100, Russell King wrote:
> > Greg,
> > 
> > This is an updated copy of my delayed kobject release debugging patch
> > from 2011, which I notice hasn't hit mainline.  Please consider merging
> > this so that driver authors and subsystem maintainers have a way to test
> > code for kobject refcounting errors.
> > 
> > Moreover, please also consider whether to make the debug option default
> > to 'y' when CONFIG_DEBUG_KERNEL is enabled.
> 
> Nice, I had forgotten about this code.  Have you run it in a while to
> see if things still work well?

Not since I originally posted it, and had other people use it to find
bugs a few years ago.  Since then it's virtually unchanged - the changes
are basically introducing the config option rather than the fixed #define
in the header file enabling it, and changing a pr_info() to a pr_debug().

The patch applied with just a few lines of offset too, and I did build
test it before sending in both enabled and disabled states.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
