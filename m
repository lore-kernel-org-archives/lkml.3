Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188Ab3F2UMP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 16:12:15 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:42026 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab3F2UMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 16:12:13 -0400
Date: Sat, 29 Jun 2013 13:12:12 -0700 (PDT)
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hugh Dickins <hughd@google.com>, Jeff Layton <jlayton@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Jim Cromie <jim.cromie@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Rusty Russell <rusty@rustcorp.com.au>, Sam Ravnborg <sam@ravnborg.org>,
        Stephen Warren <swarren@nvidia.com>
To: linux-kernel@vger.kernel.org
Message-Id: <1372536729.850447@landley.net>
From: Rob Landley <rob@landley.net>
Subject: [PATCH 0/5] initmpfs: use tmpfs instead of ramfs for rootfs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use tmpfs for rootfs when CONFIG_TMPFS=y and there's no root=.
Specify rootfstype=ramfs to get the old initramfs behavior.

The previous initramfs code provided a fairly crappy root filesystem:
didn't let you --bind mount directories out of it, reported zero
size/usage so it didn't show up in "df" and couldn't run things like
rpm that query available space before proceeding, would fill up all
available memory and panic the system if you wrote too much to it...

Using tmpfs instead provides a much better root filesystem.
