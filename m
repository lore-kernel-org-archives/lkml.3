Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047Ab3F1JJa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 05:09:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23308 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754975Ab3F1JJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 05:09:25 -0400
Date: Fri, 28 Jun 2013 10:09:10 +0100
From: "Daniel P. Berrange" <berrange@redhat.com>
To: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: Mike Galbraith <bitbucket@online.de>, Tim Hockin <thockin@hockin.org>,
        Containers <containers@lists.linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        lpoetter <lpoetter@redhat.com>, Cgroups <cgroups@vger.kernel.org>,
        "dhaval.giani" <dhaval.giani@gmail.com>,
        workman-devel <workman-devel@redhat.com>
Subject: Re: [Workman-devel] cgroup: status-quo and userland efforts
Message-ID: <20130628090910.GB2507@redhat.com>
Reply-To: "Daniel P. Berrange" <berrange@redhat.com>
References: <20130406012159.GA17159@mtj.dyndns.org>
 <CAAAKZwvh_R2Xz--bmSLiN33fsqKanOJMq_6+6hoFWFRx38O4gA@mail.gmail.com>
 <20130422214159.GG12543@htj.dyndns.org>
 <CAAAKZwuXJwwyj7KSqb7rZ+nrTwBWEaUCWfa7kWecTBnHL8koGw@mail.gmail.com>
 <CAAAKZwvP_7wBBYMmtFuiE2hZt=ByaLrnTyiR83CZr3OMip63Gg@mail.gmail.com>
 <20130625000118.GT1918@mtj.dyndns.org>
 <CAAAKZwt09k-qUwLCnMpAQeYJ-S0XtkjXe4=bJ-G_fcrkAqEzoA@mail.gmail.com>
 <20130626212047.GB4536@htj.dyndns.org>
 <1372311907.5871.78.camel@marge.simpson.net>
 <20130627132206.GE4003@sergelap>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130627132206.GE4003@sergelap>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 08:22:06AM -0500, Serge Hallyn wrote:
> FWIW, the code is too embarassing yet to see daylight, but I'm playing
> with a very lowlevel cgroup manager which supports nesting itself.
> Access in this POC is low-level ("set freezer.state to THAWED for cgroup
> /c1/c2", "Create /c3"), but the key feature is that it can run in two
> modes - native mode in which it uses cgroupfs, and child mode where it
> talks to a parent manager to make the changes.
> 
> So then the idea would be that userspace (like libvirt and lxc) would
> talk over /dev/cgroup to its manager.  Userspace inside a container
> (which can't actually mount cgroups itself) would talk to its own
> manager which is talking over a passed-in socket to the host manager,
> which in turn runs natively (uses cgroupfs, and nests "create /c1" under
> the requestor's cgroup).
> 
> At some point (probably soon) we might want to talk about a standard API
> for these things.  However I think it will have to come in the form of
> a standard library, which knows to either send requests over dbus to
> systemd, or over /dev/cgroup sock to the manager.

Are you also planning to actually write a new cgroup parent manager
daemon too ? Currently my plan for libvirt is to just talk directly
to systemd's new DBus APIs for all management of cgroups, and then
fall back to writing to cgroupfs directly for cases where systemd
is not around.  Having a library to abstract these two possible
alternatives isn't all that compelling unless we think there will
be multiple cgroups manager daemons. I've been somewhat assuming that
even Ubuntu will eventually see the benefits & switch to systemd,
then the issue of multiple manager daemons wouldn't really exist.

Daniel
-- 
|: http://berrange.com      -o-    http://www.flickr.com/photos/dberrange/ :|
|: http://libvirt.org              -o-             http://virt-manager.org :|
|: http://autobuild.org       -o-         http://search.cpan.org/~danberr/ :|
|: http://entangle-photo.org       -o-       http://live.gnome.org/gtk-vnc :|
