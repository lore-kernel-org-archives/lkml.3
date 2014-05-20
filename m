Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbaETOSg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 10:18:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41562 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771AbaETOSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 10:18:34 -0400
Date: Tue, 20 May 2014 14:18:30 +0000
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: LXC development mailing-list <lxc-devel@lists.linuxcontainers.org>
Cc: Jens Axboe <axboe@kernel.dk>, Serge Hallyn <serge.hallyn@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [lxc-devel] [RFC PATCH 00/11] Add support for devtmpfs in user
 namespaces
Message-ID: <20140520141830.GG26600@ubuntumail>
References: <20140515174254.GM21073@ubuntumail>
 <20140515221551.GB13306@kroah.com>
 <20140516014959.GD22591@ubuntumail>
 <20140516043532.GA14149@kroah.com>
 <20140516140607.GA23902@ubuntu-hedt>
 <20140516185749.GA5131@kroah.com>
 <1400268515.2221.91.camel@dabdike.int.hansenpartnership.com>
 <20140516201841.GC23902@ubuntu-hedt>
 <87mwedfh7c.fsf@x220.int.ebiederm.org>
 <1400548481.3540.247.camel@canyon.ip6.wittsend.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400548481.3540.247.camel@canyon.ip6.wittsend.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Michael H. Warfield (mhw@WittsEnd.com):
> On Mon, 2014-05-19 at 17:04 -0700, Eric W. Biederman wrote:
> > Seth Forshee <seth.forshee@canonical.com> writes:
> > 
> > > What I set out for was feature parity between loop devices in a secure
> > > container and loop devices on the host. Since some operations currently
> > > check for system-wide CAP_SYS_ADMIN, the only way I see to accomplish
> > > this is to push knowledge of the user namespace farther down into the
> > > driver stack so the check can instead be for CAP_SYS_ADMIN in the user
> > > namespace associated with the device.
> > >
> > > That said, I suspect our current use cases can get by without these
> > > capabilities. Really though I suspect this is just deferring the
> > > discussion rather than settling it, and what we'll end up with is little
> > > more than a fancy way for userspace to ask the kernel to run mknod on
> > > its behalf.
> 
> > A fancy way to ask the kernel to run mknod on its behalf is what
> > /dev/pts is.
> 
> > When I suggested this I did not mean you should forgo making changes to
> > allow partitions and the like.  What I itended is that you should find a
> > way to make this safe for users who don't have root capabilities.
> 
> I like to think in terms of the "rootless" configurations where "root"
> per se is not absolute and everything is framed in terms of
> capabilities.
> 
> > Which possibly means that mount needs to learn how to keep a more
> > privileged user from using your new loop devices.
> 
> Not sure I got that one.  As user with "more" privileges may or may not
> have access dependent on the congruence of the privileges.  They're not

Yes so in this case by more privileged' he meant a privileged user in a
userns which is ancestor to the current userns.  It is in fact *more*
privileged than any user in the current userns.

> heiarchial.  If someone has that "priv" then they have access.  If they

They are in fact implicitly hierarchical due to the hierarchical userns
design.

> do not, they do not.
> 
> > To get to the point where this is really and truly usable I expect to be
> > technically daunting.
> 
> Most technically non-trivial problems generally are.
> 
> > Ultimately the technical challenge is how do we create a block device
> > that is safe for a user who does not have any capabilities to use, and
> > what can we do with that block device to make it useful.
> 
> Concur.  It boils down to privilege management and access.  Absolutely
> concur.
> 
> > Only when the question is can this kernel functionality which is
> > otherwise safe confuse a preexisting setuid application do namespace
> > or container bits significantly come into play.
> 
> Ah...  Admittedly it's not as late as our conversation at LinuxPlumbers
> last year in NOLA but...  Maybe late at night but I failed to parse the
> above.
> 
> > Eric
> 
> Regards,
> Mike
> -- 
> Michael H. Warfield (AI4NB) | (770) 978-7061 |  mhw@WittsEnd.com
>    /\/\|=mhw=|\/\/          | (678) 463-0932 |  http://www.wittsend.com/mhw/
>    NIC whois: MHW9          | An optimist believes we live in the best of all
>  PGP Key: 0x674627FF        | possible worlds.  A pessimist is sure of it!
> 



> _______________________________________________
> lxc-devel mailing list
> lxc-devel@lists.linuxcontainers.org
> http://lists.linuxcontainers.org/listinfo/lxc-devel

