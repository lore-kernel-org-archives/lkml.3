Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530AbaEPEff (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 00:35:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42475 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbaEPEfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 00:35:34 -0400
Date: Thu, 15 May 2014 21:35:32 -0700
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
Message-ID: <20140516043532.GA14149@kroah.com>
References: <1400103299-144589-1-git-send-email-seth.forshee@canonical.com>
 <20140515013245.GA1764@kroah.com>
 <1400120251.7699.11.camel@canyon.ip6.wittsend.com>
 <20140515031527.GA146352@ubuntu-hedt>
 <20140515040032.GA6702@kroah.com>
 <1400161337.7699.33.camel@canyon.ip6.wittsend.com>
 <20140515140856.GA17453@kroah.com>
 <20140515174254.GM21073@ubuntumail>
 <20140515221551.GB13306@kroah.com>
 <20140516014959.GD22591@ubuntumail>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140516014959.GD22591@ubuntumail>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 01:49:59AM +0000, Serge Hallyn wrote:
> > I think having to pick and choose what device nodes you want in a
> > container is a good thing.  Becides, you would have to do the same thing
> > in the kernel anyway, what's wrong with userspace making the decision
> > here, especially as it knows exactly what it wants to do much more so
> > than the kernel ever can.
> 
> For 'real' devices that sounds sensible.  The thing about loop devices
> is that we simply want to allow a container to say "give me a loop
> device to use" and have it receive a unique loop device (or 3), without
> having to pre-assign them.  I think that would be cleaner to do using
> a pseudofs and loop-control device, rather than having to have a
> daemon in userspace on the host farming those out in response to
> some, I don't know, dbus request?

I agree that loop devices would be nice to have in a container, and that
the existing loop interface doesn't really lend itself to that.  So
create a new type of thing that acts like a loop device in a container.
But don't try to mess with the whole driver core just for a single type
of device.

greg k-h
