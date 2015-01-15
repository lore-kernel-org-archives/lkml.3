Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146AbbAOVdC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 16:33:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45655 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753068AbbAOVdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 16:33:00 -0500
Date: Thu, 15 Jan 2015 23:32:56 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v3 00/16] virtio-pci: towards virtio 1.0 guest support
Message-ID: <20150115213256.GA4813@redhat.com>
References: <1421256142-11512-1-git-send-email-mst@redhat.com>
 <1421356698.3933.18.camel@nilsson.home.kraxel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421356698.3933.18.camel@nilsson.home.kraxel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2015 at 10:18:18PM +0100, Gerd Hoffmann wrote:
>   Hi,
> 
> > QEMU side is still undergoing polishing, but is already testable.
> 
> Looked art the qemu side for now, commenting here due to qemu patches
> not being posted to the list yet (guess that is at least partly already
> on your todo list):

Absolutely.

>  * Both legacy and modern should be switchable.  Modern needs to be
>    switchable _anyway_ for backward compatibility with old qemu
>    versions.  But legacy should be too, for testing purposes and for
>    new device types which don't need legacy in the first place.

I agree.

>  * I'd like to see some more flexibility in the pci bar layout.  Stuff
>    I have in mind:
>     - New devices which don't need a legacy bar can use bar 0 for
>       modern.
>     - One MMIO bar is enough, we can place both virtio regions and
>       msi-x regions there.  I'd suggest to add msi-x sub-regions to
>       the modern bar.

Why exactly? It seems simpler to separate things, extra BARs
have no cost.

>  * What is the reason for making the modern bar 8M in size?  Looks a bit
>    excessive, given that only 64k or so of that are actually used ...

I use a page per VQ for architectures that can locate the offset of the
accessed page that triggered EPT violation faster than the offset within
page.  I think this is the case for SVM.

> 
> virtio-scsi seems to be broken, at least my usual fedora guest didn't
> boot up from virtio-scsi disk when using a guest kernel with this patch
> series applied.
> 
> cheers,
>   Gerd

I'll re-test. Do other devices work for you? Thanks!

