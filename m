Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916Ab3F0SBx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 14:01:53 -0400
Received: from mail-gh0-f169.google.com ([209.85.160.169]:55231 "EHLO
	mail-gh0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753714Ab3F0SBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 14:01:52 -0400
Date: Thu, 27 Jun 2013 11:01:43 -0700
From: Tejun Heo <tj@kernel.org>
To: Mike Galbraith <bitbucket@online.de>
Cc: Tim Hockin <thockin@hockin.org>, Li Zefan <lizefan@huawei.com>,
        Containers <containers@lists.linux-foundation.org>,
        Cgroups <cgroups@vger.kernel.org>, bsingharora <bsingharora@gmail.com>,
        "dhaval.giani" <dhaval.giani@gmail.com>,
        Kay Sievers <kay.sievers@vrfy.org>, jpoimboe <jpoimboe@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        lpoetter <lpoetter@redhat.com>,
        workman-devel <workman-devel@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: cgroup: status-quo and userland efforts
Message-ID: <20130627180143.GD5599@mtj.dyndns.org>
References: <20130406012159.GA17159@mtj.dyndns.org>
 <CAAAKZwvh_R2Xz--bmSLiN33fsqKanOJMq_6+6hoFWFRx38O4gA@mail.gmail.com>
 <20130422214159.GG12543@htj.dyndns.org>
 <CAAAKZwuXJwwyj7KSqb7rZ+nrTwBWEaUCWfa7kWecTBnHL8koGw@mail.gmail.com>
 <CAAAKZwvP_7wBBYMmtFuiE2hZt=ByaLrnTyiR83CZr3OMip63Gg@mail.gmail.com>
 <20130625000118.GT1918@mtj.dyndns.org>
 <CAAAKZwt09k-qUwLCnMpAQeYJ-S0XtkjXe4=bJ-G_fcrkAqEzoA@mail.gmail.com>
 <20130626212047.GB4536@htj.dyndns.org>
 <1372311907.5871.78.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372311907.5871.78.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Mike.

On Thu, Jun 27, 2013 at 07:45:07AM +0200, Mike Galbraith wrote:
> I can understand some alarm.  When I saw the below I started frothing at
> the face and howling at the moon, and I don't even use the things much.

Can I ask why?  The reasons are not apparent to me.

> http://lists.freedesktop.org/archives/systemd-devel/2013-June/011521.html
> 
> Hierarchy layout aside, that "private property" bit says that the folks
> who currently own and use the cgroups interface will lose direct access
> to it.  I can imagine folks who have become dependent upon an on the fly
> management agents of their own design becoming a tad alarmed.

They're gonna be able to do what they've been doing for the
foreseeable future if they choose not to use systemd's unified
resource management.  That said, what we have today is pretty lousy
and a lot of hierarchical stuff were completely broken until some
releases ago and things *must* have been broken on the userland side
too.  It could have worked for their specific setup but I strongly
doubt there are anything generic working well out in the wild.  cgroup
hasn't been capable of supporting something like that.

AFAICS, having a userland agent which has overall knowledge of the
hierarchy and enforcesf structure and limiations is a requirement to
make cgroup generally useable and useful.  For systemd based systems,
systemd serving that role isn't too crazy.  It's sure gonna have
teeting issues at the beginning but it has all the necessary
information to manage workloads on the system.

A valid issue is interoperability between systemd and non-systemd
systems.  I don't have an immediately good answer for that.  I wrote
in another reply but making cgroup generally available is a pretty new
effort and we're still in the process of figuring out what the right
constructs and abstractions are.  Hopefully, we'll be able to reach a
common set of abstractions to base things on top in itme.

Thanks.

-- 
tejun
