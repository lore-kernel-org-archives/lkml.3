Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313AbbAGA3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 19:29:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45403 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbbAGA3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 19:29:16 -0500
Date: Tue, 6 Jan 2015 16:29:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Drysdale <drysdale@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        David Miller <davem@davemloft.net>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>,
        Arnd Bergmann <arnd@arndb.de>, Jan Kara <jack@suse.cz>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        sparclinux@vger.kernel.org
Subject: Re: [PATCHv2 1/1] vfs: renumber FMODE_NONOTIFY and add to
 uniqueness check
Message-Id: <20150106162915.7edb5620999641ebdc7a74e6@linux-foundation.org>
In-Reply-To: <1416828199-3414-2-git-send-email-drysdale@google.com>
References: <1416828199-3414-1-git-send-email-drysdale@google.com>
	<1416828199-3414-2-git-send-email-drysdale@google.com>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Nov 2014 11:23:19 +0000 David Drysdale <drysdale@google.com> wrote:

> Fix clashing values for O_PATH and FMODE_NONOTIFY on sparc.
> The clashing O_PATH value was added in 5229645bdc35f1cc43eb ("vfs: add
> nonconflicting values for O_PATH") but this can't be changed as it
> is user-visible.
> 
> FMODE_NONOTIFY is only used internally in the kernel, but it is in
> the same numbering space as the other O_* flags, as indicated by the
> comment at the top of include/uapi/asm-generic/fcntl.h (and its use
> in fs/notify/fanotify/fanotify_user.c).  So renumber it to avoid
> the clash.
> 
> All of this has happened before (12ed2e36c98aec6c4155, "fanotify:
> FMODE_NONOTIFY and __O_SYNC in sparc conflict"), and all of this
> will happen again -- so update the uniqueness check in fcntl_init()
> to include __FMODE_NONOTIFY.

What are the user-visible runtime effects of the bug?

Please always include this info when fixing bugs, so people can work
out which kernel version(s) need the fix.

