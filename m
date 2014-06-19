Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985AbaFSTrM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 15:47:12 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:57555 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858AbaFSTrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 15:47:10 -0400
From: Paul Moore <paul@paul-moore.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: the selinux tree needs cleaning up
Date: Thu, 19 Jun 2014 15:47:01 -0400
Message-ID: <3494783.s5KPIUO972@sifl>
User-Agent: KMail/4.13.2 (Linux/3.14.8-gentoo; KDE/4.13.2; x86_64; ; )
In-Reply-To: <20140620010837.692e5472@canb.auug.org.au>
References: <20140618084046.1bce12cc@canb.auug.org.au> <1446656.4HCLD295vV@sifl> <20140620010837.692e5472@canb.auug.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 20, 2014 01:08:37 AM Stephen Rothwell wrote:
> Hi Paul,

Howdy.

> On Wed, 18 Jun 2014 14:26:27 -0400 Paul Moore <paul@paul-moore.com> wrote:
> > On Wednesday, June 18, 2014 08:40:46 AM Stephen Rothwell wrote:

I'm going to chop up your email a bit so it makes more sense when replying, my 
apologies if I make things worse.

> As for your current tree, it contains the following commits:
> 
> (1) 5c7001b84be5 SELinux: use ARRAY_SIZE
> (2) aa65506f198c selinux, kbuild: remove unnecessary $(hostprogs-y) from
> clean-files 170b5910d9fb Merge tag 'v3.15' into next
> (3) 47dd0b76ace9 selinux: conditionally reschedule in hashtab_insert while
> loading selinux policy (4) 612c353178c4 selinux: conditionally reschedule
> in mls_convert_context while loading selinux policy (5) 4f189988a0a5
> selinux: reject setexeccon() on MNT_NOSUID applications with -EACCES (6)
> 626b9740fa73 selinux:  Report permissive mode in avc: denied messages.
> 6d32c850621b Merge tag 'v3.14' into next
> (7) eee3094683fb selinux: correctly label /proc inodes in use before the
> policy is loaded (8) 0909c0ae999c selinux: put the mmap() DAC controls
> before the MAC controls (9) 81c94e76ce8e selinux: fix the output of
> ./scripts/get_maintainer.pl for SELinux 41be702a542a Merge tag 'v3.13' into
> next
> 
> 1 and 2 are new

Yes, these are the "new" SELinux patches that should be in linux-next.

> 3 is in Linus' tree as commit ed1c96429a6a
> 4                             9a591f39a9d1
> 5                             5b589d44fad1
> 6                             ca7786a2f916
> 7                             f64410ec6654
> 8 and 9 are subsumed by something in Linus' tree.

These are likely caused by the problems we talked about earlier.

> > So, back to your concerns - what do you want to see in linux-next?  My
> > practice for the SELinux #next branch has been to apply patches on top of
> > the latest "major" release from Linus, e.g. 3.15, and when a new major
> > release is made I merge it into #next and restart the process.  I
> > generally send James' a pull request in the -rc6/7 timeframe using the
> > #next branch.  While this has resulted in some ugliness (see above
> > comments) it keeps the SELinux #next branch steady so others can pull
> > from it without major problems.
> > 
> > Does this approach not work for you and linux-next?
> 
> OK, you should probably base your tree on -rc1 or 2, that way all your
> stuff for the previous merge window is upstream and you don't need to
> worry about it any more.

...

> So, the easiest way for you to clean up from this is to now rebase onto
> v3.16-rc1 (which will leave you with just commits 1 and 2) and then
> ensure that in the future James (or whoever is handling the security
> tree) pulls your tree (and doesn't cherry-pick the patches).  Then
> after that has happened, you can fast forward your tree onto that
> upstream tree, or wait until the next -rc1 and fast forward to that.

I want to avoid use a -rcX release as the foundation of any of my trees; the -
rc releases aren't as stable and it goes against what we're trying to do with 
the different Linux Security trees.  Unfortunately, based on what I've read 
above, this seems to be incompatible with linux-next.

While I hate to split my development branch from the #next branch, it seems 
like that is the only way to accomplish both a reasonably current and stable 
development tree and get the patches into linux-next.  Unless you, or anyone 
else for that matter, has a different suggestion I'm going to go ahead and 
turn the current SELinux #next branch into a development branch and create a 
new #next branch that will be based on the most current -rc1, this new #next 
branch will be created new for each major release.  Not exactly what I was 
hoping for, but will that work?

-- 
paul moore
www.paul-moore.com

