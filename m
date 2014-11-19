Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756659AbaKSUaH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 15:30:07 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:38443 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756295AbaKSUaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:30:05 -0500
Date: Wed, 19 Nov 2014 15:30:01 -0500 (EST)
Message-Id: <20141119.153001.1273476178846053821.davem@davemloft.net>
To: drysdale@google.com
Cc: viro@zeniv.linux.org.uk, eparis@redhat.com, linux-kernel@vger.kernel.org,
        sparclinux@vger.kernel.org, inux-fsdevel@vger.kernel.org
Subject: Re: sparc: Clashing values for O_PATH and FMODE_NONOTIFY?
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAHse=S_EY3mJ_pdZf+A46joro_uNy=6tXGG1v7Va4NX_YxJu2w@mail.gmail.com>
References: <CAHse=S_EY3mJ_pdZf+A46joro_uNy=6tXGG1v7Va4NX_YxJu2w@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Nov 2014 12:30:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Drysdale <drysdale@google.com>
Date: Tue, 18 Nov 2014 13:13:51 +0000

> Hi folks,
> 
> It looks like the value for O_PATH on sparc:
> 
>   arch/sparc/include/uapi/asm/fcntl.h:37:#define O_PATH 0x1000000
> 
> clashes with the arch-independent value for __FMODE_NONOTIFY:
> 
>   include/linux/fs.h:137:#define FMODE_NONOTIFY ((__force fmode_t)0x1000000)
>   include/linux/fs.h:2764:#define __FMODE_NONOTIFY ((__force int)
> FMODE_NONOTIFY)
> 
> and they are both in the same numbering space, as indicated by the
> comment at the top of include/uapi/asm-generic/fcntl.h and the use in
> fs/notify/fanotify/fanotify_user.c:715.
> 
> Presumably this could theoretically cause problems (no notifications for
> O_PATH files on SPARC?), so would it be a good idea to renumber
> FMODE_NONOTIFY?  (I *think* that value is entirely kernel-internal.)
> 
> Given that this has happened before (12ed2e36c98aec6c4155 "fanotify:
> FMODE_NONOTIFY and __O_SYNC in sparc conflict") it would probably
> also be a good idea to add __FMODE_NOTIFY to the uniqueness check in
> fs/fcntl.c:fcntl_init().
> 
> Thoughts?

I think you will need to change the internal value, to not clash with
the sparc exported one, for sure.
