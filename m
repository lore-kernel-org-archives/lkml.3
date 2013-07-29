Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554Ab3G2Qdl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 12:33:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47272 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757007Ab3G2Qdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 12:33:40 -0400
Date: Mon, 29 Jul 2013 18:33:35 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Jonathan Corbet <corbet@lwn.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2013-discuss] [ATTEND] DT, maintainership, development
 process
In-Reply-To: <51F698DE.4010300@windriver.com>
Message-ID: <alpine.LNX.2.00.1307291832360.18809@pobox.suse.cz>
References: <20130729102452.GA2682@zurbaran> <alpine.LNX.2.00.1307291230270.18809@pobox.suse.cz> <7008541.g5m1pJPVp1@vostro.rjw.lan> <20130729081141.00818596@lwn.net> <51F698DE.4010300@windriver.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jul 2013, Paul Gortmaker wrote:

> >> That actually is simple enough.
> >>
> >> Check out the Linus' master branch and do
> >>
> >> $ git log --ancestry-path --merges <commit>..
> > 
> > So I picked a recent, single-signoff patch mostly at random:
> > 
> > 	8ade62857ef77bdf639185410fbcd811aa700cb2
> > 
> > That "git log" command gives me 156 intervening commits involving at least
> > a dozen networking trees, along with virtio, parisc, blackfin, x86, ...
> > Even if one stops looking at the first merge performed by Linus, that's 47
> > to look at.  Did that patch really pass through all those peoples' hands?
> 
> Try this:
> 
> $ git describe --contains 8ade62857ef77bdf6391
> v3.11-rc1~16^2~103^2^2~5^2~25
> 
> Looks scary, but lets deconstruct it right to left a chunk at
> a time v3.11-rc1 ~16 ^2 ~103 ^2 ^2 ~5 ^2 ~25
> 
> So, your commit is 25 commits back in the 2nd branch of the merge
> described by v3.11-rc1~16^2~103^2^2~5
> 
> git show v3.11-rc1~16^2~103^2^2~5
> commit 76015021aaaa288bb4dc870258e0acc4d178c950
> Merge: f7a01ca fded313
> Author: John W. Linville <linville@tuxdriver.com>
> Date:   Mon Jun 10 14:51:17 2013 -0400
> 
>     Merge branch 'for-john' of git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next
> 
> which is by definition, 5 commits back from 2nd branch
> of the merge v3.11-rc1~16^2~103^2
> 
> $ git show v3.11-rc1~16^2~103^2
> commit 3899ba90a4ab2f3cab8e0f91a76c14ff131c8293
> Merge: 45203a3 8b3e7be
> Author: John W. Linville <linville@tuxdriver.com>
> Date:   Tue Jun 11 14:48:32 2013 -0400
> 
>     Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next into for-davem
> 
> and that merge was merged into the merge v3.11-rc1~16^2~103
> 
> git show v3.11-rc1~16^2~103
> commit 4a2e667ac15edd19b02321bc030acb3ebeb22ab6
> Merge: 8f728d7 3899ba9
> Author: David S. Miller <davem@davemloft.net>
> Date:   Wed Jun 12 14:23:41 2013 -0700
> 
>     Merge branch 'for-davem' of git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next
> 
> which means the above merge was 103 commits back from the last
> (last = latest/newest) commit on the 2nd arm in merge v3.11-rc1~16
> and so on.
> 
> All the data is there, regardless of whether a maintainer manually
> manipulated the patch and added a SOB line or not.

Alternatively (and that's what I am using) you fire up gitk, and you see 
all the information almost instantly.

-- 
Jiri Kosina
SUSE Labs
