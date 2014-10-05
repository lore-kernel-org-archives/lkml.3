Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbaJEVvD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 17:51:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34404 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbaJEVvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 17:51:00 -0400
Date: Sun, 5 Oct 2014 14:51:00 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jason Noakes <jjnoakes@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: kobject_init and the zeroed-out-memory requirement
Message-ID: <20141005215100.GA20426@kroah.com>
References: <CAN2+FEJY29jDF2PkGAYcG_0z=VQ4T+y7Ro56aeqrhSPYQ6ZEdw@mail.gmail.com>
 <20141005202843.GA1282@kroah.com>
 <CAN2+FEKsVyjV8v98R+V-xHseH1E2NKPquo6Z9nQc0M8d0Z620A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN2+FEKsVyjV8v98R+V-xHseH1E2NKPquo6Z9nQc0M8d0Z620A@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 05, 2014 at 04:47:42PM -0400, Jason Noakes wrote:
> > Is there any in-kernel code that does not properly zero out the memory
> > before calling kobject_init()?
> 
> I'm not sure. I didn't find any, but I've seen it bite people writing
> drivers more than once where I work, and the latest oops I just
> debugged a few days ago prompted me to address the issue and at least
> get the documentation updated.

No driver should be working with "raw" kobjects.

> >> Many other *_init kernel routines (cdev_init, kref_init, mutex_init,
> >> spin_lock_init, etc) do not have the same requirement - they work on fully
> >> uninitialized memory.
> >
> > They all do different things, you can't compare apples to oranges :)
> 
> Well, they are all named "_init", which to me implies that they
> initialize the object/memory passed in, which is true in all of the
> other cases I mentioned, but not for kobject_init. Perhaps it should
> have been called kobject_setup or something. But I digress...

kobject_init() has been there for a very long time, and yes, we don't
always have the best naming scheme in the kernel, that comes from
evolution over the years.

> >> Documentation/kobject.txt does not mention the requirement that the memory be
> >> zero-initialized before it is passed to kobject_init.
> >
> > Add a line of text to the kerneldoc for kobject_init to mention this?
> >
> > Or (a) is fine as well, if it makes you feel better, but if you do so,
> > just say that all memory for kobjects must be created with kzalloc() and
> > don't mention memset as that will cause people to try to reuse kobjects,
> > like they have in the past, and bad things will happen then.
> 
> Here is a patch updating the documentation (kobject.txt and
> kobject_init's usage documentation) so that the zeroed-out-memory
> requirement is explicit.
> 
> Signed-off-by: Jason J. Noakes <jjnoakes@gmail.com>

Care to resend this in a format I can apply it in (i.e. without this
discussion above the patch forcing me to edit the changelog)?

thanks,

greg k-h
