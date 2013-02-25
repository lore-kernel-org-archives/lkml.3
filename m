Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759173Ab3BYSZV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 13:25:21 -0500
Received: from tetsuo.zabbo.net ([50.193.208.193]:39149 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347Ab3BYSZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 13:25:17 -0500
Date: Mon, 25 Feb 2013 10:25:16 -0800
From: Zach Brown <zab@zabbo.net>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Li Zefan <lizefan@huawei.com>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
        Andrew Morton <akpm@linux-foundation.org>, andi@firstfloor.org,
        Wuqixuan <wuqixuan@huawei.com>, gregkh@linuxfoundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC] f_pos in readdir() (was Re: [RFC][PATCH] vfs: always
 protect diretory file->fpos with inode mutex)
Message-ID: <20130225182516.GI22221@lenny.home.zabbo.net>
References: <5122D3E0.6070800@huawei.com>
 <20130223173521.GP4503@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130223173521.GP4503@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> As for ->readdir(), I'd like to resurrect an old proposal to change the ABI
> of that sucker.  Quoting the thread from 4 years ago:

I'd love to see the readdir() interface cleaned up, yes please.

> Comments?

Hmm.  Do we want to think about letting callers copy the name to
userspace in fragments?

I was looking at current readdir paths and saw that btrfs has an
annoying wrinkle that its directory entries might be in large blocks
that span disjoint pages.  So it copies them to a kmalloced()ed buffer
to pass to filldir().

Maybe it wouldn't be worth having to track incomplete entries in the
core, but it'd be nice to get rid of this copy in btrfs.

(btrfs could also be more clever and only do this dance when the name
really does span pages.. it's very rare. :/).

- z
