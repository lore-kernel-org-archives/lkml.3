Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054Ab3LRVBm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:01:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35703 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab3LRVBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:01:40 -0500
Date: Wed, 18 Dec 2013 13:01:41 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-kernel@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk, arnd@arndb.de,
        hpa@zytor.com
Subject: Re: [PATCH v2] misc: Reserve minor for VFIO
Message-ID: <20131218210141.GA11267@kroah.com>
References: <20131218204024.30540.55302.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131218204024.30540.55302.stgit@bling.home>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 01:56:32PM -0700, Alex Williamson wrote:
> VFIO currently allocates it's own dynamic chardev range, reserving the
> first minor for the control part of the interface (/dev/vfio/vfio) and
> the remainder for VFIO groups (/dev/vfio/$GROUP).  This works, but it
> doesn't support auto loading.  For instance when libvirt checks for
> VFIO support it looks for /dev/vfio/vfio, which currently doesn't
> exist unless the vfio module is loaded.  By converting the control
> device to a misc driver and reserving a static minor, we can enable
> auto loading.
> 
> Reserving the minor is a prerequist to that conversion.  Minor 196
> is unused by anything currently in the kernel.
> 
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
> 
> v2: Plea for ack edition
> 
> As Alan suspected, there's been no response from device@lanana.org,
> so there's probably nobody monitoring it anymore.  I've done due
> diligence looking at all the callers of misc_register() in linux-next
> and cannot find any conflicts with minor 196.  If anyone wants to toss
> me an ack or sign-off I'll be happy to bring this in through my vfio
> tree, otherwise I'd appreciate if someone wants to take it directly.
> Thanks!
> 
>  Documentation/devices.txt  |    1 +
>  include/linux/miscdevice.h |    1 +
>  2 files changed, 2 insertions(+)

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Feel free to take this through your tree.

thanks,

greg k-h
