Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbaK3T7t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 14:59:49 -0500
Received: from mail-ig0-f180.google.com ([209.85.213.180]:34757 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbaK3T7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 14:59:46 -0500
Message-ID: <1417377583.4442.11.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH 3/3] net-PPP: Delete an unnecessary assignment
From: Eric Dumazet <eric.dumazet@gmail.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Paul Mackerras <paulus@samba.org>, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
Date: Sun, 30 Nov 2014 11:59:43 -0800
In-Reply-To: <547B4A35.7000500@users.sourceforge.net>
References: <5307CAA2.8060406@users.sourceforge.net>
	 <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6>
	 <530A086E.8010901@users.sourceforge.net>
	 <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6>
	 <530A72AA.3000601@users.sourceforge.net>
	 <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>
	 <530B5FB6.6010207@users.sourceforge.net>
	 <alpine.DEB.2.10.1402241710370.2074@hadrien>
	 <530C5E18.1020800@users.sourceforge.net>
	 <alpine.DEB.2.10.1402251014170.2080@hadrien>
	 <530CD2C4.4050903@users.sourceforge.net>
	 <alpine.DEB.2.10.1402251840450.7035@hadrien>
	 <530CF8FF.8080600@users.sourceforge.net>
	 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
	 <530DD06F.4090703@users.sourceforge.net>
	 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
	 <5317A59D.4@users.sourceforge.net> <547B4886.4080406@users.sourceforge.net>
	 <547B4A35.7000500@users.sourceforge.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-11-30 at 17:47 +0100, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sun, 30 Nov 2014 17:17:36 +0100
> 
> The data structure element "arc4" was assigned a null pointer by the
> mppe_alloc() function if a previous function call "crypto_alloc_blkcipher"
> failed. This assignment became unnecessary with previous source
> code adjustments.
> Let us delete it from the affected implementation because the element "arc4"
> will not be accessible outside the function after the detected
> allocation failure.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/net/ppp/ppp_mppe.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ppp/ppp_mppe.c b/drivers/net/ppp/ppp_mppe.c
> index 962c1a0..d913bc9 100644
> --- a/drivers/net/ppp/ppp_mppe.c
> +++ b/drivers/net/ppp/ppp_mppe.c
> @@ -205,10 +205,8 @@ static void *mppe_alloc(unsigned char *options, int optlen)
>  
> 
>  	state->arc4 = crypto_alloc_blkcipher("ecb(arc4)", 0, CRYPTO_ALG_ASYNC);
> -	if (IS_ERR(state->arc4)) {
> -		state->arc4 = NULL;
> +	if (IS_ERR(state->arc4))
>  		goto out_free;
> -	}
>  
>  	state->sha1 = crypto_alloc_hash("sha1", 0, CRYPTO_ALG_ASYNC);
>  	if (IS_ERR(state->sha1)) {

I have no idea why its a patch on its own, and why state->arc4 gets
special treatment while state->sha1 does not.

This definitely belongs to the previous patch, refactoring error
handling in mppe_alloc()

Also, it seems your patches do not fix bugs, so so you need to target
net-next tree, as explained in Documentation/networking/netdev-FAQ.txt



