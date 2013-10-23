Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387Ab3JWUtV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 16:49:21 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55210 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058Ab3JWUtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 16:49:20 -0400
Message-ID: <1382561354.5204.51.camel@smoke>
Subject: Re: [Cbe-oss-dev] [PATCH 2/8] cell: Remove OOM message after
 input_allocate_device
From: Geoff Levand <geoff@infradead.org>
To: Joe Perches <joe@perches.com>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, cbe-oss-dev@lists.ozlabs.org,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Date: Wed, 23 Oct 2013 13:49:14 -0700
In-Reply-To: <d4dc0be1a19693fca1d8d6bbd3a7ee75163cc269.1382555436.git.joe@perches.com>
References: <cover.1382555436.git.joe@perches.com>
	 <d4dc0be1a19693fca1d8d6bbd3a7ee75163cc269.1382555436.git.joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Wed, 2013-10-23 at 12:14 -0700, Joe Perches wrote:
> Emitting an OOM message isn't necessary after input_allocate_device
> as there's a generic OOM and a dump_stack already done.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  arch/powerpc/platforms/cell/cbe_powerbutton.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/powerpc/platforms/cell/cbe_powerbutton.c b/arch/powerpc/platforms/cell/cbe_powerbutton.c
> index 2bb8031..8804dbd 100644
> --- a/arch/powerpc/platforms/cell/cbe_powerbutton.c
> +++ b/arch/powerpc/platforms/cell/cbe_powerbutton.c
> @@ -58,7 +58,6 @@ static int __init cbe_powerbutton_init(void)
>  	dev = input_allocate_device();
>  	if (!dev) {
>  		ret = -ENOMEM;
> -		printk(KERN_ERR "%s: Not enough memory.\n", __func__);
>  		goto out;
>  	}

Arnd is out on leave, so I'll say that this looks OK.

Acked-by: Geoff Levand <geoff@infradead.org>



