Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712Ab3GORYn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 13:24:43 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:29983 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab3GORYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 13:24:40 -0400
Date: Mon, 15 Jul 2013 13:24:31 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: CONFIG_* used by user-space to figure out whether a feature is
 on/off
Message-ID: <20130715172431.GA8034@phenom.dumpdata.com>
References: <20130715154050.GA5941@phenom.dumpdata.com>
 <20130715170244.GA29883@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130715170244.GA29883@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 10:02:44AM -0700, Greg KH wrote:
> On Mon, Jul 15, 2013 at 11:40:50AM -0400, Konrad Rzeszutek Wilk wrote:
> > Hey Linus,
> > 
> > I am hoping you can help me draw an understanding and a line in sand whether:
> >  a) Tools should not depend on /proc/config.gz to figure out whether
> >     a kernel has some CONFIG_X=y feature.
> > 
> >  b) If they are OK to do so, what do we do when certain CONFIG_X options
> >     get reworked/removed. Would they be considered regressions? Aka
> >     is this similar to 'you shall not break user-space'?
> 
> CONFIG_ values never get exported to userspace, you need to dig to find
> them, and they don't "mean" anything to userspace.
> 
> You should test for the functionality of the kernel, not a CONFIG
> option, in my opinion.
> 
> I've been working with some userspace tools that were blindly looking at
> kernel version numbers (i.e. docker), and that too is not a good idea as
> distros backport features and fixes to older kernel versions, so you
> can't "rely" on that either.

OK.
> 
> > Irrespective of that, do you have any ideas of how a user-space program (say GRUB)
> > can figure out whether the configuration stanze it generates is supported by
> > the kernel. If you don't want to answer this question - since this might
> > open a can of worms you prefer not to deal with - that is absolutly OK.
> 
> Why does grub need to care about the kernel configuration?  Other
> bootloaders sure don't.  A bootloader just needs to load a blob and pass
> control over to it, no need to care what is in that blob at all, right?

If life was that simple.. This particular issue was with inhibiting certain
config stanzas if certain features were not built in the kernel. Here is the
bug that started it:
  http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=633127

And this thread has more details:
 https://groups.google.com/forum/#!topic/linux.kernel/9VQqxBr-NOE

Make sure you get your favorite beverage and food substance when reading it.
> 
> What am I missing here?

I am trying to make sure that the line is drawn so that when a patch is
proposed for grub2 and a discussion starts it is the right fix and not
a half-way fix that only fixes part of the problem.

> 
> thanks,
> 
> gre gk-h
