Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759901Ab3BYWnn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 17:43:43 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59829 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759674Ab3BYWnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 17:43:41 -0500
X-Sasl-enc: AE2ZOeXAd4T/ahW0yO+zFtxkhZrKWlzikDBjIXv2/WfZ 1361832220
Date: Mon, 25 Feb 2013 14:43:39 -0800
From: Greg KH <greg@kroah.com>
To: Kay Sievers <kay@vrfy.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Milos Vyletel <milos.vyletel@sde.cz>, linux-kernel@vger.kernel.org,
        linux-hotplug@vger.kernel.org,
        virtualization@lists.linux-foundation.org, mst@redhat.com
Subject: Re: [PATCH] virtio-blk: emit udev event when device is resized
Message-ID: <20130225224339.GA19153@kroah.com>
References: <1361473348-7660-1-git-send-email-milos.vyletel@sde.cz>
 <87y5ehfczy.fsf@rustcorp.com.au>
 <20130225221238.GA10575@kroah.com>
 <CAPXgP13M_krpPMFoBroYkXc4dUQHsZJDua-jSGby8cQ1Afy-HQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPXgP13M_krpPMFoBroYkXc4dUQHsZJDua-jSGby8cQ1Afy-HQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 11:39:52PM +0100, Kay Sievers wrote:
> On Mon, Feb 25, 2013 at 11:12 PM, Greg KH <greg@kroah.com> wrote:
> 
> > Hm, I thought we were frowning apon running binaries from udev rules
> > these days, especially ones that might have big consequences (like
> > resizing a disk image) like this.
> >
> > Kay, am I right?
> 
> We removed most of them from the default setups, yes. But there is
> nothing wrong if people want to ship that in some package or as custom
> rules.
> 
> It looks fine to me, we would just not add such things to the default
> set of of rules these days.
> 
> > We already emit KOBJECT_CHANGE events when block devices change, from
> > within the block core code.  Why is the patch below needed instead of
> > using these events that are already generated?  How are virtio block
> > devices special?
> 
> I think we only do that for dm and md and a couple of special cases
> like loop and read-only settings.

What about when we repartition a block device?  I've seen the events
happen then.

Anyway, if you are ok with this, no objection from my side then Rusty.

thanks,

greg k-h
