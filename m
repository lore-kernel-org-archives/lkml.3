Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751203AbaALXGW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 18:06:22 -0500
Received: from gate.crashing.org ([63.228.1.57]:56388 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026AbaALXGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 18:06:18 -0500
Message-ID: <1389567961.4672.111.camel@pasglop>
Subject: Re: [PATCH 02/13] ppc/cell: use get_unused_fd_flags(0) instead of
 get_unused_fd()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yann Droneaud <ydroneaud@opteya.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        cbe-oss-dev@lists.ozlabs.org
Date: Mon, 13 Jan 2014 10:06:01 +1100
In-Reply-To: <72f6f9ae898a664033f6b958bc7976b994544963.1372777600.git.ydroneaud@opteya.com>
References: <cover.1372777600.git.ydroneaud@opteya.com>
	 <72f6f9ae898a664033f6b958bc7976b994544963.1372777600.git.ydroneaud@opteya.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-02 at 18:39 +0200, Yann Droneaud wrote:
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

Should I merge this (v5 on patchwork) or let Al do it ?

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

> ---
>  arch/powerpc/platforms/cell/spufs/inode.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/powerpc/platforms/cell/spufs/inode.c b/arch/powerpc/platforms/cell/spufs/inode.c
> index f390042..88df441 100644
> --- a/arch/powerpc/platforms/cell/spufs/inode.c
> +++ b/arch/powerpc/platforms/cell/spufs/inode.c
> @@ -301,7 +301,7 @@ static int spufs_context_open(struct path *path)
>  	int ret;
>  	struct file *filp;
>  
> -	ret = get_unused_fd();
> +	ret = get_unused_fd_flags(0);
>  	if (ret < 0)
>  		return ret;
>  
> @@ -518,7 +518,7 @@ static int spufs_gang_open(struct path *path)
>  	int ret;
>  	struct file *filp;
>  
> -	ret = get_unused_fd();
> +	ret = get_unused_fd_flags(0);
>  	if (ret < 0)
>  		return ret;
>  


