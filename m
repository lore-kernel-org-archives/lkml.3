Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392AbaJHWsR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 18:48:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51522 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719AbaJHWsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 18:48:16 -0400
Date: Wed, 8 Oct 2014 15:48:16 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dzmitry Sledneu <dzmitry.sledneu@gmail.com>
Cc: Joe Perches <joe@perches.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] staging: gs_fpgaboot: Fix "Possible unnecessary
 'out of memory' message" checkpatch.pl warning
Message-ID: <20141008224816.GA3583@kroah.com>
References: <5433FA93.8000607@gmail.com>
 <5433FB18.9000009@gmail.com>
 <54340568.7090700@gmail.com>
 <1412695842.2916.49.camel@joe-AO725>
 <54340C70.9070505@gmail.com>
 <54340CC8.8070903@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54340CC8.8070903@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 05:54:48PM +0200, Dzmitry Sledneu wrote:
> Fix "Possible unnecessary 'out of memory' message" checkpatch.pl warning
> 
> Signed-off-by: Dzmitry Sledneu <dzmitry.sledneu@gmail.com>
> 
> ---
>  drivers/staging/gs_fpgaboot/gs_fpgaboot.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/gs_fpgaboot/gs_fpgaboot.c b/drivers/staging/gs_fpgaboot/gs_fpgaboot.c
> index 9764a9a..0c18c4c 100644
> --- a/drivers/staging/gs_fpgaboot/gs_fpgaboot.c
> +++ b/drivers/staging/gs_fpgaboot/gs_fpgaboot.c
> @@ -295,10 +295,8 @@ static int gs_fpgaboot(void)
>  	struct fpgaimage	*fimage;
>  
>  	fimage = kmalloc(sizeof(struct fpgaimage), GFP_KERNEL);
> -	if (fimage == NULL) {
> -		pr_err("No memory is available\n");
> -		goto err_out;
> -	}
> +	if (!fimage)
> +		return -ENOMEM;
>  
>  	err = gs_load_image(fimage, file);
>  	if (err) {
> @@ -340,7 +338,6 @@ err_out2:
>  err_out1:
>  	kfree(fimage);
>  
> -err_out:
>  	return -1;
>  
>  }

Doesn't apply to my tree properly :(
