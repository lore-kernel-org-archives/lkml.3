Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346AbaE2LR1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 07:17:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30729 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753066AbaE2LR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 07:17:26 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <27993.1401360881@warthog.procyon.org.uk>
References: <27993.1401360881@warthog.procyon.org.uk> <1400838223-30844-1-git-send-email-miklos@szeredi.hu>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dhowells@redhat.com, viro@ZenIV.linux.org.uk,
        torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        akpm@linux-foundation.org, apw@canonical.com, nbd@openwrt.org,
        neilb@suse.de, jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu,
        sedat.dilek@gmail.com, hooanon05@yahoo.co.jp, mszeredi@suse.cz
Subject: Re: Kernel errors with overlay filesystem v22
Date: Thu, 29 May 2014 12:16:42 +0100
Message-ID: <28186.1401362202@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> ================================================
> [ BUG: lock held when returning to user space! ]
> 3.15.0-rc6-fsdevel+ #363 Tainted: G        W    
> ------------------------------------------------
> mount/4183 is leaving the kernel with locks still held!
> 1 lock held by mount/4183:
>  #0:  (sb_writers#8){.+.+.+}, at: [<ffffffff8112bf5b>] mnt_want_write+0x1c/0x40

This comes from the:

+ mount -t overlayfs overlayfs /mnt -olowerdir=/lower,upperdir=/upper/upper,workdir=/upper/work

command.

David
