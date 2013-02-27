Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759975Ab3B0NKR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 08:10:17 -0500
Received: from mail4.sde.cz ([85.93.125.197]:36607 "EHLO zimbra.sde"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759835Ab3B0NKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 08:10:15 -0500
Date: Wed, 27 Feb 2013 14:09:48 +0100 (CET)
From: Milos Vyletel <milos.vyletel@sde.cz>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Greg KH <greg@kroah.com>, Kay Sievers <kay@vrfy.org>,
        linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org,
        virtualization@lists.linux-foundation.org, mst@redhat.com
Message-ID: <1972692083.62396.1361970588620.JavaMail.root@sde.cz>
In-Reply-To: <87wqtuegs9.fsf@rustcorp.com.au>
References: <1361473348-7660-1-git-send-email-milos.vyletel@sde.cz> <87y5ehfczy.fsf@rustcorp.com.au> <20130225221238.GA10575@kroah.com> <16100EF6-6C55-47ED-9BBB-2C3CAC8FA37A@sde.cz> <87wqtuegs9.fsf@rustcorp.com.au>
Subject: Re: [PATCH] virtio-blk: emit udev event when device is resized
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [199.72.20.10]
X-Mailer: Zimbra 8.0.2_GA_5569 (ZimbraWebClient - FF16 (Win)/8.0.2_GA_5569)
Thread-Topic: virtio-blk: emit udev event when device is resized
Thread-Index: L2+lY4veybV/otvQR4qrApeoJNdAsQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> Milos Vyletel <milos.vyletel@sde.cz> writes:
> > On Feb 25, 2013, at 5:12 PM, Greg KH <greg@kroah.com> wrote:
> >
> >> On Fri, Feb 22, 2013 at 10:14:49AM +1030, Rusty Russell wrote:
> >>> Milos Vyletel <milos.vyletel@sde.cz> writes:
> >>> 
> >>>> When virtio-blk device is resized from host (using block_resize from
> >>>> QEMU) emit
> >>>> KOBJ_CHANGE uevent to notify guest about such change. This allows user
> >>>> to have
> >>>> custom udev rules which would take whatever action if such event occurs.
> >>>> As a
> >>>> proof of concept I've created simple udev rule that automatically resize
> >>>> filesystem on virtio-blk device.
> >>>> 
> >>>> ACTION=="change", KERNEL=="vd*", \
> >>>>        ENV{RESIZE}=="1", \
> >>>>        ENV{ID_FS_TYPE}=="ext[3-4]", \
> >>>>        RUN+="/sbin/resize2fs /dev/%k"
> >>>> ACTION=="change", KERNEL=="vd*", \
> >>>>        ENV{RESIZE}=="1", \
> >>>>        ENV{ID_FS_TYPE}=="LVM2_member", \
> >>>>        RUN+="/sbin/pvresize /dev/%k"
> >>> 
> >>> This looks fine to me, but I like to check with Greg before adding udev
> >>> callouts.... Greg?
> >> 
> >> Hm, I thought we were frowning apon running binaries from udev rules
> >> these days, especially ones that might have big consequences (like
> >> resizing a disk image) like this.
> >> 
> >> Kay, am I right?
> >> 
> >> We already emit KOBJECT_CHANGE events when block devices change, from
> >> within the block core code.  Why is the patch below needed instead of
> >> using these events that are already generated?  How are virtio block
> >> devices special?
> >> 
> >>> BTW, if this is good, it's good for stable IMHO.
> >> 
> >> What bug does it fix?
> >> 
> >
> > It is not really a bug but it definitely is useful enhancement to have in
> > stable too. I
> > can imagine lots of people can benefit from this.
> 
> But that applies to almost any enhancement :)
> 

Good point :) 

> It will go in *next* merge window, not this one.
> 

Cool, thanks.

Milos
