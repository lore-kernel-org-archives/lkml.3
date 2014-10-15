Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751627AbaJOOwH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 10:52:07 -0400
Received: from mail-qg0-f45.google.com ([209.85.192.45]:50182 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbaJOOwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 10:52:05 -0400
From: Paul Moore <paul@paul-moore.com>
To: James Morris <jmorris@namei.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] SELinux list corruption fix for 3.18
Date: Wed, 15 Oct 2014 10:52:01 -0400
Message-ID: <1684821.IaZ0PAoQZ3@sifl>
User-Agent: KMail/4.14.1 (Linux/3.16.1-gentoo; KDE/4.14.1; x86_64; ; )
In-Reply-To: <alpine.LRH.2.11.1410151901560.11622@namei.org>
References: <alpine.LRH.2.11.1410150158010.29573@namei.org> <CA+55aFwcqHx5W=tFaf0a6gb=1yH-GwARc=R0s2vwm14YBqrfhQ@mail.gmail.com> <alpine.LRH.2.11.1410151901560.11622@namei.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 15, 2014 07:05:55 PM James Morris wrote:
> On Wed, 15 Oct 2014, Linus Torvalds wrote:
> > On Wed, Oct 15, 2014 at 7:27 AM, Linus Torvalds
> > 
> > <torvalds@linux-foundation.org> wrote:
> > > No, the log is correct (the log always is, the back-merges can cause
> > > the trivial *diff* to be broken).
> > 
> > To add some details: the commits in there are
> > 
> >   f6ed66087648 Merge branch 'stable-3.18' of
> > 
> > git://git.infradead.org/users/pcmoore/selinux into f
> > 
> >   7c66bdc72bc3 selinux: fix inode security list corruption
> >   e7387395a07d selinux: normalize audit log formatting
> >   8497b78ecc9d selinux: cleanup error reporting in selinux_nlmsg_perm()
> >   6eb1ddc6bd3f selinux: make the netif cache namespace aware
> >   5e29532fed21 selinux: register nf hooks with single nf_register_hooks
> >   call
> >   82341ad9b962 selinux: fix a problem with IPv6 traffic denials in
> > 
> > selinux_ip_postroute()
> > 
> >   04e8d6ab1fa6 selinux: Permit bounded transitions under NO_NEW_PRIVS or
> >   NOSUID.> 
> > and all but the list corruption fix seem to just be duplicate commits
> > of things I have already gotten elsewhere. Somebody cherry-picking
> > commits and duplicating them?
> 
> Yep, I also already have these other changes under different commit IDs:
> 
> commit 7b0d0b40cd78cadb525df760ee4cac151533c2b5
> Author: Stephen Smalley <sds@tycho.nsa.gov>
> Date:   Mon Aug 4 13:36:49 2014 -0400
> 
>     selinux: Permit bounded transitions under NO_NEW_PRIVS or NOSUID.
> 
> 
> Paul: do you have the above commit ID in your tree?

It would seem I've got the Midas touch this merge window, my apologies yet 
again.

The short version is that everything should be fixed now, the stable-3.18 
branch should be the single list corruption patch on top of the next branch I 
sent previously.  James, could you please re-pull from the stable-3.18 branch?

Thanks for your patience.

The slightly longer version is that when I created the stable-3.18 branch from 
the next branch I used the '--clone' flag in stgit which updated the dates on 
the patches which were new for #next (not "committed" in stgit) and caused the 
commit IDs to change.  Another lesson learned, I'm sorry it caused additional 
problems.

-Paul

-- 
paul moore
www.paul-moore.com

