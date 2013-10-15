Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759809Ab3JOTzt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 15:55:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52687 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759766Ab3JOTzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 15:55:47 -0400
Date: Tue, 15 Oct 2013 12:55:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: Paul Chavent <Paul.Chavent@onera.fr>, linux-kernel@vger.kernel.org,
        Alexander Gordeev <agordeev@redhat.com>
Subject: Re: [PATCH] pps : add non blocking option to PPS_FETCH ioctl.
Message-Id: <20131015125545.1920ab5453136f3de5f2aa66@linux-foundation.org>
In-Reply-To: <20131015104350.GI4285@enneenne.com>
References: <1381495232-12152-1-git-send-email-paul.chavent@onera.fr>
	<20131011124720.bf38f18affa8baf0b009875a@linux-foundation.org>
	<20131015104350.GI4285@enneenne.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Oct 2013 12:43:50 +0200 Rodolfo Giometti <giometti@enneenne.com> wrote:

> On Fri, Oct 11, 2013 at 12:47:20PM -0700, Andrew Morton wrote:
> > On Fri, 11 Oct 2013 14:40:32 +0200 Paul Chavent <Paul.Chavent@onera.fr> wrote:
> > 
> > > The PPS_FETCH ioctl is blocking still the reception of a PPS
> > > event. But, in some case, one may immediately need the last event
> > > date. This patch allow to get the result of PPS_FETCH if the device
> > > has the O_NONBLOCK flag set.
> > 
> > Are the PPS ioctls actually documented anywhere? 
> > Documentation/pps/pps.txt is silent.
> > 
> > That's a shame, because it would be nice to have a formal description
> > of the the PPS_FETCH semantics which leads to an understanding of why
> > things are the way they are, how PPS_FETCH is supposed to be used, etc.
> > 
> > Also, the presence of such documentation would permit me to bug you for
> > not having updated it!  We need *some* channel for telling people about
> > the driver, and updates to it.  Maybe linuxpps.org has it somewhere,
> > but I couldn't immediately find it.
> 
> Hi Andrew! Actually RFC 2783 doesn't use ioctls to get access to PPS
> data but it defines some functions. LinuxPPS, that is the Linux PPS
> implementation, uses ioctls to implement these functions.
> 
> If you like having an idea about how these functions are implemented
> into LinuxPPS, you can see here:
> 
>    http://www.linuxpps.org/gitweb/?p=pps-tools;a=blob;f=timepps.h;h=d2628d2d061ea2a3623e57990d9ada62623773cf;hb=5980a044bcdb4c1d1a8b1ecff986fa63719519b3
> 
> > Your implementation requires that the file be opened non-blocking.  But
> > I'd have thought that adding a new and separate ioctl mode would be a
> > cleaner and more flexible implementation - that way an app which wants
> > both blocking and non-blocking behaviour doesn't need to open the file
> > twice.
> > 
> > Also, this is actually a non-backward-compatible change for any
> > application which happened to be opening the file with O_NONBLOCK! 
> > Hopefully there aren't any such applications...
> 
> The major application that I know using these layer is NTPD... however
> all RFC compliant applications should not use ioctls to get access the
> PPS data and this patch should be a "special" case.
> 

Thanks, but this doesn't really address my concerns.

- Where, if anywhere, is the Linux PPS API documented and how do we
  communicate changes such as this one to kernel users?

- Why require open(O_NONBLOCK) for this instead of adding a separate
  ioctl?
