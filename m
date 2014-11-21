Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625AbaKUWX7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 17:23:59 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:39768 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbaKUWX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 17:23:58 -0500
Date: Fri, 21 Nov 2014 17:23:54 -0500 (EST)
Message-Id: <20141121.172354.1624921151736272847.davem@davemloft.net>
To: drysdale@google.com
Cc: viro@zeniv.linux.org.uk, eparis@redhat.com, arnd@arndb.de,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        sparclinux@vger.kernel.org
Subject: Re: [PATCH] vfs: renumber FMODE_NONOTIFY and add to uniqueness
 check
From: David Miller <davem@davemloft.net>
In-Reply-To: <1416562882-21190-1-git-send-email-drysdale@google.com>
References: <1416562882-21190-1-git-send-email-drysdale@google.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 21 Nov 2014 14:23:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Drysdale <drysdale@google.com>
Date: Fri, 21 Nov 2014 09:41:22 +0000

> Although FMODE_NONOTIFY is only used internally in the kernel it is in
> the same numbering space as the other O_* flags, as indicated by the
> comment at the top of include/uapi/asm-generic/fcntl.h (and its use
> in fs/notify/fanotify/fanotify_user.c).  However, its current value
> clashes with the value of O_PATH on sparc, so renumber it to avoid
> the clash.
> 
> All of this has happened before (12ed2e36c98aec6c4155, "fanotify:
> FMODE_NONOTIFY and __O_SYNC in sparc conflict"), and all of this
> will happen again -- so update the uniqueness check in fcntl_init()
> to include __FMODE_NONOTIFY.
> 
> Signed-off-by: David Drysdale <drysdale@google.com>

Acked-by: David S. Miller <davem@davemloft.net>
