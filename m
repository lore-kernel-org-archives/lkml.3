Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023AbaERCpA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 22:45:00 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:56543
	"EHLO mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbaERCo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 22:44:59 -0400
Date: Sun, 18 May 2014 04:44:58 +0200
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Michael H. Warfield" <mhw@WittsEnd.com>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        lxc-devel@lists.linuxcontainers.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [lxc-devel] [RFC PATCH 00/11] Add support for devtmpfs in user
 namespaces
Message-ID: <20140518024458.GB25613@mail.hallyn.com>
References: <20140515031527.GA146352@ubuntu-hedt>
 <20140515040032.GA6702@kroah.com>
 <1400161337.7699.33.camel@canyon.ip6.wittsend.com>
 <20140515140856.GA17453@kroah.com>
 <20140515174254.GM21073@ubuntumail>
 <20140515221551.GB13306@kroah.com>
 <20140516014959.GD22591@ubuntumail>
 <20140516043532.GA14149@kroah.com>
 <87mwehgh5i.fsf@x220.int.ebiederm.org>
 <20140517160145.GA44802@ubuntu-hedt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140517160145.GA44802@ubuntu-hedt>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Seth Forshee (seth.forshee@canonical.com):
> On Fri, May 16, 2014 at 09:31:37PM -0700, Eric W. Biederman wrote:
> > Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> > 
> > > On Fri, May 16, 2014 at 01:49:59AM +0000, Serge Hallyn wrote:
> > >> > I think having to pick and choose what device nodes you want in a
> > >> > container is a good thing.  Becides, you would have to do the same thing
> > >> > in the kernel anyway, what's wrong with userspace making the decision
> > >> > here, especially as it knows exactly what it wants to do much more so
> > >> > than the kernel ever can.
> > >> 
> > >> For 'real' devices that sounds sensible.  The thing about loop devices
> > >> is that we simply want to allow a container to say "give me a loop
> > >> device to use" and have it receive a unique loop device (or 3), without
> > >> having to pre-assign them.  I think that would be cleaner to do using
> > >> a pseudofs and loop-control device, rather than having to have a
> > >> daemon in userspace on the host farming those out in response to
> > >> some, I don't know, dbus request?
> > >
> > > I agree that loop devices would be nice to have in a container, and that
> > > the existing loop interface doesn't really lend itself to that.  So
> > > create a new type of thing that acts like a loop device in a container.
> > > But don't try to mess with the whole driver core just for a single type
> > > of device.
> > 
> > Yes. Something like devpts (without the newinstance option).  Built to
> > allow unprivileged users to create loopback devices.
> 
> That's where I started, and I've got code, so I guess I'll clean it up
> and send patches. If the stance is that only system-wide CAP_SYS_ADMIN
> gets to do privileged block device ioctls, including reading partitions

Sorry, where did that come from?  What Eric was referring to below is
the fs superblock readers not being trusted.  Maybe I glossed over another
email where it was mentioned?

> on a block device which has been assigned to a contiainer, then I guess
> that approach works well enough.
> 
> > There is still a huge kettle of fish in with verifying a filesystem is
> > safe from a hostile user that has acess to the block device while the
> > filesystem is mounted.
> > 
> > Having a few filesystems that are robust enough to trust with arbitrary
> > filesystem corruption would be very interesting.
> > 
> > I assume unprivileged and hostile users because if you trusted the real
> > root inside of your container this would not be an issue.
> > 
> > Eric
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
