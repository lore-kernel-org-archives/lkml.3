Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646AbaIHMUF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 08:20:05 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:60233 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640AbaIHMUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 08:20:02 -0400
Date: Mon, 8 Sep 2014 16:19:56 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrey Vagin <avagin@openvz.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>,
        Eric Paris <eparis@parisplace.org>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [PATCH] fs: don't remove inotify watchers from alive inode-s
Message-ID: <20140908121956.GY16395@moon>
References: <1410177716-3965-1-git-send-email-avagin@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410177716-3965-1-git-send-email-avagin@openvz.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
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

This changes the sequence of notifies userspace will see but I think there
were a bug before this patch, so

Reviewed-by: Cyrill Gorcunov <gorcunov@openvz.org>
