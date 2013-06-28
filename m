Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247Ab3F1T7i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 15:59:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52295 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752201Ab3F1T7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 15:59:36 -0400
Date: Fri, 28 Jun 2013 20:59:17 +0100
From: "Daniel P. Berrange" <berrange@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>, Tim Hockin <thockin@hockin.org>,
        Mike Galbraith <bitbucket@online.de>,
        Containers <containers@lists.linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        lpoetter <lpoetter@redhat.com>,
        "dhaval.giani" <dhaval.giani@gmail.com>, Tejun Heo <tj@kernel.org>,
        Cgroups <cgroups@vger.kernel.org>,
        workman-devel <workman-devel@redhat.com>
Subject: Re: [Workman-devel] cgroup: status-quo and userland efforts
Message-ID: <20130628195917.GG2507@redhat.com>
Reply-To: "Daniel P. Berrange" <berrange@redhat.com>
References: <CAAAKZwt09k-qUwLCnMpAQeYJ-S0XtkjXe4=bJ-G_fcrkAqEzoA@mail.gmail.com>
 <20130626212047.GB4536@htj.dyndns.org>
 <1372311907.5871.78.camel@marge.simpson.net>
 <20130627180143.GD5599@mtj.dyndns.org>
 <1372391198.5989.110.camel@marge.simpson.net>
 <20130628040930.GC2500@htj.dyndns.org>
 <1372394950.5989.128.camel@marge.simpson.net>
 <20130628050138.GD2500@htj.dyndns.org>
 <20130628150513.GD5125@dhcp22.suse.cz>
 <20130628180155.GD16483@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130628180155.GD16483@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 02:01:55PM -0400, Vivek Goyal wrote:
> On Fri, Jun 28, 2013 at 05:05:13PM +0200, Michal Hocko wrote:
> > On Thu 27-06-13 22:01:38, Tejun Heo wrote:
> > > Hello, Mike.
> > > 
> > > On Fri, Jun 28, 2013 at 06:49:10AM +0200, Mike Galbraith wrote:
> > > > I always thought that was a very cool feature, mkdir+echo, poof done.
> > > > Now maybe that interface is suboptimal for serious usage, but it makes
> > > > the things usable via dirt simple scripts, very flexible, nice.
> > > 
> > > Oh, that in itself is not bad.  I mean, if you're root, it's pretty
> > > easy to play with and that part is fine.  But combined with the
> > > hierarchical nature of cgroup and file permissions, it encourages
> > > people to "deligate" subdirectories to less previledged domains,
> > 
> > OK, this really depends on what you expose to non-root users. I have
> > seen use cases where admin prepares top-level which is root-only but
> > it allows creating sub-groups which are under _full_ control of the
> > subdomain. This worked nicely for memcg for example because hard limit,
> > oom handling and other knobs are hierarchical so the subdomain cannot
> > overwrite what admin has said.
> > 
> > > which
> > > in turn leads to normal binaries to manipulate them directly, which is
> > > where the horror begins.  We end up exposing control knobs which are
> > > tightly coupled to kernel implementation details right into lay
> > > binaries and scripts directly used by end users.
> > >
> > > I think this is the first time this happened, which is probably why
> > > nobody really noticed the mess earlier.
> > > 
> > > Anyways, if you're root, you can keep doing whatever you want.
> > 
> > OK, so libcgroup's rules daemon will still work and place my tasks in
> > appropriate cgroups?
> 
> Do you use that daemon in practice? For user session logins, I think
> systemd has plans to put user sessions in a cgroup (kind of making
> pam_cgroup redundant). 
> 
> Other functionality rulesengined was providing moving tasks automatically
> in a cgroup based on executable name. I think that was racy and not
> many people had liked it.

Regardless of the changes being proposed, IMHO, the cgrulesd should
never be used. It is just outright dangerous for a daemon to be
arbitrarily re-arranging what cgroups a process is placed in without
the applications being aware of it. It can only be safely used in a
scenario where cgroups are exclusively used by the administrator,
and never used by applications for their own needs.

> IIUC, systemd can't disable access to cgroupfs from other utilities.

The kernel can exposed a knob that would allow systemd to lock that
down

> So most likely rulesengined should contine to work. But having both
> systemd and libcgroup might not make much sense though.

Daniel
-- 
|: http://berrange.com      -o-    http://www.flickr.com/photos/dberrange/ :|
|: http://libvirt.org              -o-             http://virt-manager.org :|
|: http://autobuild.org       -o-         http://search.cpan.org/~danberr/ :|
|: http://entangle-photo.org       -o-       http://live.gnome.org/gtk-vnc :|
