Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932103AbaJCVoV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:44:21 -0400
Received: from mta-out1.inet.fi ([62.71.2.226]:37028 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755080AbaJCVoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:44:18 -0400
Date: Sat, 4 Oct 2014 00:43:59 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>, Jan Kara <jack@suse.cz>,
        Eric Paris <eparis@parisplace.org>,
        John McCutchon <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>
Subject: Re: [PATCH 1/1] truncate: generate fanotify and inotify events
Message-ID: <20141003214359.GA19171@node.dhcp.inet.fi>
References: <1412371996-1265-1-git-send-email-xypron.glpk@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412371996-1265-1-git-send-email-xypron.glpk@gmx.de>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2014 at 11:33:16PM +0200, Heinrich Schuchardt wrote:
> The fanotify and the inotify API can be used to monitor changes of the file
> system.
> 
> System call truncate modifies files. Hence it should trigger the corresponding
> fanotify and inotify events.
> 
> Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
> ---
>  fs/open.c                |  5 +++
>  include/linux/fsnotify.h | 87 ++++++++++++++++++++++++++++++++----------------
>  security/security.c      |  7 +++-
>  3 files changed, 70 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/open.c b/fs/open.c
> index d6fd3ac..be45e58 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -104,12 +104,17 @@ long vfs_truncate(struct path *path, loff_t length)
>  	if (!error)
>  		error = security_path_truncate(path);
>  	if (!error)
> +		fsnotify_open_path(path);
>  		error = do_truncate(path->dentry, length, 0, NULL);

This is obviously broken.

-- 
 Kirill A. Shutemov
