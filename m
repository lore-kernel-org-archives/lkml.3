Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468AbaEPTUP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 15:20:15 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:46054 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932174AbaEPTUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 15:20:13 -0400
Message-ID: <1400268008.2221.84.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [lxc-devel] [RFC PATCH 00/11] Add support for devtmpfs in user
 namespaces
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: mhw@WittsEnd.com
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Serge Hallyn <serge.hallyn@ubuntu.com>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biederman <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        lxc-devel@lists.linuxcontainers.org
Date: Fri, 16 May 2014 12:20:08 -0700
In-Reply-To: <1400204545.7699.128.camel@canyon.ip6.wittsend.com>
References: <1400103299-144589-1-git-send-email-seth.forshee@canonical.com>
	 <20140515013245.GA1764@kroah.com>
	 <1400120251.7699.11.camel@canyon.ip6.wittsend.com>
	 <20140515031527.GA146352@ubuntu-hedt> <20140515040032.GA6702@kroah.com>
	 <1400161337.7699.33.camel@canyon.ip6.wittsend.com>
	 <20140515140856.GA17453@kroah.com> <20140515174254.GM21073@ubuntumail>
	 <20140515221551.GB13306@kroah.com>
	 <1400204545.7699.128.camel@canyon.ip6.wittsend.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.12.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-05-15 at 21:42 -0400, Michael H. Warfield wrote:
> On Thu, 2014-05-15 at 15:15 -0700, Greg Kroah-Hartman wrote:
> > > PS - Apparently both parallels and Michael independently
> > > project devices which are hot-plugged on the host into containers.
> > > That also seems like something worth talking about (best practices,
> > > shortcomings, use cases not met by it, any ways tha the kernel can
> > > help out) at ksummit/linuxcon.
> 
> > I was told that containers would never want devices hotplugged into
> > them.
> 
> Interesting.  You were told they (who they?) would never want them?  Who
> said that?  I would have never thought that given that other
> implementations can provide that.  I would certainly want them.  Seems
> strange to explicitly relegate LXC containers to being second class
> citizens behind OpenVZ, Parallels, BSD Gaols, and Solaris Zones.

That would probably be me.  Running hotplug inside a container is a
security problem and, since containers are easily entered by the host,
it's very easy to listen for the hotplug in the host and inject it into
the container using nsenter.

I don't think the intention is to label anyone's implementation as
preferred.  What this shows, I think, is that we all have different
practises when it comes to setting up containers.  Some are necessary
because our containers are different.  Some could do with serious
examination to see if there's really a best way to do the action which
we would then all use.

> I might believe you were never told they would need them, but that's a
> totally different sense.  Are we going to tell RedHat and the Docker
> people that LXC is an inferior technology that is complex and unreliable
> (to quote another poster) compared to these others?  They're saying this
> will be enterprise technology.  If I go to Amazon AWS or other VPS
> services and compare, are we not going to stand on a level playing
> field?  Admittedly, I don't expect Amazon AWS to provide me with serial
> consoles, but I do expect to be able to mount file system images within
> my VPS.

Well, that's another nasty, isn't it.  We all have different ways of
coping with mount in the container.  I think at plumbers we need to sit
down with some of this plumbing and work out which pipes carry the same
fluids and whether we could unify them.

As an aside (probably requiring a new thread) we were wondering about
some type of notifier on the mount call that we could vector into the
host to perform the action.  The main issue for us is mount of procfs,
which really needs to be a bind mount in a container.  All of this led
me to speculate that we could use some type of syscall notifier
mechanism to manage capabilities in the host and even intercept and
complete the syscall action within the host rather than having to keep
evolving more an more complex kernel drivers to do this.

James


