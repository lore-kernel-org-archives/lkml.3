Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406AbaLWR6I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 12:58:08 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:54464 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756363AbaLWR6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 12:58:06 -0500
Date: Tue, 23 Dec 2014 11:58:03 -0600
From: Eric Biggers <ebiggers3@gmail.com>
To: fuse-devel@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mszeredi@suse.cz
Subject: [BUG] fuse: request prepared before protocol version is known
Message-ID: <20141223175803.GA9789@zzz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am using Linux 3.19-rc1 and I encountered a bug where stat() would
sporatically fail with EIO when called on a file in a FUSE filesystem very
shortly after that filesystem has been mounted.  This is a regression caused by
commit 7078187a: "fuse: introduce fuse_simple_request() helper".

The underlying issue is that the arguments to the FUSE request are being
initialized before the protocol version (fc->minor) is known.  This was not a
problem with the old code because fuse_get_req() will wait until the channel has
been initialized.

The only potential solutions I have in mind are adding an explicit waits in all
the needed places, or reverting the commit.

Eric
