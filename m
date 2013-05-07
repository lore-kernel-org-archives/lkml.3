Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760737Ab3EGE4g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:56:36 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:60924 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757107Ab3EGE4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 00:56:34 -0400
From: "Michael D. Setzer II" <msetzerii@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org
Date: Tue, 07 May 2013 14:56:29 +1000
MIME-Version: 1.0
Subject: Re: Kernel Firmware Support
Message-ID: <5188897D.15662.1AD368@msetzerii.gmail.com>
In-reply-to: <20130507024750.GA26639@kroah.com>
References: <51885C8A.28146.10AA3F@msetzerii.gmail.com>, <20130507024750.GA26639@kroah.com>
X-mailer: Pegasus Mail for Windows (4.63)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 May 2013 at 19:47, Greg KH wrote:

Date sent:      	Mon, 6 May 2013 19:47:50 -0700
From:           	Greg KH <gregkh@linuxfoundation.org>
To:             	"Michael D. Setzer II" <msetzerii@gmail.com>
Copies to:      	linux-kernel@vger.kernel.org
Subject:        	Re: Kernel Firmware Support

> On Tue, May 07, 2013 at 11:44:42AM +1000, Michael D. Setzer II wrote:
> > Looking for method to best support users firmware needs within 
> > the kernel. 
> > 
> > Have a disk-image project that users kernel.org kernels, and have 
> > had users that require firmware that is not included in the 
> > kernel.org source. I've been able to find it in linux-firmware.git and 
> > then manually adding it to the kernel.org firmware directory and 
> > then modifying the Makefile.
> 
> Use the linux-firmware package, all of the distros package it up for you
> automatically, and install it in the correct place, so it should "just
> work".
> 
> What is failing for you when you use the firmware package?
> 

First, Thanks for the quick reply. The problem is this isn't using a 
distro build. My project (G4L) uses a number of kernels from 
kernel.org and I try to include as many of the nic and other 
devices in the kernel to make it support hardware that is outside 
my control. I've had users with bnx2x hardware that requires 
firmware that is not part of the kernel.org source code, and have 
manuaully added it by putting the .fw file in the subdirectory of 
firmware and modifying the Makefile. Then building the kernel 
includes that additional firmware in the about 8M kernel file that 
the user selects from the CD boot process. 

The ideal is to be able to boot from the cd, or load the kernel with 
its filesystem to be able to do partition or disk image backups, but 
it must be able to use the hardware to access the disks and in 
most cases the nic. Without the firmware these bnx2x nics don't 
work.

For awhile I've been manually adding these two firmwares
./bnx2x/bnx2x-e2-7.2.51.0.fw
./bnx2/bnx2-mips-09-6.2.1b.fw

But yesterday, I got a message from a different user with screen 
captures that showed  failure of loading the firmware below. 
Actually, one screen shot with the 7.0.23.0 and another with the 
7.0.29.0. Wasn't sure, so I had added all three of th 7.0.x group to 
a test build of my kernels. Is only the latest needed?

./bnx2x/bnx2x-e1h-7.0.23.0.fw
./bnx2x/bnx2x-e1h-7.0.29.0.fw
./bnx2x/bnx2x-e1h-7.0.20.0.fw

I don't have access to any hardware with these bnx2? devices, so 
have to get feedback from users. The previous additions of 
firmware solved the problems, but just looking for the best way to 
solve it.

Thanks again.





> thanks,
> 
> greg k-h


+----------------------------------------------------------+
  Michael D. Setzer II -  Computer Science Instructor      
  Guam Community College  Computer Center                  
  mailto:mikes@kuentos.guam.net                            
  mailto:msetzerii@gmail.com
  http://www.guam.net/home/mikes
  Guam - Where America's Day Begins                        
  G4L Disk Imaging Project maintainer 
  http://sourceforge.net/projects/g4l/
+----------------------------------------------------------+

http://setiathome.berkeley.edu (Original)
Number of Seti Units Returned:  19,471
Processing time:  32 years, 290 days, 12 hours, 58 minutes
(Total Hours: 287,489)

BOINC@HOME CREDITS
SETI        14672667.574611   |   EINSTEIN    11160884.209852
ROSETTA      7189167.439443   |   ABC         15954188.106838

