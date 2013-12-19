Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575Ab3LSQig (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 11:38:36 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:55925 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753944Ab3LSQif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 11:38:35 -0500
Date: Thu, 19 Dec 2013 11:38:34 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
cc: Rashika Kheria <rashika.kheria@gmail.com>, <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <josh@joshtriplett.org>
Subject: Re: [PATCH 3/7] drivers: usb: Include appropriate header file in
 hcd.h
In-Reply-To: <52B32987.7070402@cogentembedded.com>
Message-ID: <Pine.LNX.4.44L0.1312191128500.984-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Dec 2013, Sergei Shtylyov wrote:

> Hello.
> 
> On 12/19/2013 06:45 PM, Alan Stern wrote:
> 
> >> Include header file include/linux/usb.h in include/linux/usb/hcd.h
> >> because structures usb_device, usb_host_config and usb_interface have
> >> their definitions in include/linux/usb.h.
> 
> >> This eliminates the following warning in include/linux/usb/hcd.h:
> >> include/linux/usb/hcd.h:311:44: warning: ‘struct usb_device’ declared inside parameter list [enabled by default]
> >> include/linux/usb/hcd.h:412:10: warning: ‘struct usb_host_config’ declared inside parameter list [enabled by default]
> >> include/linux/usb/hcd.h:614:9: warning: ‘struct usb_interface’ declared inside parameter list [enabled by default]
> 
>     Rashika, would it be enough to forward-declare these structures ISO 
> #include'ing the whole header?

I agree, that would fix the problem.

> > Where does this problem show up?
> >
> > Any file that include linux/usb/hcd.h should include linux/usb.h first.
> > IMO it would be better to fix the source files that don't do the
> > includes properly.
> 
>     Yeah, let's fix the consequency instead of the cause. :-)

The _real_ cause is that the Linux source code is extremely
complicated, and it is remarkably difficult to insure that all header
files have no unsatisfied dependencies.  How do you suggest fixing
_that_?

For example, suppose A.c includes B.h, and B.h includes C.h, and C.h
defines struct foo.  Then A.c can use struct foo freely without
including C.h directly (and this sort of thing happens quite a lot in
the kernel source).  But consider what happens when B.h is changed so
that it no longer includes C.h.

> > Of course, people have varying opinions on this issue.  As far as I
> > know, there is no fixed policy in the kernel about nested includes.
> 
>     So far, I've only encountered the dubious policy of satisfying header's 
> dependencies in the files that include them is the USB tree.

Have you looked in any other places?  For that matter, how do you know
that the USB tree has such a policy?  Is it documented anywhere?

Alan Stern

