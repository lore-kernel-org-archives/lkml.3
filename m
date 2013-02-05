Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab3BEQsX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 11:48:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10364 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754626Ab3BEQsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 11:48:21 -0500
Date: Tue, 5 Feb 2013 11:48:17 -0500
From: Peter Jones <pjones@redhat.com>
To: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/2] export unpack_to_rootfs
Message-ID: <20130205164817.GD2335@fenchurch.internal.datastacks.com>
References: <cover.1360067333.git.dmitry.kasatkin@intel.com>
 <7fe9b3a51f3b7172fcb85721cea9162f840aaaa6.1360067333.git.dmitry.kasatkin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7fe9b3a51f3b7172fcb85721cea9162f840aaaa6.1360067333.git.dmitry.kasatkin@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2013 at 02:34:49PM +0200, Dmitry Kasatkin wrote:
> Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
> ---
>  init/do_mounts.h |    2 ++
>  init/initramfs.c |    2 +-
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/init/do_mounts.h b/init/do_mounts.h
> index f5b978a..11829eb 100644
> --- a/init/do_mounts.h
> +++ b/init/do_mounts.h
> @@ -74,3 +74,5 @@ void md_run_setup(void);
>  static inline void md_run_setup(void) {}
>  
>  #endif
> +
> +char * __init unpack_to_rootfs(char *buf, unsigned len);
> diff --git a/init/initramfs.c b/init/initramfs.c
> index 84c6bf1..e32bc06 100644
> --- a/init/initramfs.c
> +++ b/init/initramfs.c
> @@ -421,7 +421,7 @@ static unsigned my_inptr;   /* index of next byte to be processed in inbuf */
>  
>  #include <linux/decompress/generic.h>
>  
> -static char * __init unpack_to_rootfs(char *buf, unsigned len)
> +char * __init unpack_to_rootfs(char *buf, unsigned len)
>  {
>  	int written, res;
>  	decompress_fn decompress;

Doing this unconditionally seems to be inviting rootkit authors to use a
new and shiny tool.  I also don't think it's the best way to do this,
but I'll comment on the other patch to explain why.

-- 
        Peter
