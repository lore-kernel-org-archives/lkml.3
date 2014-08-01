Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212AbaHAWl3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 18:41:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37636 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbaHAWl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 18:41:28 -0400
Date: Fri, 1 Aug 2014 15:41:27 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Aniroop Mathur <aniroop.mathur@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org
Subject: Re: [Question: Drivers/base/core.c] Why dev->init_name = NULL in
 device_add function ?
Message-ID: <20140801224127.GA11596@kroah.com>
References: <CADYu30_FciG_aTTV4DFNdy+CdRChMYQ7pAGZGambE1F9s=ofYQ@mail.gmail.com>
 <20140801192300.GB16085@kroah.com>
 <CADYu30_o7rzERKEDe=eZiONp6n1ktMWPydMnXQjDeLrDFQh+vg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADYu30_o7rzERKEDe=eZiONp6n1ktMWPydMnXQjDeLrDFQh+vg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 02, 2014 at 03:54:32AM +0530, Aniroop Mathur wrote:
> On Sat, Aug 2, 2014 at 12:53 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Fri, Aug 01, 2014 at 10:43:23PM +0530, Aniroop Mathur wrote:
> >> Dear Mr. Greg Kroah-Hartman and Linux Community,
> >> Greetings of the day !! :)
> >>
> >> I am Aniroop Mathur working on Linux Kernel for last two years.
> >> I am stuck at one point and could not find the solution over internet.
> >> I posted on linuxquestions.org too.
> >> So I need your help and suggestion for it.
> >>
> >> Can you please help in answering my query as below:
> >>
> >> =====================================================
> >> In function device_add of /drivers/base/core.c file, it is mentioned:
> >> /*
> >> * for statically allocated devices, which should all be converted
> >> * some day, we need to initialize the name. We prevent reading back
> >> * the name, and force the use of dev_name()
> >> */
> >> if (dev->init_name) {
> >> dev_set_name(dev, "%s", dev->init_name);
> >> dev->init_name = NULL;
> >> }
> >>
> >>
> >> Except forcing the use of dev_name to read device name,
> >> Is there any other reason to make init_name as NULL ?
> >
> > Why would you want init_name to not be NULL?
> >
> 
> Currently in kernel, we cannot set name of event node.

What do you mean by "event node"?

> If dev->init_name is not set as NULL in device_add(),
> then I can easily set name of event node in evdev_dev.c
> file as below:
> 
> if(dev->init_name) {
>       sprintf(dev->init_name, "event_%s", dev->init_name);
> }
> error = device_add(&evdev->dev);
> 
> And in some input device driver code, I will use like below:
> dev->init_name = "accelerometer";
> input_register_device(dev);

What's wrong with:
	dev_set_name(dev, "%s", "accelerometer");
	input_register_device(dev);

> So, overall output will be
> /dev/input/event<x> --> /dev/input/event_accelerometer
> sys/class/input/input<x> --> sys/class/input/accelerometer
> 
> In short, input and event node names are set just by
> adding one line, which i found quite efficient.
> There is other way also to set name of event node but
> it involves using extra variable and little more code,
> So I am looking for best solution possible. :)

Only use init_name for static struct devices, for a dynamic one, jsut
set the name like everyone else does, how is that "more" code than
anything else?

> >> And if it is not made NULL, is there any problem or side-effect ?
> >
> > Yes, people would start to use it thinking it was the real name of the
> > device, when it might not be.
> >
> 
> As the name itself nicely suggests, it is just a initial name.

So please do not use it, someday it will go away...

thanks,

greg k-h
