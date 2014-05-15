Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941AbaEOWMe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 18:12:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38817 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbaEOWMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 18:12:33 -0400
Date: Thu, 15 May 2014 15:15:51 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: "Michael H. Warfield" <mhw@WittsEnd.com>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biederman <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        lxc-devel@lists.linuxcontainers.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [lxc-devel] [RFC PATCH 00/11] Add support for devtmpfs in user
 namespaces
Message-ID: <20140515221551.GB13306@kroah.com>
References: <1400103299-144589-1-git-send-email-seth.forshee@canonical.com>
 <20140515013245.GA1764@kroah.com>
 <1400120251.7699.11.camel@canyon.ip6.wittsend.com>
 <20140515031527.GA146352@ubuntu-hedt>
 <20140515040032.GA6702@kroah.com>
 <1400161337.7699.33.camel@canyon.ip6.wittsend.com>
 <20140515140856.GA17453@kroah.com>
 <20140515174254.GM21073@ubuntumail>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140515174254.GM21073@ubuntumail>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 05:42:54PM +0000, Serge Hallyn wrote:
> What exactly defines '"normal" use case for a container'?

Well, I'd say "acting like a virtual machine" is a good start :)

> Not too long ago much of what we can now do with network namespaces
> was not a normal container use case.  Neither "you can't do it now"
> nor "I don't use it like that" should be grounds for a pre-emptive
> nack.  "It will horribly break security assumptions" certainly would
> be.

I agree, and maybe we will get there over time, but this patch is nto
the way to do that.

> That's not to say there might not be good reasons why this in particular
> is not appropriate, but ISTM if things are going to be nacked without
> consideration of the patchset itself, we ought to be having a ksummit
> session to come to a consensus [ or receive a decree, presumably by you :)
> but after we have a chance to make our case ] on what things are going to
> be un/acceptable.

I already stood up and publically said this last year at Plumbers, why
is anything now different?

And this patchset is proof of why it's not a good idea.  You really
didn't do anything with all of the namespace stuff, except change loop.
That's the only thing that cares, so, just do it there, like I said to
do so, last August.

And you are ignoring the notifications to userspace and how namespaces
here would deal with that.

> > > Serge mentioned something to me about a loopdevfs (?) thing that someone
> > > else is working on.  That would seem to be a better solution in this
> > > particular case but I don't know much about it or where it's at.
> > 
> > Ok, let's see those patches then.
> 
> I think Seth has a git tree ready, but not sure which branch he'd want
> us to look at.
> 
> Splitting a namespaced devtmpfs from loopdevfs discussion might be
> sensible.  However, in defense of a namespaced devtmpfs I'd say
> that for userspace to, at every container startup, bind-mount in
> devices from the global devtmpfs into a private tmpfs (for systemd's
> sake it can't just be on the container rootfs), seems like something
> worth avoiding.

I think having to pick and choose what device nodes you want in a
container is a good thing.  Becides, you would have to do the same thing
in the kernel anyway, what's wrong with userspace making the decision
here, especially as it knows exactly what it wants to do much more so
than the kernel ever can.

> PS - Apparently both parallels and Michael independently
> project devices which are hot-plugged on the host into containers.
> That also seems like something worth talking about (best practices,
> shortcomings, use cases not met by it, any ways tha the kernel can
> help out) at ksummit/linuxcon.

I was told that containers would never want devices hotplugged into
them.  What use case has this happening / needed?

thanks,

greg k-h
