Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275Ab3BYWkR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 17:40:17 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:58752 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759614Ab3BYWkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 17:40:14 -0500
MIME-Version: 1.0
In-Reply-To: <20130225221238.GA10575@kroah.com>
References: <1361473348-7660-1-git-send-email-milos.vyletel@sde.cz>
 <87y5ehfczy.fsf@rustcorp.com.au> <20130225221238.GA10575@kroah.com>
From: Kay Sievers <kay@vrfy.org>
Date: Mon, 25 Feb 2013 23:39:52 +0100
Message-ID: <CAPXgP13M_krpPMFoBroYkXc4dUQHsZJDua-jSGby8cQ1Afy-HQ@mail.gmail.com>
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

On Mon, Feb 25, 2013 at 11:12 PM, Greg KH <greg@kroah.com> wrote:

> Hm, I thought we were frowning apon running binaries from udev rules
> these days, especially ones that might have big consequences (like
> resizing a disk image) like this.
>
> Kay, am I right?

We removed most of them from the default setups, yes. But there is
nothing wrong if people want to ship that in some package or as custom
rules.

It looks fine to me, we would just not add such things to the default
set of of rules these days.

> We already emit KOBJECT_CHANGE events when block devices change, from
> within the block core code.  Why is the patch below needed instead of
> using these events that are already generated?  How are virtio block
> devices special?

I think we only do that for dm and md and a couple of special cases
like loop and read-only settings.

Kay
