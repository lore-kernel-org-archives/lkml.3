Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932557AbaKRWR1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 17:17:27 -0500
Received: from relay.variantweb.net ([104.131.199.242]:53846 "EHLO
	relay.variantweb.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932254AbaKRWR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 17:17:26 -0500
Date: Tue, 18 Nov 2014 16:17:20 -0600
From: Seth Jennings <sjennings@variantweb.net>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, Coccinelle <cocci@systeme.lip6.fr>
Subject: Re: [PATCH 1/1] mm/zswap: Deletion of an unnecessary check before
 the function call "free_percpu"
Message-ID: <20141118221720.GA20945@cerebellum.variantweb.net>
References: <530C5E18.1020800@users.sourceforge.net>
 <alpine.DEB.2.10.1402251014170.2080@hadrien>
 <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net>
 <546A3302.9040804@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546A3302.9040804@users.sourceforge.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 06:40:18PM +0100, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Mon, 17 Nov 2014 18:33:33 +0100
> 
> The free_percpu() function tests whether its argument is NULL and then
> returns immediately. Thus the test around the call is not needed.
> 
> This issue was detected by using the Coccinelle software.

Thanks for the cleanup!

Acked-by: Seth Jennings <sjennings@variantweb.net>

> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  mm/zswap.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index ea064c1..35629f0 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -152,8 +152,7 @@ static int __init zswap_comp_init(void)
>  static void zswap_comp_exit(void)
>  {
>  	/* free percpu transforms */
> -	if (zswap_comp_pcpu_tfms)
> -		free_percpu(zswap_comp_pcpu_tfms);
> +	free_percpu(zswap_comp_pcpu_tfms);
>  }
>  
>  /*********************************
> -- 
> 2.1.3
> 
