Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865AbaIIB1R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 21:27:17 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45218 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755380AbaIIB1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 21:27:15 -0400
Date: Tue, 9 Sep 2014 02:27:12 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andrey Vagin <avagin@openvz.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>,
        Eric Paris <eparis@parisplace.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [PATCH] fs: don't remove inotify watchers from alive inode-s
Message-ID: <20140909012712.GV7996@ZenIV.linux.org.uk>
References: <1410177716-3965-1-git-send-email-avagin@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410177716-3965-1-git-send-email-avagin@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 04:01:56PM +0400, Andrey Vagin wrote:
> Currently watchers are removed in dentry_iput(), if n_link is zero.
> But other detries can be linked with this inode. For example if we
> create two hard links, open the first one and set a watcher on the
> second one. Then if we remove both links, the watcher will be removed.
> But we will have the alive file descriptor, which allows us to generate
> more events.
> 
> With this patch, watchers will be removed, only if nlink is zero and
> i_dentry list is empty.

It changes user-visible ABI.  Worse yet, this "ABI" has no specification,
so any (misguided) software using that FPOS has nothing to go by other than
"whatever existing kernels do".  As the result, inotify behaviour is cast
in concrete.

IOW, NAK.
