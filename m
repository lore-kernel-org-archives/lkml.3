Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013AbaIIHXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 03:23:46 -0400
Received: from sym2.noone.org ([178.63.92.236]:50451 "EHLO sym2.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755571AbaIIHXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 03:23:45 -0400
Date: Tue, 9 Sep 2014 09:23:41 +0200
From: Tobias Klauser <tklauser@distanz.ch>
To: Adrian Nicoara <anicoara@uwaterloo.ca>
Cc: shigekatsu.tateno@atmel.com, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] staging: ozwpan: use kmalloc_array over kmalloc
 with multiply
Message-ID: <20140909072341.GE3578@distanz.ch>
References: <20140908190249.GA17737@uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140908190249.GA17737@uwaterloo.ca>
X-Editor: Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-09-08 at 21:02:49 +0200, Adrian Nicoara <anicoara@uwaterloo.ca> wrote:
> Cleanup checkpatch.pl warnings.

Please state which warning this is fixing. Same goes for patches 1-3.

> Signed-off-by: Adrian Nicoara <anicoara@uwaterloo.ca>
> ---
> 
> Somehow I missed the comment Tobias made on the line indentation. I fixed the
> patch, and added here as a reply - the previous patch should be ignored.
> 
>  drivers/staging/ozwpan/ozhcd.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
> index ba2168f..e880452 100644
> --- a/drivers/staging/ozwpan/ozhcd.c
> +++ b/drivers/staging/ozwpan/ozhcd.c
> @@ -1315,8 +1315,8 @@ static int oz_build_endpoints_for_config(struct usb_hcd *hcd,
>  	if (num_iface) {
>  		struct oz_interface *iface;
> 
> -		iface = kmalloc(num_iface*sizeof(struct oz_interface),
> -				mem_flags | __GFP_ZERO);
> +		iface = kmalloc_array(num_iface, sizeof(struct oz_interface),
> +					mem_flags | __GFP_ZERO);

This still isn't entirely correct. It should rather look like this:

		iface = kmalloc_array(num_iface, sizeof(struct oz_interface),
				      mem_flags | __GFP_ZERO);

Assume a tab width of 8 (as per CodingStyle) and use spaces to get the
alignment right.

>  		if (!iface)
>  			return -ENOMEM;
>  		spin_lock_bh(&ozhcd->hcd_lock);
> --
> 2.0.1
> 
