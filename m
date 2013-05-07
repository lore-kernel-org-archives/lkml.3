Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab3EGRUN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 13:20:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53083 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816Ab3EGRUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 13:20:12 -0400
Date: Tue, 7 May 2013 10:20:10 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Michael D. Setzer II" <msetzerii@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel Firmware Support
Message-ID: <20130507172010.GA30610@kroah.com>
References: <51885C8A.28146.10AA3F@msetzerii.gmail.com>
 <20130507024750.GA26639@kroah.com>
 <5188897D.15662.1AD368@msetzerii.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5188897D.15662.1AD368@msetzerii.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 07, 2013 at 02:56:29PM +1000, Michael D. Setzer II wrote:
> On 6 May 2013 at 19:47, Greg KH wrote:
> 
> Date sent:      	Mon, 6 May 2013 19:47:50 -0700
> From:           	Greg KH <gregkh@linuxfoundation.org>
> To:             	"Michael D. Setzer II" <msetzerii@gmail.com>
> Copies to:      	linux-kernel@vger.kernel.org
> Subject:        	Re: Kernel Firmware Support
> 
> > On Tue, May 07, 2013 at 11:44:42AM +1000, Michael D. Setzer II wrote:
> > > Looking for method to best support users firmware needs within 
> > > the kernel. 
> > > 
> > > Have a disk-image project that users kernel.org kernels, and have 
> > > had users that require firmware that is not included in the 
> > > kernel.org source. I've been able to find it in linux-firmware.git and 
> > > then manually adding it to the kernel.org firmware directory and 
> > > then modifying the Makefile.
> > 
> > Use the linux-firmware package, all of the distros package it up for you
> > automatically, and install it in the correct place, so it should "just
> > work".
> > 
> > What is failing for you when you use the firmware package?
> > 
> 
> First, Thanks for the quick reply. The problem is this isn't using a 
> distro build. My project (G4L) uses a number of kernels from 
> kernel.org and I try to include as many of the nic and other 
> devices in the kernel to make it support hardware that is outside 
> my control. I've had users with bnx2x hardware that requires 
> firmware that is not part of the kernel.org source code, and have 
> manuaully added it by putting the .fw file in the subdirectory of 
> firmware and modifying the Makefile. Then building the kernel 
> includes that additional firmware in the about 8M kernel file that 
> the user selects from the CD boot process. 
> 
> The ideal is to be able to boot from the cd, or load the kernel with 
> its filesystem to be able to do partition or disk image backups, but 
> it must be able to use the hardware to access the disks and in 
> most cases the nic. Without the firmware these bnx2x nics don't 
> work.
> 
> For awhile I've been manually adding these two firmwares
> ./bnx2x/bnx2x-e2-7.2.51.0.fw
> ./bnx2/bnx2-mips-09-6.2.1b.fw
> 
> But yesterday, I got a message from a different user with screen 
> captures that showed  failure of loading the firmware below. 
> Actually, one screen shot with the 7.0.23.0 and another with the 
> 7.0.29.0. Wasn't sure, so I had added all three of th 7.0.x group to 
> a test build of my kernels. Is only the latest needed?
> 
> ./bnx2x/bnx2x-e1h-7.0.23.0.fw
> ./bnx2x/bnx2x-e1h-7.0.29.0.fw
> ./bnx2x/bnx2x-e1h-7.0.20.0.fw

If you are supporting multiple versions of the kernel, that need
different versions of the firmware package, then you need to include all
of these to handle that properly.

Best of luck,

greg k-h
