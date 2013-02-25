Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758437Ab3BYXEi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 18:04:38 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:39789 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148Ab3BYXEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 18:04:37 -0500
MIME-Version: 1.0
In-Reply-To: <20130225224339.GA19153@kroah.com>
References: <1361473348-7660-1-git-send-email-milos.vyletel@sde.cz>
 <87y5ehfczy.fsf@rustcorp.com.au> <20130225221238.GA10575@kroah.com>
 <CAPXgP13M_krpPMFoBroYkXc4dUQHsZJDua-jSGby8cQ1Afy-HQ@mail.gmail.com> <20130225224339.GA19153@kroah.com>
From: Kay Sievers <kay@vrfy.org>
Date: Tue, 26 Feb 2013 00:04:15 +0100
Message-ID: <CAPXgP100NjPw4JVe39gL829MwKL2YLFSKN2fvaB7skbCub-Ehg@mail.gmail.com>
Subject: Re: [PATCH] virtio-blk: emit udev event when device is resized
To: Greg KH <greg@kroah.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Milos Vyletel <milos.vyletel@sde.cz>, linux-kernel@vger.kernel.org,
        linux-hotplug@vger.kernel.org,
        virtualization@lists.linux-foundation.org, mst@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 11:43 PM, Greg KH <greg@kroah.com> wrote:
> On Mon, Feb 25, 2013 at 11:39:52PM +0100, Kay Sievers wrote:
>> On Mon, Feb 25, 2013 at 11:12 PM, Greg KH <greg@kroah.com> wrote:
>>
>> > Hm, I thought we were frowning apon running binaries from udev rules
>> > these days, especially ones that might have big consequences (like
>> > resizing a disk image) like this.
>> >
>> > Kay, am I right?
>>
>> We removed most of them from the default setups, yes. But there is
>> nothing wrong if people want to ship that in some package or as custom
>> rules.
>>
>> It looks fine to me, we would just not add such things to the default
>> set of of rules these days.
>>
>> > We already emit KOBJECT_CHANGE events when block devices change, from
>> > within the block core code.  Why is the patch below needed instead of
>> > using these events that are already generated?  How are virtio block
>> > devices special?
>>
>> I think we only do that for dm and md and a couple of special cases
>> like loop and read-only settings.
>
> What about when we repartition a block device?  I've seen the events
> happen then.

Right, from the common block code we send events for removable media
changes like cdroms, sd cards, when a device is switched to read-only,
and when we re-scan a partition table like on re-partitioning. Most of
the other events are block subsystem-specific like this one. For
things like device-mapper they are used pretty heavily.

> Anyway, if you are ok with this, no objection from my side then Rusty.

Looks fine to me, it should not do any harm if there are not heavy
programs hooked up -- which is nothing the kernel could fix if people
do that. :)

Kay
