Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967393Ab3E3DFZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 23:05:25 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:34868 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965522Ab3E3DFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 23:05:16 -0400
MIME-Version: 1.0
In-Reply-To: <CACLa4ptBVHwrruB-WeVKfPYoyAVH6ys4bEHhHTp6RyhqAw0vHg@mail.gmail.com>
References: <CA+55aFyKg=m=USnRmFQNaRB_9MWNpzdLwxr-v7X0ONaG72+nsg@mail.gmail.com>
	<CA+55aFw_ic=4OvH0Ys2CUjgotdbfdbuxUsx77RYEYPGrbqzbAA@mail.gmail.com>
	<20130525165710.GC25399@ZenIV.linux.org.uk>
	<51A1040A.80003@schaufler-ca.com>
	<CA+55aFw1RLrMsvkG+yHfHw4ht5BcC7Q39qXDD2dyUp9+_HsSLA@mail.gmail.com>
	<alpine.LRH.2.02.1305261503510.7712@tundra.namei.org>
	<CA+55aFyiOR=2o7BWQXcb-7_YULXbr+SuzoOeGQxV4cmck1y8Ow@mail.gmail.com>
	<CACLa4ptBVHwrruB-WeVKfPYoyAVH6ys4bEHhHTp6RyhqAw0vHg@mail.gmail.com>
Date: Thu, 30 May 2013 12:05:15 +0900
X-Google-Sender-Auth: XYCvSPF8Hc9Shn8sHZQ29FuD0Wo
Message-ID: <CA+55aFzUCiRV0p+cP2r+1oC+D-eqBDu=GvCSbvJjkCqtFzvH5Q@mail.gmail.com>
Subject: Re: Stupid VFS name lookup interface..
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Eric Paris <eparis@parisplace.org>
Cc: James Morris <jmorris@namei.org>, Casey Schaufler <casey@schaufler-ca.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Paris <eparis@redhat.com>,
        James Morris <james.l.morris@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 10:28 AM, Eric Paris <eparis@parisplace.org> wrote:
>
> How do I tell what is taking time inside selinux_inode_permission?

Go to "annotate" (just press 'a' when the function is highlighted),
which will show you the disassembly and the cost of each instruction.

That's when you really want to use "-e cycles:pp" to get the
instruction-level profile right, though. Otherwise the cost will
usually be assigned to the instructions following the expensive one.

And I can tell you that the cost is almost certainly the cache miss on
the inode->i_security accesses. Which was the reason for that second
patch that moved "sid" to the inode->i_sid field and avoided the extra
dereference.

             Linus
