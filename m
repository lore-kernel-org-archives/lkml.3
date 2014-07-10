Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877AbaGJAaE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 20:30:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49508 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766AbaGJAaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 20:30:03 -0400
Date: Wed, 9 Jul 2014 17:34:28 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Sumit Semwal <sumit.semwal@linaro.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] drivers/base/dma-buf.c: replace
 dma_buf_uninit_debugfs by debugfs_remove_recursive
Message-ID: <20140710003428.GA22113@kroah.com>
References: <1403901130-8156-1-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403901130-8156-1-git-send-email-fabf@skynet.be>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 10:32:10PM +0200, Fabian Frederick wrote:
> null test before debugfs_remove_recursive is not needed so one line function
> dma_buf_uninit_debugfs can be removed.
> 
> This patch calls debugfs_remove_recursive under CONFIG_DEBUG_FS
> 
> Cc: Sumit Semwal <sumit.semwal@linaro.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: linux-media@vger.kernel.org
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
> 
> This is untested.
> 
>  drivers/base/dma-buf.c | 13 +++----------
>  1 file changed, 3 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
> index 840c7fa..184c0cb 100644
> --- a/drivers/base/dma-buf.c
> +++ b/drivers/base/dma-buf.c
> @@ -701,12 +701,6 @@ static int dma_buf_init_debugfs(void)
>  	return err;
>  }
>  
> -static void dma_buf_uninit_debugfs(void)
> -{
> -	if (dma_buf_debugfs_dir)
> -		debugfs_remove_recursive(dma_buf_debugfs_dir);
> -}
> -
>  int dma_buf_debugfs_create_file(const char *name,
>  				int (*write)(struct seq_file *))
>  {
> @@ -722,9 +716,6 @@ static inline int dma_buf_init_debugfs(void)
>  {
>  	return 0;
>  }
> -static inline void dma_buf_uninit_debugfs(void)
> -{
> -}
>  #endif
>  
>  static int __init dma_buf_init(void)
> @@ -738,6 +729,8 @@ subsys_initcall(dma_buf_init);
>  
>  static void __exit dma_buf_deinit(void)
>  {
> -	dma_buf_uninit_debugfs();
> +#ifdef CONFIG_DEBUG_FS
> +	debugfs_remove_recursive(dma_buf_debugfs_dir);
> +#endif

That ifdef should not be needed at all, right?  No ifdefs should be
needed for debugfs code, if it is written correctly :)

thanks,

greg k-h
