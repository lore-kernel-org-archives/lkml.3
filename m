Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358AbaEWPqV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 11:46:21 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:58857 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753205AbaEWPqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 11:46:19 -0400
Date: Fri, 23 May 2014 16:44:53 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Waldemar Brodkorb <mail@waldemar-brodkorb.de>,
        Waldemar Brodkorb <wbx@openadk.org>, Shawn Guo <shawn.guo@linaro.org>,
        Rabeeh Khoury <rabeeh@solid-run.com>, linux-kernel@vger.kernel.org,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: oops on cubox-i (v3.15-rc4)
Message-ID: <20140523154453.GY3693@n2100.arm.linux.org.uk>
References: <20140509144438.GW14063@waldemar-brodkorb.de> <20140511002506.GN12708@titan.lakedaemon.net> <20140523101751.GH618@waldemar-brodkorb.de> <20140523143845.GD8664@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140523143845.GD8664@titan.lakedaemon.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 10:38:45AM -0400, Jason Cooper wrote:
> On Fri, May 23, 2014 at 12:17:51PM +0200, Waldemar Brodkorb wrote:
> > Hi Jason,
> > Jason Cooper wrote,
> > 
> > > Waldemar,
> > > 
> > > + Russell King, linux-arm-kernel ML, Shawn Guo
> > > 
> > > I'm not familiar with the platform, but I almost missed this in the
> > > flood from lkml.  I've added some folks to the Cc who I know work with
> > > this platform and I've also corrected the Subject line so others
> > > familiar with the Cubox-i might catch it.
> > 
> > Thanks. Problem still exist with 3.15-rc6. 
> > It also happens with a NFSv3 exported filesystem.
> > It works nearly stable with 3.10.30 kernel from here:
> > https://github.com/linux4kix/linux-linaro-stable-mx6
> > (a crash after 3 days uptime)
> > 
> > Anything I can do to help debugging?
> > 
> > best regards
> >         Waldemar
> >  
> > > hth,
> > > 
> > > Jason.
> > > 
> > > On Fri, May 09, 2014 at 04:44:38PM +0200, Waldemar Brodkorb wrote:
> > > > Dear Kernel Hackers,
> > > > 
> > > > I am getting kernel oopses on my cubox-i (i2ultra) running
> > > > Linux 3.15-rc4, when using the box as a samba server with 
> > > > a local attached 8 GB usb stick. (it also happen with a smaller
> > > > video on the micro-sd card)
> > > > The oops happens while playing a movie (4 GB file) on a samba client 
> > > > (macos x maverick macbook) via vlc (after 5-15 minutes). 
> > > > 
> > > > Both systems are connected to a gigabit ethernet switch.
> > > > 
> > > > The oops happens with ntfs-3g, ntfs, vfat and ext4 filesystem.
> 
> Can you get an oops from when it's on ext4?  It looks like this is going
> through fuse which opens a whole can of unknown worms.

Waldemar mentioned ext4.

I don't think there's anything specific about it to the Cubox-i, and I'd
also suggest that it's got nothing to do with ARM either - the iMX6 are
PIPT data caches so there can't be any issues with D-cache aliasing with
fuse.

It must be a bug in generic code.

> > > > Booting Linux on physical CPU 0x0
> > > > Linux version 3.15.0-rc4 (wbx@kop-brodkorbw) (gcc version 4.8.2 (GCC) ) #1 SMP Fri May 9 12:58:45 CEST 2014
> > > > CPU: ARMv7 Processor [412fc09a] revision 10 (ARMv7), cr=10c53c7d
> > > > CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing instruction cache
> > > > Machine model: SolidRun Cubox-i Dual/Quad
> > > > Truncating RAM at 10000000-4fffffff to -3f7fffff (vmalloc region overlap).

Also worth noting that 1/4 of the RAM is not used because highmem is not
enabled.  Also L2 cache is disabled (so it's running slower than it
should...)

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
