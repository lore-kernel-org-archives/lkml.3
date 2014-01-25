Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010AbaAYPET (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 10:04:19 -0500
Received: from ares08.inai.de ([46.4.84.70]:50313 "EHLO ares08.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441AbaAYPES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 10:04:18 -0500
X-Greylist: delayed 588 seconds by postgrey-1.27 at vger.kernel.org; Sat, 25 Jan 2014 10:04:18 EST
Date: Sat, 25 Jan 2014 15:54:29 +0100 (CET)
From: Jan Engelhardt <jengelh@inai.de>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Lucas De Marchi <lucas.de.marchi@gmail.com>,
        Peter Chen <peter.chen@freescale.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/1] module: Make wait module's refcount to zero
 procedure as async
In-Reply-To: <87wqmh1l8b.fsf@rustcorp.com.au>
Message-ID: <alpine.LSU.2.11.1401251550580.4334@nerf08.vanv.qr>
References: <1378955676-12708-1-git-send-email-peter.chen@freescale.com> <87ioy536mu.fsf@rustcorp.com.au> <CAKi4VAJ5=zsJzyQNprchB2wnwh0+gg2oNP2PFsa4Lcw++3mSig@mail.gmail.com> <87wqmh1l8b.fsf@rustcorp.com.au>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 2013-09-16 05:47, Rusty Russell wrote:
>
>Here's what I've got in my pending-rebases tree.
>
>@@ -842,6 +818,11 @@ SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
> 		return -EFAULT;
> 	name[MODULE_NAME_LEN-1] = '\0';
> 
>+	if (!(flags & O_NONBLOCK)) {
>+		printk(KERN_WARNING
>+		       "waiting module removal not supported: please upgrade");
>+	}
>+

This patch has come to my attention via the opensuse lists, where
a poster reported about this new user-visible message (it appears
in dmesg!) and rightfully asked: upgrade what component?

It's probably the userspace module loading utility, but it _really_
should say so. There's good room to read that message - a few months
into the future - as "upgrade your kernel" instead ;)
