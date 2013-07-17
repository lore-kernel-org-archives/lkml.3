Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965067Ab3GQXGs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 19:06:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52784 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964991Ab3GQXGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 19:06:04 -0400
Date: Wed, 17 Jul 2013 16:06:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hugh Dickins <hughd@google.com>, Jeff Layton <jlayton@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Jim Cromie <jim.cromie@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Rusty Russell <rusty@rustcorp.com.au>, Sam Ravnborg <sam@ravnborg.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH 0/5] initmpfs v2: use tmpfs instead of ramfs for rootfs
Message-Id: <20130717160602.4b225ac80b1cb6121cbb489c@linux-foundation.org>
In-Reply-To: <20130715140135.0f896a584fec9f7861049b64@linux-foundation.org>
References: <20130715140135.0f896a584fec9f7861049b64@linux-foundation.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jul 2013 08:31:13 -0700 (PDT) Rob Landley <rob@landley.net> wrote:

> Use tmpfs for rootfs when CONFIG_TMPFS=y and there's no root=.
> Specify rootfstype=ramfs to get the old initramfs behavior.
> 
> The previous initramfs code provided a fairly crappy root filesystem:
> didn't let you --bind mount directories out of it, reported zero
> size/usage so it didn't show up in "df" and couldn't run things like
> rpm that query available space before proceeding, would fill up all
> available memory and panic the system if you wrote too much to it...

The df problem and the mount --bind thing are ramfs issues, are they
not?  Can we fix them?  If so, that's a less intrusive change, and we
also get a fixed ramfs.

> Using tmpfs instead provides a much better root filesystem.
> 
> Changes from last time: use test_and_set_bit() for "once" logic.
