Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757730Ab3GWOsW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 10:48:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43668 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757546Ab3GWOsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 10:48:20 -0400
Date: Tue, 23 Jul 2013 16:48:16 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Tim Hockin <thockin@hockin.org>,
        Mike Galbraith <bitbucket@online.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>, lpoetter <lpoetter@redhat.com>,
        workman-devel <workman-devel@redhat.com>,
        "dhaval.giani" <dhaval.giani@gmail.com>,
        Cgroups <cgroups@vger.kernel.org>, bsingharora <bsingharora@gmail.com>
Subject: Re: [Workman-devel] cgroup: status-quo and userland efforts
Message-ID: <20130723144816.GK8677@dhcp22.suse.cz>
References: <1372311907.5871.78.camel@marge.simpson.net>
 <20130627180143.GD5599@mtj.dyndns.org>
 <1372391198.5989.110.camel@marge.simpson.net>
 <20130628040930.GC2500@htj.dyndns.org>
 <1372394950.5989.128.camel@marge.simpson.net>
 <20130628050138.GD2500@htj.dyndns.org>
 <20130628150513.GD5125@dhcp22.suse.cz>
 <20130628180155.GD16483@redhat.com>
 <20130630183838.GB23731@dhcp22.suse.cz>
 <20130715184940.GG27338@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130715184940.GG27338@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 15-07-13 14:49:40, Vivek Goyal wrote:
> On Sun, Jun 30, 2013 at 08:38:38PM +0200, Michal Hocko wrote:
> > On Fri 28-06-13 14:01:55, Vivek Goyal wrote:
> > > On Fri, Jun 28, 2013 at 05:05:13PM +0200, Michal Hocko wrote:
> > [...]
> > > > OK, so libcgroup's rules daemon will still work and place my tasks in
> > > > appropriate cgroups?
> > > 
> > > Do you use that daemon in practice?
> > 
> > I am not but my users do. And that is why I care.
> 
> Michael, 
> 
> would you have more details of how those users are exactly using
> rules engine daemon.

The most common usage is uid and exec names.

> To me rulesengined processed 3 kinds of rules.
> 
> - uid based
> - gid based
> - exec file path based
> 
> uid/gid based rule exection can be taken care by pam_cgroup module too.
> So I think one should not need cgrulesengined for that.

I am not familiar with pam_cgroup much but it is a part of libcgroup
package, right?

> I am curious what kind of exec rules are useful. Any placement of
> services one can do using systemd. So only executables we are left
> to manage are which are not services. 

Yes, those are usually backup processes which should not disrupt the
regular server workload.

uid ones are used to keep a leash on local users of the machine but i do
not have many details as I usually do not have access to those machines.
All I see are complains when something explodes ;)
-- 
Michal Hocko
SUSE Labs
