Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab3J0P53 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 11:57:29 -0400
Received: from shrek-wifi.podlesie.net ([93.179.225.50]:59647 "EHLO
	shrek.podlesie.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983Ab3J0P52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 11:57:28 -0400
Date: Sun, 27 Oct 2013 16:57:22 +0100
From: Krzysztof Mazur <krzysiek@podlesie.net>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Jason Baron <jbaron@akamai.com>
Subject: Re: [PATCH] DYNAMIC_DEBUG: use select DEBUG_FS instead of depends on
Message-ID: <20131027155722.GA22212@shrek.podlesie.net>
References: <1382821093-2484-1-git-send-email-krzysiek@podlesie.net>
 <20131027033000.GB32210@kroah.com>
 <20131027080151.GA26131@shrek.podlesie.net>
 <526D2550.8080600@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <526D2550.8080600@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 27, 2013 at 07:38:08AM -0700, Randy Dunlap wrote:
> On 10/27/13 01:01, Krzysztof Mazur wrote:
> > On Sat, Oct 26, 2013 at 08:30:00PM -0700, Greg Kroah-Hartman wrote:
> >> On Sat, Oct 26, 2013 at 10:58:13PM +0200, Krzysztof Mazur wrote:
> >>> Depending on options that are configured later makes them hard
> >>> to enable unless the user knows that he must go backwards.
> >>
> >> Really?  We've had this for well over 2 years, people are confused about
> >> this?
> >>
> >> Where?
> > 
> > The v3.10 is ok - CONFIG_DYNAMIC_DEBUG is after CONFIG_DEBUG_FS.
> > 
> > Maybe it's just me, because on my config I have CONFIG_DEBUG_FS=y,
> > and on the system I was testing usbatm I had CONFIG_DEBUG_FS=n.
> > 
> > BTW, on x86_64 to disable CONFIG_DEBUG_FS you need to disable
> > CONFIG_AMD_IOMMU_STATS, which is enabled by default in the
> > x86_64_defconfig (I think that CONFIG_AMD_IOMMU_STATS=n it's
> > a better default). If you enable CONFIG_DEBUG_KERNEL you
> > need to disable CONFIG_FTRACE which is enabled by default.
> > So a lot of users will have CONFIG_DEBUG_FS already selected.
> 
> You are making a good argument for not using 'select' at all.
> 

I don't think that using 'select' is bad, but 'select' + 'default y'
+ defconfigs currently enable a lot of unwanted features. The
'select' chain that enables DEBUG_FS is even better: EMBEDDED selects EXPERT,
EXPERT selects DEBUG_KERNEL, DEBUG_KERNEL enables FTRACE by 'default y'
and FTRACE selects DEBUG_FS.

I don't care if we add select DEBUG_FS in DYNAMIC_DEBUG or change
the order of "printk and dmesg options" and "Compile-time checks and
compiler options" submenus, or just do nothing. I just used
'select DEBUG_FS' because everything else in the lib/Kconfig.debug
already use it.

Maybe "make menuconfig" and "make xconfig" are just broken, because
"make config" does the right thing, the configurator is restarted and
you will be asked for all earlier options that you missed.

Krzysiek
