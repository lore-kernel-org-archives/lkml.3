Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757917Ab3FLUaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 16:30:08 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:53023 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756176Ab3FLUaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 16:30:06 -0400
Date: Wed, 12 Jun 2013 13:30:02 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Dave Chinner <david@fromorbit.com>
Cc: axboe@kernel.dk, tytso@mit.edu, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: Immutable biovecs, dio rewrite
Message-ID: <20130612203002.GD6151@google.com>
References: <1370744348-15407-1-git-send-email-koverstreet@google.com>
 <20130611052012.GJ29376@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130611052012.GJ29376@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 11, 2013 at 03:20:12PM +1000, Dave Chinner wrote:
> Please test with XFS and CONFIG_XFS_DEBUG=y - xfstests will stress
> the dio subsystem a lot more when it is run on XFS. Indeed, xfstests
> generic/013 assert fails almost immediately with:

Thanks - I haven't used xfstests much before. This one turned out to be
an easy fix, but once I turned on CONFIG_XFS_DEBUG I hit something else
I hadn't seen before:

[ 1343.482366] XFS (sdb2): Corruption detected. Unmount and run xfs_repair
[ 1343.482425] XFS (sdb2): bad inode magic/vsn daddr 64 #8 (magic=5858)
[ 1343.482482] XFS: Assertion failed: 0, file: /home/kent/linux/fs/xfs/xfs_inode.c, line: 417
[ 1343.482558] ------------[ cut here ]------------
[ 1343.482611] kernel BUG at /home/kent/linux/fs/xfs/xfs_message.c:108!

This one looks weirder - any thoughts on what might cause _that_?

(Don't spend any time on it, I haven't tried to debug it besides glancing at
the relevant xfs code - just curious if you have any pointers)
