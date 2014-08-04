Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711AbaHDP4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 11:56:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56792 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbaHDP4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 11:56:17 -0400
Date: Sun, 3 Aug 2014 21:35:41 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Aniroop Mathur <aniroop.mathur@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org
Subject: Re: [Question: Drivers/base/core.c] Why dev->init_name = NULL in
 device_add function ?
Message-ID: <20140804043541.GA4665@kroah.com>
References: <CADYu30_FciG_aTTV4DFNdy+CdRChMYQ7pAGZGambE1F9s=ofYQ@mail.gmail.com>
 <20140801192300.GB16085@kroah.com>
 <CADYu30_o7rzERKEDe=eZiONp6n1ktMWPydMnXQjDeLrDFQh+vg@mail.gmail.com>
 <20140801224127.GA11596@kroah.com>
 <CADYu309eydkp83a1aMybHn5vyLLGBAmFDYeR59RRiC+mGc9w7w@mail.gmail.com>
 <20140802023958.GA22728@kroah.com>
 <CADYu30_EN78+1CdD=VF8gi-5H2Ot7ArKWq5DQ5HaptwTuL3C6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADYu30_EN78+1CdD=VF8gi-5H2Ot7ArKWq5DQ5HaptwTuL3C6A@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2014 at 12:24:06AM +0530, Aniroop Mathur wrote:
> On Sat, Aug 2, 2014 at 8:09 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Sat, Aug 02, 2014 at 05:14:44AM +0530, Aniroop Mathur wrote:
> >> >> So, overall output will be
> >> >> /dev/input/event<x> --> /dev/input/event_accelerometer
> >> >> sys/class/input/input<x> --> sys/class/input/accelerometer
> >> >>
> >> >> In short, input and event node names are set just by
> >> >> adding one line, which i found quite efficient.
> >> >> There is other way also to set name of event node but
> >> >> it involves using extra variable and little more code,
> >> >> So I am looking for best solution possible. :)
> >> >
> >> > Only use init_name for static struct devices, for a dynamic one, jsut
> >> > set the name like everyone else does, how is that "more" code than
> >> > anything else?
> >> >
> >>
> >> Can you please elaborate what do you mean by static struct devices ?
> >
> > Exactly what you wrote there, 'static' is a C thing, right?
> >
> >> Can I consider embedded accelerometer, proximity, gyro sensor,
> >> touch panel in android mobile devices as static devices ?
> >
> > Nope, because in my Android phone, I can yank out those and add new ones
> > on the fly while the phone is running.  The kernel is fully dynamic that
> > way.
> >
> >> Input subsystem is setting default name of input and event node.
> >
> > As it should.
> >
> >> This is the normal method everyone uses.
> >
> > And so should you :)
> >
> >> I do not want to use default name like event0, event4, input2, etc
> >
> > Yes, you really do.
> >
> >> My aim is to set name of input and event node through driver as desired.
> >
> > Nope, that's userspace's job, just use udev to rename the device node,
> > or even better yet, create a symlink like /dev/input/by-id/ has if you
> > really need more than that.
> >
> > Don't mess with kernel device names, we can't do that without breaking
> > tons of things, there's a reason that we standardized on something,
> > please use it.
> >
> 
> Okay, will follow the same. :)
> 
> One last thing,
> Why init_name will go away some day ?

Because you should never have a static struct device in the kernel.
It's a reference counted object that needs to always be dynamically
allocated in order to properly work.  Unfortunatly, there are some users
who have it allocated statically (on the stack) instead of dynamically
(on the heap).  I'll get rid of them someday, it's _way_ down my list of
things to do...

thanks,

greg k-h
