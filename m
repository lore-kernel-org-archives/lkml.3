Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbaA0Lpw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 06:45:52 -0500
Received: from ozlabs.org ([203.10.76.45]:47951 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121AbaA0Lpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 06:45:51 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jan Engelhardt <jengelh@inai.de>
Cc: Lucas De Marchi <lucas.de.marchi@gmail.com>,
        Peter Chen <peter.chen@freescale.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/1] module: Make wait module's refcount to zero procedure as async
In-Reply-To: <alpine.LSU.2.11.1401251550580.4334@nerf08.vanv.qr>
References: <1378955676-12708-1-git-send-email-peter.chen@freescale.com> <87ioy536mu.fsf@rustcorp.com.au> <CAKi4VAJ5=zsJzyQNprchB2wnwh0+gg2oNP2PFsa4Lcw++3mSig@mail.gmail.com> <87wqmh1l8b.fsf@rustcorp.com.au> <alpine.LSU.2.11.1401251550580.4334@nerf08.vanv.qr>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Mon, 27 Jan 2014 22:15:23 +1030
Message-ID: <87sis9zm0c.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt <jengelh@inai.de> writes:
> On Monday 2013-09-16 05:47, Rusty Russell wrote:
>>
>>Here's what I've got in my pending-rebases tree.
>>
>>@@ -842,6 +818,11 @@ SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
>> 		return -EFAULT;
>> 	name[MODULE_NAME_LEN-1] = '\0';
>> 
>>+	if (!(flags & O_NONBLOCK)) {
>>+		printk(KERN_WARNING
>>+		       "waiting module removal not supported: please upgrade");
>>+	}
>>+
>
> This patch has come to my attention via the opensuse lists, where
> a poster reported about this new user-visible message (it appears
> in dmesg!) and rightfully asked: upgrade what component?
>
> It's probably the userspace module loading utility, but it _really_
> should say so. There's good room to read that message - a few months
> into the future - as "upgrade your kernel" instead ;)

True, but honestly I never expected to see it!

Please try to discover what is doing rmmod --wait?

Thanks,
Rusty.
