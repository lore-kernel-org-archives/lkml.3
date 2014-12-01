Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525AbaLADyp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 22:54:45 -0500
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:48606 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752245AbaLADyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 22:54:44 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkQQAKzle1R5LLkm/2dsb2JhbABbgwaBKbNLAQEBAgEGlE+FIgQCAoENFwEBAQEBfYQDAQEEOhwjEAgDDgoJJQ8FJQMhE4g/0hIBAQgCIBiGH4pEB4RIAQScRoEvgzuHRokUhA8rMIJHAQEB
Date: Mon, 1 Dec 2014 14:54:26 +1100
From: Dave Chinner <david@fromorbit.com>
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: Richard Weinberger <richard@nod.at>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org,
        "systemd-devel@lists.freedesktop.org" 
	<systemd-devel@lists.freedesktop.org>
Subject: Re: [PATCH] x86: defconfig: Enable CONFIG_FHANDLE
Message-ID: <20141201035426.GK9561@dastard>
References: <1416958612-7448-1-git-send-email-richard@nod.at>
 <20141130205430.GD16151@dastard>
 <547B8731.90305@nod.at>
 <20141201001849.GJ9561@dastard>
 <547BB929.3020805@nod.at>
 <20141201010343.GB18495@gardel-login>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141201010343.GB18495@gardel-login>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 02:03:43AM +0100, Lennart Poettering wrote:
> On Mon, 01.12.14 01:41, Richard Weinberger (richard@nod.at) wrote:
> 
> > CC'ing systemd folks.
> > 
> > Lennart, can you please explain why you need CONFIG_FHANDLE for systemd?
> > Maybe I'm reading the source horrible wrong.
> 
> For two usecases:
> 
> a) Being able to detect if something is a mount point. The traditional
>    way to do this is by stat()ing the dir in question and its parent
>    and comparing st_dev. That logic is not able to detect bind mounts
>    however, if destination and the place the mount is at are actually
>    on the same file system... Thus we check the mount id too, if we
>    can get our hands on it.

So what you really want in the mount id in st_buf.st_dev, not the
underlying device number. i.e. fstatat(dirfd, path, buf,
AT_MOUNTID)?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
