Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590AbaJIM2y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 08:28:54 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:34821 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbaJIM2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 08:28:46 -0400
Date: Thu, 9 Oct 2014 17:58:31 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: WANG Chao <wangchao19890207@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Masaru Nomura <massa.nomura@gmail.com>, Peng Tao <bergwolf@gmail.com>,
        Chi Pham <fempsci@gmail.com>,
        Fredrick John Berchmans <fredrickprashanth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH resend] staging, lustre: fix a sparse error
Message-ID: <20141009122831.GA3300@sudip-PC>
References: <1412850311-5727-1-git-send-email-wangchao19890207@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412850311-5727-1-git-send-email-wangchao19890207@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2014 at 06:25:10PM +0800, WANG Chao wrote:
> This fixes the following sparse error:
> 
> drivers/staging/lustre/lnet/klnds/socklnd/socklnd_lib-linux.c:393:9: error:
> incompatible types in comparison expression (different address spaces)
> 
> Signed-off-by: WANG Chao <wangchao19890207@gmail.com>
> ---
>  drivers/staging/lustre/lnet/klnds/socklnd/socklnd_lib-linux.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_lib-linux.c b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_lib-linux.c
> index 245c9d7..1510594 100644
> --- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_lib-linux.c
> +++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_lib-linux.c
> @@ -390,7 +390,7 @@ ksocknal_lib_csum_tx(ksock_tx_t *tx)
>  	__u32	csum;
>  	void	*base;
>  
> -	LASSERT(tx->tx_iov[0].iov_base == (void *)&tx->tx_msg);
> +	LASSERT((void __force *) tx->tx_iov[0].iov_base == (void *)&tx->tx_msg);
is it ok? are you not just suppressing the sparse error?
iov_base is void __user *  

thanks
sudip

>  	LASSERT(tx->tx_conn != NULL);
>  	LASSERT(tx->tx_conn->ksnc_proto == &ksocknal_protocol_v2x);
>  
> -- 
> 1.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
