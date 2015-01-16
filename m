Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272AbbAPN1T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 08:27:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59574 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416AbbAPN1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 08:27:18 -0500
Message-ID: <1421414833.21318.67.camel@nilsson.home.kraxel.org>
Subject: Re: [PATCH v3 00/16] virtio-pci: towards virtio 1.0 guest support
From: Gerd Hoffmann <kraxel@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
Date: Fri, 16 Jan 2015 14:27:13 +0100
In-Reply-To: <20150116084541.GA29204@redhat.com>
References: <1421256142-11512-1-git-send-email-mst@redhat.com>
	 <1421356698.3933.18.camel@nilsson.home.kraxel.org>
	 <20150115213256.GA4813@redhat.com>
	 <1421397146.21318.16.camel@nilsson.home.kraxel.org>
	 <20150116084541.GA29204@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

> > > > virtio-scsi seems to be broken, at least my usual fedora guest didn't
> > > > boot up from virtio-scsi disk when using a guest kernel with this patch
> > > > series applied.
> > > 
> > > I'll re-test. Do other devices work for you? Thanks!
> > 
> > Didn't came very far yet in my testing due to the guest not booting.
> 
> Try virtio-blk - that worked for me.

Nope.  Booted from ide now, looked in /sys/bus/virtio/devices:

lrwxrwxrwx. 1 root root 0 Jan 16 14:15 virtio0
-> ../../../devices/pci0000:00/0000:00:0b.0/virtio0

lspci:

00:09.0 Ethernet controller: Red Hat, Inc Virtio network device
00:0a.0 Communication controller: Red Hat, Inc Virtio console
00:0b.0 Unclassified device [00ff]: Red Hat, Inc Virtio memory balloon

net + serial are missing ...

I'm running 3.19-rc4 with this series applied in the guest, maybe I need
more?

On the qemu side it is your virtio-1.0 branch from yesterday, rebased to
master.

cheers,
  Gerd


