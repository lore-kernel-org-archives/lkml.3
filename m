Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933523AbaFSPIm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 11:08:42 -0400
Received: from ozlabs.org ([103.22.144.67]:57388 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932978AbaFSPIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 11:08:40 -0400
Date: Fri, 20 Jun 2014 01:08:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Moore <paul@paul-moore.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: the selinux tree needs cleaning up
Message-ID: <20140620010837.692e5472@canb.auug.org.au>
In-Reply-To: <1446656.4HCLD295vV@sifl>
References: <20140618084046.1bce12cc@canb.auug.org.au>
	<1446656.4HCLD295vV@sifl>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Wed, 18 Jun 2014 14:26:27 -0400 Paul Moore <paul@paul-moore.com> wrote:
>
> On Wednesday, June 18, 2014 08:40:46 AM Stephen Rothwell wrote:
> > 
> > The selinux tree (git://git.infradead.org/users/pcmoore/selinux#next)
> > contains some commits going back to January and also has merges of
> > v3.13, v3.14 and v3.15 in it.  If you rebase that tree onto v3.16-rc1,
> > you find that it has onlt 2 unique commits (the most recent 2) which
> > means that the others were merged upstream after being rewritten.  :-(
> 
> Without going through each of the differences between the SELinux tree and 
> what is in Linus' tree in this email, I can assure you there is nothing 
> nefarious going on here, just some differences in tree management between 
> James' Linux Security tree and the SELinux tree which resulted in some 
> backports and other mess.  The good news is that James' and the rest of us 
> under the Linux Security tree have now established a protocol moving forward 
> which should avoid these nasties.

Sounds good.  I usually assume that these issues are misunderstandings
or oversights.

> So, back to your concerns - what do you want to see in linux-next?  My 
> practice for the SELinux #next branch has been to apply patches on top of the 
> latest "major" release from Linus, e.g. 3.15, and when a new major release is 
> made I merge it into #next and restart the process.  I generally send James' a 
> pull request in the -rc6/7 timeframe using the #next branch.  While this has 
> resulted in some ugliness (see above comments) it keeps the SELinux #next 
> branch steady so others can pull from it without major problems.
> 
> Does this approach not work for you and linux-next?

OK, you should probably base your tree on -rc1 or 2, that way all your
stuff for the previous merge window is upstream and you don't need to
worry about it any more.

As for your current tree, it contains the following commits:

(1) 5c7001b84be5 SELinux: use ARRAY_SIZE
(2) aa65506f198c selinux, kbuild: remove unnecessary $(hostprogs-y) from clean-files
    170b5910d9fb Merge tag 'v3.15' into next
(3) 47dd0b76ace9 selinux: conditionally reschedule in hashtab_insert while loading selinux policy
(4) 612c353178c4 selinux: conditionally reschedule in mls_convert_context while loading selinux policy
(5) 4f189988a0a5 selinux: reject setexeccon() on MNT_NOSUID applications with -EACCES
(6) 626b9740fa73 selinux:  Report permissive mode in avc: denied messages.
    6d32c850621b Merge tag 'v3.14' into next
(7) eee3094683fb selinux: correctly label /proc inodes in use before the policy is loaded
(8) 0909c0ae999c selinux: put the mmap() DAC controls before the MAC controls
(9) 81c94e76ce8e selinux: fix the output of ./scripts/get_maintainer.pl for SELinux
    41be702a542a Merge tag 'v3.13' into next

1 and 2 are new
3 is in Linus' tree as commit ed1c96429a6a
4                             9a591f39a9d1
5                             5b589d44fad1
6                             ca7786a2f916
7                             f64410ec6654
8 and 9 are subsumed by something in Linus' tree.

So every time I merge your tree into linux-next I get duplicates (whcih
can cause conflicts if there are other changes to the same areas of the
the files effected).  Also, if James really merged you tree (i.e. with
a "git pull" or "git fetch; get merge") then we would end up with
duplicates in his tree (and then Linus' tree).

I can see that part of the problem this time round is that Serge
cherry-picked (or rebased) your commits 3-6 above onto James' tree
before asking Linus to pull.

So, the easiest way for you to clean up from this is to now rebase onto
v3.16-rc1 (which will leave you with just commits 1 and 2) and then
ensure that in the future James (or whoever is handling the security
tree) pulls your tree (and doesn't cherry-pick the patches).  Then
after that has happened, you can fast forward your tree onto that
upstream tree, or wait until the next -rc1 and fast forward to that.

I hope that is sort of clear and makes some sense?

(As an aside, if you do a git pull on a tag, it will create a merge
commit even if it doesn't need to, so for example doing "git merge <tag
from Linus' tree after your commits are merged upstream>" will create a
merge rather than just fast forwarding.)

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
