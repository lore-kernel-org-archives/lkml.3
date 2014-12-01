Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205AbaLAATG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 19:19:06 -0500
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:35191 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751920AbaLAATE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 19:19:04 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkUQAEuze1R5LLkm/2dsb2JhbABbgwaBKbNMAQEBAgEGlE+FIgQCAoEKFwEBAQEBfYQCAQEBAwE6HCMFCwgDGAklDwUlAyETiDcI0WYBCyAYhh+JWWsHhEgBBJxGjDCJFB6DcSswgkcBAQE
Date: Mon, 1 Dec 2014 11:18:49 +1100
From: Dave Chinner <david@fromorbit.com>
To: Richard Weinberger <richard@nod.at>
Cc: x86@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        gregkh@linuxfoundation.org, rafael.j.wysocki@intel.com,
        pebolle@tiscali.nl, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: defconfig: Enable CONFIG_FHANDLE
Message-ID: <20141201001849.GJ9561@dastard>
References: <1416958612-7448-1-git-send-email-richard@nod.at>
 <20141130205430.GD16151@dastard>
 <547B8731.90305@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <547B8731.90305@nod.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 30, 2014 at 10:08:01PM +0100, Richard Weinberger wrote:
> Am 30.11.2014 um 21:54 schrieb Dave Chinner:
> > On Wed, Nov 26, 2014 at 12:36:52AM +0100, Richard Weinberger wrote:
> >> systemd has a hard dependency on CONFIG_FHANDLE.
> >> If you run systemd with CONFIG_FHANDLE=n it will somehow
> >> boot but fail to spawn a getty or other basic services.
> >> As systemd is now used by most x86 distributions it
> >> makes sense to enabled this by default and save kernel
> >> hackers a lot of value debugging time.
> > 
> > The bigger question to me is this: why does systemd need to
> > store/open by handle rather than just opening paths directly when
> > needed? This interface is intended for stable, pathless access to
> > inodes across unmount/mount contexts (e.g. userspace NFS servers,
> > filesystem backup programs, etc) so I'm curious as to the problem
> > systemd is solving using this interface. I just can't see the
> > problem being solved here, and why path based security checks on
> > every open() aren't necessary...
> 
> Digging inter systemd source shows that they are using name_to_handle_at()
> to get the mount id of a given path.

>From the name_to_handle_at() man page:

    The mount_id argument returns an identifier for the filesystem
    mount that corresponds to pathname.  This corresponds to the
    first  field in  one  of  the records in /proc/self/mountinfo.
    Opening the pathname in the fifth field of that record yields a
    file descriptor for the mount point; that file descriptor can be
    used in a subsequent call to open_by_handle_at().

So why do they need CONFIG_FHANDLE to get the mount id in userspace?
Indeed, what do they even need the mount id for?

> The actual struct file_handle result is always ignored.

That sounds like a classic case of interface abuse. i.e. using an
interface for something it was not designed or intended for....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
