Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759913Ab3BYXi2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 18:38:28 -0500
Received: from mail4.sde.cz ([85.93.125.197]:52017 "EHLO zimbra.sde"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759861Ab3BYXiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 18:38:22 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH] virtio-blk: emit udev event when device is resized
From: Milos Vyletel <milos.vyletel@sde.cz>
In-Reply-To: <CAPXgP13M_krpPMFoBroYkXc4dUQHsZJDua-jSGby8cQ1Afy-HQ@mail.gmail.com>
Date: Mon, 25 Feb 2013 18:38:15 -0500
Cc: Greg KH <greg@kroah.com>, Rusty Russell <rusty@rustcorp.com.au>,
        linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org,
        virtualization@lists.linux-foundation.org, mst@redhat.com
Content-Transfer-Encoding: 7bit
Message-Id: <42E0FED8-EC29-431F-8DE6-DA926CC946C5@sde.cz>
References: <1361473348-7660-1-git-send-email-milos.vyletel@sde.cz> <87y5ehfczy.fsf@rustcorp.com.au> <20130225221238.GA10575@kroah.com> <CAPXgP13M_krpPMFoBroYkXc4dUQHsZJDua-jSGby8cQ1Afy-HQ@mail.gmail.com>
To: Kay Sievers <kay@vrfy.org>
X-Mailer: Apple Mail (2.1499)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 25, 2013, at 5:39 PM, Kay Sievers <kay@vrfy.org> wrote:

> On Mon, Feb 25, 2013 at 11:12 PM, Greg KH <greg@kroah.com> wrote:
> 
>> Hm, I thought we were frowning apon running binaries from udev rules
>> these days, especially ones that might have big consequences (like
>> resizing a disk image) like this.
>> 
>> Kay, am I right?
> 
> We removed most of them from the default setups, yes. But there is
> nothing wrong if people want to ship that in some package or as custom
> rules.
> 
> It looks fine to me, we would just not add such things to the default
> set of of rules these days.

That was not my intention. I just wanted to demonstrate that event like this
could be useful in cases like filesystem resize. We have a need for automatic
resize by our customers so we will ship our custom udev rules. It's perfectly
understandable that default udev rules will not have this.

Milos

> 
>> We already emit KOBJECT_CHANGE events when block devices change, from
>> within the block core code.  Why is the patch below needed instead of
>> using these events that are already generated?  How are virtio block
>> devices special?
> 
> I think we only do that for dm and md and a couple of special cases
> like loop and read-only settings.
> 
> Kay

