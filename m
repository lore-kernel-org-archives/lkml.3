Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376AbaBML4m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 06:56:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18908 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752989AbaBML4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 06:56:40 -0500
Date: Thu, 13 Feb 2014 12:55:52 +0100
From: Jakub Jelinek <jakub@redhat.com>
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        stable@vger.kernel.org, steven@uplinklabs.net, rostedt@goodmis.org,
        akpm@linux-foundation.org, tglx@linutronix.de, oleg@redhat.com,
        rth@twiddle.net
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] compiler/gcc4: Make quirk for
 asm_volatile_goto( ) unconditional
Message-ID: <20140213115552.GU20378@tucnak.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <1392274867-15236-1-git-send-email-steven@uplinklabs.net>
 <tip-a9f180345f5378ac87d80ed0bea55ba421d83859@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-a9f180345f5378ac87d80ed0bea55ba421d83859@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 03:37:08AM -0800, tip-bot for Steven Noonan wrote:
> Commit-ID:  a9f180345f5378ac87d80ed0bea55ba421d83859
> Gitweb:     http://git.kernel.org/tip/a9f180345f5378ac87d80ed0bea55ba421d83859
> Author:     Steven Noonan <steven@uplinklabs.net>
> AuthorDate: Wed, 12 Feb 2014 23:01:07 -0800
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Thu, 13 Feb 2014 12:34:05 +0100
> 
> compiler/gcc4: Make quirk for asm_volatile_goto() unconditional
> 
> I started noticing problems with KVM guest destruction on Linux
> 3.12+, where guest memory wasn't being cleaned up. I bisected it
> down to the commit introducing the new 'asm goto'-based atomics,
> and found this quirk was later applied to those.
> 
> Unfortunately, even with GCC 4.8.2 (which ostensibly fixed the
> known 'asm goto' bug) I am still getting some kind of
> miscompilation. If I enable the asm_volatile_goto quirk for my
> compiler, KVM guests are destroyed correctly and the memory is
> cleaned up.

BTW, which exact 4.8.2 were you using?
The last known asm goto bug has been fixed on October, 10th, 2013:
http://gcc.gnu.org/PR58670
so before the October, 16th, 2013 4.8.2 release.  But already since
May 31th, 2013 the tip of the 4.8 GCC branch has been announcing itself
as 4.8.2 prerelease.  While some distribution versions of GCC announce
themselves as the new version only starting from the release date,
i.e. snapshots in between 4.8.1 release and 4.8.2 release announce
themselves as 4.8.1, in other distributions or upstream it announces itself
as 4.8.2.  So, if you are using the latter and a snapshot in between May
31th, 2013 and October, 10th, 2013, then you could see gcc patchlevel 2,
yet have a gcc with that bug unfixed.
So, if the kernel doesn't use a runtime test/configure test to check for
this issue, but instead just relies on the patchlevel version, the only
safe way would be to look for GCC >= 4.9 or GCC 4.8 with patchlevel > 2
rather than > 1.

	Jakub
