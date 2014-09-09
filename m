Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932228AbaIIH1B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 03:27:01 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:40604 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932136AbaIIH1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 03:27:00 -0400
Date: Tue, 9 Sep 2014 10:26:31 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Adrian Nicoara <anicoara@uwaterloo.ca>
Cc: shigekatsu.tateno@atmel.com, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] staging: ozwpan: use kmalloc_array over kmalloc
 with multiply
Message-ID: <20140909072631.GP6600@mwanda>
References: <20140908190249.GA17737@uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140908190249.GA17737@uwaterloo.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 03:02:49PM -0400, Adrian Nicoara wrote:
> Cleanup checkpatch.pl warnings.
> 
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

Still not lined up correctly.  The spacing should be:

		iface = kmalloc_array(num_iface, sizeof(struct oz_interface),
				      mem_flags | __GFP_ZERO);

[tab][tab][tab][tab][space][space][space][space][space][space]mem_flags...

regards,
dan carpenter

