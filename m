Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab3GHWlh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 18:41:37 -0400
Received: from relay2.sgi.com ([192.48.179.30]:59343 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751633Ab3GHWlf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 18:41:35 -0400
Date: Mon, 8 Jul 2013 17:41:33 -0500
From: Ben Myers <bpm@sgi.com>
To: Yann Droneaud <ydroneaud@opteya.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH 10/13] xfs: use get_unused_fd_flags(0) instead of
 get_unused_fd()
Message-ID: <20130708224133.GA23250@sgi.com>
References: <cover.1372777600.git.ydroneaud@opteya.com>
 <8d21b76c621dbfc59b2dbbfc933f96170835304d.1372777600.git.ydroneaud@opteya.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d21b76c621dbfc59b2dbbfc933f96170835304d.1372777600.git.ydroneaud@opteya.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 02, 2013 at 06:39:34PM +0200, Yann Droneaud wrote:
> Macro get_unused_fd() is used to allocate a file descriptor with
> default flags. Those default flags (0) can be "unsafe":
> O_CLOEXEC must be used by default to not leak file descriptor
> across exec().
> 
> Instead of macro get_unused_fd(), functions anon_inode_getfd()
> or get_unused_fd_flags() should be used with flags given by userspace.
> If not possible, flags should be set to O_CLOEXEC to provide userspace
> with a default safe behavor.
> 
> In a further patch, get_unused_fd() will be removed so that
> new code start using anon_inode_getfd() or get_unused_fd_flags()
> with correct flags.
> 
> This patch replaces calls to get_unused_fd() with equivalent call to
> get_unused_fd_flags(0) to preserve current behavor for existing code.
> 
> The hard coded flag value (0) should be reviewed on a per-subsystem basis,
> and, if possible, set to O_CLOEXEC.
> 
> Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
>
> ---
>  fs/xfs/xfs_ioctl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 5e99968..dc5b659 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -248,7 +248,7 @@ xfs_open_by_handle(
>  		goto out_dput;
>  	}
>  
> -	fd = get_unused_fd();
> +	fd = get_unused_fd_flags(0);

O_CLOEXEC should be fine in this case.

Reviewed-by: Ben Myers <bpm@sgi.com>
