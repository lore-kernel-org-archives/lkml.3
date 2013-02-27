Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759911Ab3B0BwM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 20:52:12 -0500
Received: from ozlabs.org ([203.10.76.45]:55780 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759240Ab3B0BwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 20:52:09 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Milos Vyletel <milos.vyletel@sde.cz>, Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay@vrfy.org>, linux-kernel@vger.kernel.org,
        linux-hotplug@vger.kernel.org,
        virtualization@lists.linux-foundation.org, mst@redhat.com
Subject: Re: [PATCH] virtio-blk: emit udev event when device is resized
In-Reply-To: <16100EF6-6C55-47ED-9BBB-2C3CAC8FA37A@sde.cz>
References: <1361473348-7660-1-git-send-email-milos.vyletel@sde.cz> <87y5ehfczy.fsf@rustcorp.com.au> <20130225221238.GA10575@kroah.com> <16100EF6-6C55-47ED-9BBB-2C3CAC8FA37A@sde.cz>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Wed, 27 Feb 2013 11:04:14 +1030
Message-ID: <87wqtuegs9.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Milos Vyletel <milos.vyletel@sde.cz> writes:
> On Feb 25, 2013, at 5:12 PM, Greg KH <greg@kroah.com> wrote:
>
>> On Fri, Feb 22, 2013 at 10:14:49AM +1030, Rusty Russell wrote:
>>> Milos Vyletel <milos.vyletel@sde.cz> writes:
>>> 
>>>> When virtio-blk device is resized from host (using block_resize from QEMU) emit
>>>> KOBJ_CHANGE uevent to notify guest about such change. This allows user to have
>>>> custom udev rules which would take whatever action if such event occurs. As a
>>>> proof of concept I've created simple udev rule that automatically resize
>>>> filesystem on virtio-blk device.
>>>> 
>>>> ACTION=="change", KERNEL=="vd*", \
>>>>        ENV{RESIZE}=="1", \
>>>>        ENV{ID_FS_TYPE}=="ext[3-4]", \
>>>>        RUN+="/sbin/resize2fs /dev/%k"
>>>> ACTION=="change", KERNEL=="vd*", \
>>>>        ENV{RESIZE}=="1", \
>>>>        ENV{ID_FS_TYPE}=="LVM2_member", \
>>>>        RUN+="/sbin/pvresize /dev/%k"
>>> 
>>> This looks fine to me, but I like to check with Greg before adding udev
>>> callouts.... Greg?
>> 
>> Hm, I thought we were frowning apon running binaries from udev rules
>> these days, especially ones that might have big consequences (like
>> resizing a disk image) like this.
>> 
>> Kay, am I right?
>> 
>> We already emit KOBJECT_CHANGE events when block devices change, from
>> within the block core code.  Why is the patch below needed instead of
>> using these events that are already generated?  How are virtio block
>> devices special?
>> 
>>> BTW, if this is good, it's good for stable IMHO.
>> 
>> What bug does it fix?
>> 
>
> It is not really a bug but it definitely is useful enhancement to have in stable too. I
> can imagine lots of people can benefit from this.

But that applies to almost any enhancement :)

It will go in *next* merge window, not this one.

Thanks,
Rusty.
