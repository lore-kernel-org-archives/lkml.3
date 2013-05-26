Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758976Ab3EZDWL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 23:22:11 -0400
Received: from mail-vb0-f45.google.com ([209.85.212.45]:63316 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758577Ab3EZDWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 23:22:08 -0400
MIME-Version: 1.0
In-Reply-To: <51A1040A.80003@schaufler-ca.com>
References: <CA+55aFyKg=m=USnRmFQNaRB_9MWNpzdLwxr-v7X0ONaG72+nsg@mail.gmail.com>
	<CA+55aFw_ic=4OvH0Ys2CUjgotdbfdbuxUsx77RYEYPGrbqzbAA@mail.gmail.com>
	<20130525165710.GC25399@ZenIV.linux.org.uk>
	<51A1040A.80003@schaufler-ca.com>
Date: Sat, 25 May 2013 20:22:07 -0700
X-Google-Sender-Auth: PJc48P4T3pPto6OlXWTbUyLTMgE
Message-ID: <CA+55aFw1RLrMsvkG+yHfHw4ht5BcC7Q39qXDD2dyUp9+_HsSLA@mail.gmail.com>
Subject: Re: Stupid VFS name lookup interface..
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Paris <eparis@redhat.com>,
        James Morris <james.l.morris@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 25, 2013 at 11:33 AM, Casey Schaufler
<casey@schaufler-ca.com> wrote:
>
> Now I'll put on my Smack maintainer hat. Performance improvement is
> always welcome, but I would rather see attention to performance of
> the LSM architecture than SELinux specific hacks.

I haven't seen huge issues with performance at that level.

> The LSM blob
> pointer scheme is there so that you (Linus) don't have to see the
> dreadful things that we security people are doing. Is it time to
> get past that level of disassociation? Or, and I really hate asking
> this, have you fallen into the SELinux camp?

I only have selinux performance to look at, since I run Fedora. I used
to actually turn it off entirely, because it impacted VFS performance
so horribly. We fixed it. I (and Al) spent time to make sure that we
don't need to drop RCU lookup just because we call into the security
layers etc.

But I haven't even looked at what non-selinux setups do to
performance. Last time I tried Ubuntu (they still use apparmor, no?),
"make modules_install ; make install" didn't work for the kernel, and
if the Ubuntu people don't want to support kernel engineers, I
certainly am not going to bother with them. Who uses smack?

                Linus
