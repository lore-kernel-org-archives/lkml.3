Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936252Ab3DJNnL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 09:43:11 -0400
Received: from relay3.sgi.com ([192.48.152.1]:42727 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S936109Ab3DJNnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 09:43:09 -0400
Date: Wed, 10 Apr 2013 08:43:07 -0500
From: Robin Holt <holt@sgi.com>
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] rootmpfs
Message-ID: <20130410134307.GB3672@sgi.com>
References: <1364992208.18069.18@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364992208.18069.18@driftwood>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 03, 2013 at 07:30:08AM -0500, Rob Landley wrote:
> Attached is my quick and dirty hack to make rootfs be tmpfs when
> CONFIG_TMPFS is
> enabled. It can't be this easy or somebody would have done it in the

I don't see anything attached, but...

I have been running using tmpfs as my root for years.  I tweaked the
debian initrd scripts to mount a tmpfs filesystem, cpio recover a
compressed cpio image from the disk drive and then pivotroot.  Did not
require any kernel tweaks.

Thanks,
Robin

> _eight_years_
> since https://lkml.org/lkml/2006/7/31/145
> 
> Yes, it's got an #ifdef and out of place prototypes. Yes, it
> manually calls a module
> init function and compensates by making it reentrant. But it works,
> and when I
> "cat /dev/zero > filename" the filesystem fills _up_ instead of
> panicing the kernel.
> 
> So now that I've posted the error, would someone please tell me how
> I _should_ have done it?
> 
> Rob
> 
> P.S. If I actually change the filesystem type to a name other than
> "rootfs", it panics on the way up because various bits of the kernel
> are looking for that magic name. Sigh.
> 
> P.P.S. removing MS_NOUSER is actually intentional, there's a local
> cray patch that does the same thing because otherwise you can't
> --bind mount directories out of this filesystem, which is a thing
> they wanted to do.--
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
