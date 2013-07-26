Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932630Ab3GZMx2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 08:53:28 -0400
Received: from mail-ye0-f178.google.com ([209.85.213.178]:50902 "EHLO
	mail-ye0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932463Ab3GZMxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 08:53:05 -0400
From: Paul Moore <paul@paul-moore.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@redhat.com>
Subject: Re: linux-next: build failure after merge of the lblnet tree
Date: Fri, 26 Jul 2013 08:52:59 -0400
Message-ID: <2559996.tgPUuSUm5t@sifl>
User-Agent: KMail/4.10.5 (Linux/3.10.2-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20130726140617.c31cc3d8e5fb88dd69707906@canb.auug.org.au>
References: <20130726140617.c31cc3d8e5fb88dd69707906@canb.auug.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 26, 2013 02:06:17 PM Stephen Rothwell wrote:
> Hi Paul,
> 
> After merging the lblnet tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> security/selinux/hooks.c: In function 'sb_finish_set_opts':
> security/selinux/hooks.c:448:19: error: 'SE_SBLABELSUPP' undeclared (first
> use in this function) sbsec->flags |= SE_SBLABELSUPP;
>                    ^
> Caused by commit 8cf9124a324f ("SELinux: Enable setting security contexts
> on rootfs inodes") interacting with commit 12f348b9dcf6 ("SELinux: rename
> SE_SBLABELSUPP to SBLABEL_MNT") from the selinux tree.
> 
> This is not helped by the fact that there are a lot of commits in the
> lblnet tree (including 8cf9124a324f) that have been cherry-picked
> (instead of being merged) into the selinux tree.  :-(

The problem should be fixed now.

The issue was that I was temporarily holding a lot of these SELinux patches in 
the lblnet-next tree so they could get some linux-next exposure while Eric was 
busy an unable to update the SELinux tree.  Unfortunately, there was some 
miscommunication between Eric and I yesterday and the trees got a bit out of 
sync.  All the lblnet-next patches have now been included in the SELinux tree 
so I've "pruned" them from the lblnet-next tree.

Thanks for your understanding,
-Paul

-- 
paul moore
www.paul-moore.com

