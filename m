Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164AbaA2GIY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 01:08:24 -0500
Received: from cobra.newdream.net ([66.33.216.30]:52624 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbaA2GIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 01:08:22 -0500
Date: Tue, 28 Jan 2014 22:08:22 -0800 (PST)
From: Sage Weil <sage@inktank.com>
X-X-Sender: sage@cobra.newdream.net
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ceph-devel@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Guangliang Zhao <lucienchao@gmail.com>,
        Li Wang <li.wang@ubuntykylin.com>, zheng.z.yan@intel.com
Subject: Re: [GIT PULL] Ceph updates for -rc1
In-Reply-To: <CA+55aFxmQZ+sAC+_a=QXUSVQ1e=cSVkeZVL4d8kawFp9N5eS-w@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1401282145410.17720@cobra.newdream.net>
References: <alpine.DEB.2.00.1401281032560.16427@cobra.newdream.net> <20140128211021.GB1377@redhat.com> <CA+55aFxmQZ+sAC+_a=QXUSVQ1e=cSVkeZVL4d8kawFp9N5eS-w@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Tue, 28 Jan 2014, Linus Torvalds wrote:
> On Tue, Jan 28, 2014 at 1:10 PM, Dave Jones <davej@redhat.com> wrote:
> >
> > This breaks the build for me.
> 
> It is my merge (Christoph's ACL changes came in today through the VFS
> tree from Al).
> 
> I was doing the merges today on my laptop (I had jury duty yesterday
> and today), and so I didn't do the allmodconfig build I would normally
> do on my (much faster) desktop. Well, actually I did do the full fs
> builds for the earlier pulls that actually had some conflicts, but not
> for the ceph pull. The conflict was hidden by the fact that the whole
> cifs ACL support is new, so there was no data conflict, just a silent
> semantic conflict between the new smarter ACL helpers and the new ACL
> use in CIFS.

s/cifs/ceph/ :)

> I'm back home now (yay, all the afternoon cases got settled), and I
> see the problem now. I should have done an allmodconfig build
> immediately after coming home, but I never even thought of it.
>
> Anyway, here's an *untested* conversion to the new posix acl helper
> infrastructure. I do wonder if ceph_init_acl() could be converted to
> posix_acl_create(), right now that part is a "non-conversion" - it's
> just made to use __posix_acl_create() that implements the old
> interface.
> 
> Al, Christoph, can you please check my conversion for sanity from a
> generic posix-acl standpoint?
> 
> Sage, Guangliang, Li, can you check the actual cifs usage/sanity of
> the attached patch?

Superficially at least the conversion looks okay to me, but it's not 
passing my smoke test (it's giving me EOPNOTSUPP for chmod and setxattr 
when setting an ACL).  I'll look at it tomorrow if Guangliang, Li, or Yan 
don't get there first.

I should have caught this before--I knew the ACL changes were coming and 
forgot to check the merged build beforehand!

sage
