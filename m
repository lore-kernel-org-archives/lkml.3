Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417AbbAOVSY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 16:18:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59133 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751510AbbAOVSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 16:18:23 -0500
Message-ID: <1421356698.3933.18.camel@nilsson.home.kraxel.org>
Subject: Re: [PATCH v3 00/16] virtio-pci: towards virtio 1.0 guest support
From: Gerd Hoffmann <kraxel@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
Date: Thu, 15 Jan 2015 22:18:18 +0100
In-Reply-To: <1421256142-11512-1-git-send-email-mst@redhat.com>
References: <1421256142-11512-1-git-send-email-mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

> QEMU side is still undergoing polishing, but is already testable.

Looked art the qemu side for now, commenting here due to qemu patches
not being posted to the list yet (guess that is at least partly already
on your todo list):

 * Both legacy and modern should be switchable.  Modern needs to be
   switchable _anyway_ for backward compatibility with old qemu
   versions.  But legacy should be too, for testing purposes and for
   new device types which don't need legacy in the first place.

 * I'd like to see some more flexibility in the pci bar layout.  Stuff
   I have in mind:
    - New devices which don't need a legacy bar can use bar 0 for
      modern.
    - One MMIO bar is enough, we can place both virtio regions and
      msi-x regions there.  I'd suggest to add msi-x sub-regions to
      the modern bar.

 * What is the reason for making the modern bar 8M in size?  Looks a bit
   excessive, given that only 64k or so of that are actually used ...

virtio-scsi seems to be broken, at least my usual fedora guest didn't
boot up from virtio-scsi disk when using a guest kernel with this patch
series applied.

cheers,
  Gerd


