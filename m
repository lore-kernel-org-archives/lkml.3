Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439AbbAWN3x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 08:29:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60411 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956AbbAWN3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 08:29:50 -0500
Date: Fri, 23 Jan 2015 21:29:47 +0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: arnd@arndb.de, ebiederm@xmission.com, gnomes@lxorguk.ukuu.org.uk,
        teg@jklm.no, jkosina@suse.cz, luto@amacapital.net,
        linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        daniel@zonque.or, dh.herrmann@gmail.com, tixxdz@opendz.org,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Daniel Mack <daniel@zonque.org>
Subject: Re: [PATCH 01/13] kdbus: add documentation
Message-ID: <20150123132947.GA28278@kroah.com>
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org>
 <1421435777-25306-2-git-send-email-gregkh@linuxfoundation.org>
 <20150123062820.GB7949@Darwish.PC>
 <20150123131946.GA26302@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150123131946.GA26302@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 09:19:46PM +0800, Greg Kroah-Hartman wrote:
> On Fri, Jan 23, 2015 at 08:28:20AM +0200, Ahmed S. Darwish wrote:
> > On Fri, Jan 16, 2015 at 11:16:05AM -0800, Greg Kroah-Hartman wrote:
> > > From: Daniel Mack <daniel@zonque.org>
> > > 
> > > kdbus is a system for low-latency, low-overhead, easy to use
> > > interprocess communication (IPC).
> > > 
> > > The interface to all functions in this driver is implemented via ioctls
> > > on files exposed through a filesystem called 'kdbusfs'. The default
> > > mount point of kdbusfs is /sys/fs/kdbus.
> > 
> > Pardon my ignorance, but we've always been told that adding
> > new ioctl()s to the kernel is a very big no-no.  But given
> > the seniority of the folks stewarding this kdbus effort,
> > there must be a good rationale ;-)
> > 
> > So, can the rationale behind introducing new ioctl()s be
> > further explained? It would be even better if it's included
> > in the documentation patch itself.
> 
> The main reason to use an ioctl is that you want to atomically set
> and/or get something "complex" through the user/kernel boundary.  For
> simple device attributes, sysfs works great, for configuring devices,
> configfs works great, but for data streams / structures / etc. an ioctl
> is the correct thing to use.
> 
> Examples of new ioctls being added to the kernel are all over the
> place, look at all of the special-purpose ioctls the filesystems keep
> creating (they aren't adding new syscalls), look at the monstrosity that
> is the DRM layer, look at other complex things like openvswitch, or
> "simpler" device-specific interfaces like the MEI one, or even more
> complex ones like the MMC interface.

Oops, I meant, MIC, not MMC, sorry about that.

