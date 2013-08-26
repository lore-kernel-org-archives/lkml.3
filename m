Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702Ab3HZKUt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 06:20:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3514 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756645Ab3HZKUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 06:20:46 -0400
Date: Mon, 26 Aug 2013 13:20:24 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Yann Droneaud <ydroneaud@opteya.com>
Cc: Alexander Graf <agraf@suse.de>, Paolo Bonzini <pbonzini@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Alex Williamson <alex.williamson@redhat.com>, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] kvm: use anon_inode_getfd() with O_CLOEXEC flag
Message-ID: <20130826102023.GA8218@redhat.com>
References: <cover.1377372576.git.ydroneaud@opteya.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1377372576.git.ydroneaud@opteya.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 24, 2013 at 10:14:06PM +0200, Yann Droneaud wrote:
> Hi,
> 
> Following a patchset asking to change calls to get_unused_flag() [1]
> to use O_CLOEXEC, Alex Williamson [2][3] decided to change VFIO
> to use the flag.
> 
> Since it's a related subsystem to KVM, using O_CLOEXEC for
> file descriptors created by KVM might be applicable too.
> 
> I'm suggesting to change calls to anon_inode_getfd() to use O_CLOEXEC
> as default flag.
> 
> This patchset should be reviewed to not break existing userspace program.
> 
> BTW, if it's not applicable, I would suggest that new ioctls be added to
> KVM subsystem, those ioctls would have a "flag" field added to their arguments.
> Such "flag" would let userspace choose the open flag to use.
> See for example other APIs using anon_inode_getfd() such as fanotify,
> inotify, signalfd and timerfd.
> 
> You might be interested to read:
> 
> - Secure File Descriptor Handling (Ulrich Drepper, 2008)
>   http://udrepper.livejournal.com/20407.html
> 
> - Excuse me son, but your code is leaking !!! (Dan Walsh, March 2012) 
>   http://danwalsh.livejournal.com/53603.html
> 
Applied, thanks.

> Regards.
> 
> [1] http://lkml.kernel.org/r/cover.1376327678.git.ydroneaud@opteya.com
> [2] http://lkml.kernel.org/r/1377186804.25163.17.camel@ul30vt.home
> [3] http://lkml.kernel.org/r/20130822171744.1297.13711.stgit@bling.home
> 
> Yann Droneaud (2):
>   kvm: use anon_inode_getfd() with O_CLOEXEC flag
>   ppc: kvm: use anon_inode_getfd() with O_CLOEXEC flag
> 
>  arch/powerpc/kvm/book3s_64_mmu_hv.c | 2 +-
>  arch/powerpc/kvm/book3s_64_vio.c    | 2 +-
>  arch/powerpc/kvm/book3s_hv.c        | 2 +-
>  virt/kvm/kvm_main.c                 | 6 +++---
>  4 files changed, 6 insertions(+), 6 deletions(-)
> 
> -- 
> 1.8.3.1

--
			Gleb.
