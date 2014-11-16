Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbaKPRL6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 12:11:58 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:49970 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755217AbaKPRL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 12:11:56 -0500
Date: Sun, 16 Nov 2014 17:11:48 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Igor Bogomazov <ygrex@ygrex.ru>
Cc: linux-kernel@vger.kernel.org, HPDD-discuss@ml01.01.org,
        devel@driverdev.osuosl.org, Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] staging: lustre: socklnd: sparse warning fix
Message-ID: <20141116171148.GR7996@ZenIV.linux.org.uk>
References: <20141116173355.292a6d4a@ygrex-lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141116173355.292a6d4a@ygrex-lenovo>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> the same value casted the same way few lines below:
> 	csum = ksocknal_csum(~0, (void *)tx->tx_iov[0].iov_base,
> 
> then it seems like a typo in LASSERT() that is got fixed
> 
>  drivers/staging/lustre/lnet/klnds/socklnd/socklnd_lib-linux.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_lib-linux.c b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_lib-linux.c
> index 245c9d7..ebd400d 100644
> --- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_lib-linux.c
> +++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_lib-linux.c
> @@ -390,7 +390,7 @@ ksocknal_lib_csum_tx(ksock_tx_t *tx)
>  	__u32	csum;
>  	void	*base;
>  
> -	LASSERT(tx->tx_iov[0].iov_base == (void *)&tx->tx_msg);
> +	LASSERT((void *)tx->tx_iov[0].iov_base == &tx->tx_msg);

Turn tx_iov into struct kvec * instead.
