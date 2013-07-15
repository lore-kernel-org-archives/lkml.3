Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872Ab3GOSt6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 14:49:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42160 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754782Ab3GOSt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 14:49:56 -0400
Date: Mon, 15 Jul 2013 14:49:40 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Tejun Heo <tj@kernel.org>, Tim Hockin <thockin@hockin.org>,
        Mike Galbraith <bitbucket@online.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>, lpoetter <lpoetter@redhat.com>,
        workman-devel <workman-devel@redhat.com>,
        "dhaval.giani" <dhaval.giani@gmail.com>,
        Cgroups <cgroups@vger.kernel.org>, bsingharora <bsingharora@gmail.com>
Subject: Re: [Workman-devel] cgroup: status-quo and userland efforts
Message-ID: <20130715184940.GG27338@redhat.com>
References: <20130626212047.GB4536@htj.dyndns.org>
 <1372311907.5871.78.camel@marge.simpson.net>
 <20130627180143.GD5599@mtj.dyndns.org>
 <1372391198.5989.110.camel@marge.simpson.net>
 <20130628040930.GC2500@htj.dyndns.org>
 <1372394950.5989.128.camel@marge.simpson.net>
 <20130628050138.GD2500@htj.dyndns.org>
 <20130628150513.GD5125@dhcp22.suse.cz>
 <20130628180155.GD16483@redhat.com>
 <20130630183838.GB23731@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130630183838.GB23731@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 30, 2013 at 08:38:38PM +0200, Michal Hocko wrote:
> On Fri 28-06-13 14:01:55, Vivek Goyal wrote:
> > On Fri, Jun 28, 2013 at 05:05:13PM +0200, Michal Hocko wrote:
> [...]
> > > OK, so libcgroup's rules daemon will still work and place my tasks in
> > > appropriate cgroups?
> > 
> > Do you use that daemon in practice?
> 
> I am not but my users do. And that is why I care.

Michael, 

would you have more details of how those users are exactly using
rules engine daemon.

To me rulesengined processed 3 kinds of rules.

- uid based
- gid based
- exec file path based

uid/gid based rule exection can be taken care by pam_cgroup module too.
So I think one should not need cgrulesengined for that.

I am curious what kind of exec rules are useful. Any placement of
services one can do using systemd. So only executables we are left
to manage are which are not services. 

In practice is it very useful for an admin to say if "firefox" is launched
by a user then it should run in xyz cgroup. And if user cares about
firefox running in a sub cgroup, then it can always use cgexec to do
that.

Thanks
Vivek
