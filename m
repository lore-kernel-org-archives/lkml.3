Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab3G2CDS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 22:03:18 -0400
Received: from ozlabs.org ([203.10.76.45]:50458 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752097Ab3G2CDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 22:03:17 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Sudeep Dutt <sudeep.dutt@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, "Michael S. Tsirkin" <mst@redhat.com>,
        Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux-doc@vger.kernel.org
Cc: Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Caz Yokoyama <Caz.Yokoyama@intel.com>,
        Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>,
        Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>,
        "Yaozu \(Eddie\) Dong" <eddie.dong@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>
Subject: Re: [PATCH 4/5] Intel MIC Card Driver Changes for Virtio Devices.
In-Reply-To: <ff721c257100467e8f78421ba9055b97e447551e.1374717252.git.sudeep.dutt@intel.com>
References: <cover.1374717252.git.sudeep.dutt@intel.com> <ff721c257100467e8f78421ba9055b97e447551e.1374717252.git.sudeep.dutt@intel.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 29 Jul 2013 11:28:58 +0930
Message-ID: <87txje6s9p.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sudeep Dutt <sudeep.dutt@intel.com> writes:
> From: Ashutosh Dixit <ashutosh.dixit@intel.com>
>
> This patch introduces the card "Virtio over PCIe" interface for
> Intel MIC. It allows virtio drivers on the card to communicate with their
> user space backends on the host via a device page. Ring 3 apps on the host
> can add, remove and configure virtio devices. A thin MIC specific
> virtio_config_ops is implemented which is borrowed heavily from previous
> similar implementations in lguest and s390 @
> drivers/lguest/lguest_device.c
> drivers/s390/kvm/kvm_virtio.c

Wow, this is pretty cool!

Note that the lguest implementation is a bit limited, but lguest doesn't
have a real ABI, so we can simply change it if we wanted to.  I assume
you don't have that luxury.

In particular, you may want to get rid of the historical align constant,
and have explicit avail and used addresses.

Cheers,
Rusty.
