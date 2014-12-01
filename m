Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbaLAMml (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 07:42:41 -0500
Received: from gardel.0pointer.net ([85.214.157.71]:45132 "EHLO
	gardel.0pointer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254AbaLAMmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 07:42:40 -0500
Date: Mon, 1 Dec 2014 13:42:37 +0100
From: Lennart Poettering <mzxreary@0pointer.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Richard Weinberger <richard@nod.at>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org,
        "systemd-devel@lists.freedesktop.org" 
	<systemd-devel@lists.freedesktop.org>
Subject: Re: [PATCH] x86: defconfig: Enable CONFIG_FHANDLE
Message-ID: <20141201124237.GA18839@gardel-login>
References: <1416958612-7448-1-git-send-email-richard@nod.at>
 <20141130205430.GD16151@dastard>
 <547B8731.90305@nod.at>
 <20141201001849.GJ9561@dastard>
 <547BB929.3020805@nod.at>
 <20141201010343.GB18495@gardel-login>
 <20141201035426.GK9561@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141201035426.GK9561@dastard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 01.12.14 14:54, Dave Chinner (david@fromorbit.com) wrote:

> On Mon, Dec 01, 2014 at 02:03:43AM +0100, Lennart Poettering wrote:
> > On Mon, 01.12.14 01:41, Richard Weinberger (richard@nod.at) wrote:
> > 
> > > CC'ing systemd folks.
> > > 
> > > Lennart, can you please explain why you need CONFIG_FHANDLE for systemd?
> > > Maybe I'm reading the source horrible wrong.
> > 
> > For two usecases:
> > 
> > a) Being able to detect if something is a mount point. The traditional
> >    way to do this is by stat()ing the dir in question and its parent
> >    and comparing st_dev. That logic is not able to detect bind mounts
> >    however, if destination and the place the mount is at are actually
> >    on the same file system... Thus we check the mount id too, if we
> >    can get our hands on it.
> 
> So what you really want in the mount id in st_buf.st_dev, not the
> underlying device number. i.e. fstatat(dirfd, path, buf,
> AT_MOUNTID)?

Well, I am not a fan of overloading things, and there might be reasons
why one would want to know both the mount id and the device id at the
same time with one atomic call, but ultimately I don't really care,
and fstatat(AT_MOUNT_ID) would certainly be at least as useful as
name_to_handle_at() is. 

Lennart
