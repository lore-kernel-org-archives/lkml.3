Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584Ab3BECm1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 21:42:27 -0500
Received: from mail-ia0-f175.google.com ([209.85.210.175]:42045 "EHLO
	mail-ia0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755333Ab3BECm0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 21:42:26 -0500
Date: Mon, 04 Feb 2013 20:42:21 -0600
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH] init: fix name of root device in /proc/mounts
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: William Hubbs <w.d.hubbs@gmail.com>, linux-kernel@vger.kernel.org,
        mpagano@gentoo.org
References: <1359672699-23540-1-git-send-email-w.d.hubbs@gmail.com>
	<510AFCA1.5000700@zytor.com>
In-Reply-To: <510AFCA1.5000700@zytor.com> (from hpa@zytor.com on Thu Jan 31
	17:22:09 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1360032141.12062.12@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2013 05:22:09 PM, H. Peter Anvin wrote:
> On 01/31/2013 02:51 PM, William Hubbs wrote:
> > On a system that does not use an initramfs, /dev/root was always
> > listed in /proc/mounts. This breaks software which scans  
> /proc/mounts to
> > determine which file systems are mounted since /dev/root is not a  
> valid
> > device name.
> >
> > This changes that processing so that "/dev/root" is only added to
> > /proc/mounts if a root device is not specified with the root=  
> option on
> > the kernel command line.
> >
> > Signed-off-by: William Hubbs <w.d.hubbs@gmail.com>
> 
> Let me also point out that most of the time, the kernel actually has a
> udev device name for an actual device...

So your software is broken by overmounts? /dev/root is just one example  
of this. (And you can specify a root= on the kernel command line and  
have that be parsed by initramfs. I vaguely recall klibc does this...)

For an example of how to parse this stuff, how about:

   http://landley.net/hg/toybox/file/4ffb735aea59/toys/posix/df.c

I.E. parse from the end of the list (most recent match is the  
overmount), and eliminate synthetic filesystems. Note that code is from  
2006, other people have managed to cope all this time...

Rob