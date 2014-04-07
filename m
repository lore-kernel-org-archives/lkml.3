Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694AbaDGTVU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 15:21:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38837 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755384AbaDGTVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 15:21:19 -0400
Date: Mon, 7 Apr 2014 12:23:47 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ken Cox <jkc@redhat.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, devel@driverdev.osuosl.org,
        sparmaintainer@unisys.com, linux-kernel@vger.kernel.org,
        Jet Chen <jet.chen@intel.com>
Subject: Re: [visorchipset] invalid opcode: 0000 [#1] PREEMPT SMP
Message-ID: <20140407192347.GA8272@kroah.com>
References: <20140407111725.GC25152@localhost>
 <20140407140958.GA7346@kroah.com>
 <5342B525.80407@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5342B525.80407@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 07, 2014 at 09:24:37AM -0500, Ken Cox wrote:
> 
> On 04/07/2014 09:09 AM, Greg Kroah-Hartman wrote:
> >On Mon, Apr 07, 2014 at 07:17:25PM +0800, Fengguang Wu wrote:
> >>Hi Ken,
> >>
> >>I got the below dmesg and the first bad commit is
> >>
> >>git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> >>
> >>commit 12e364b9f08aa335dc7716ce74113e834c993765
> >>Author:     Ken Cox <jkc@redhat.com>
> >>AuthorDate: Tue Mar 4 07:58:07 2014 -0600
> >>Commit:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >>CommitDate: Tue Mar 4 16:58:21 2014 -0800
> >>
> >>     staging: visorchipset driver to provide registration and other services
> >I think Sasha has already sent a fix to resolve this issue that I'll be
> >sending to Linus in a day or so.
> >
> >Ken, is Sasha's patch going to resolve this issue as well?  It looks
> >like people haven't tested what happens when the module is loaded
> >without the hardware present in the system :(
> You are exactly right.  The driver needs to check for hardware early on
> before trying to use it.  Unfortunately, Sasha's patch will not resolve this
> one.  I'll work with Ben Romer to get a patch out ASAP.

Wait, in looking at this closer, I don't see any of the "normal"
hardware checks to determine that this really is a valid piece of
hardware present, before it starts to just go and initialize a whole
bunch of things (sysfs busses, proc files and directories, and other
things.)

That's not ok, and it's obvious it's starting to affect people's work
systems.

How about I just mark the whole thing BROKEN for now, disabling the
build, until "correct" hardware probing can be added to the driver, so
no one else gets hurt by this?

thanks,

greg k-h
