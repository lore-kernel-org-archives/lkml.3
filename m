Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825AbaEaUkJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 16:40:09 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:44997 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165AbaEaUkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 16:40:06 -0400
Date: Sat, 31 May 2014 23:36:58 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: Samuel Ortiz <samuel@sortiz.org>, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/11] via-ircc: Remove useless return variables
Message-ID: <20140531203658.GO15585@mwanda>
References: <1401542051-3174-4-git-send-email-peter.senna@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401542051-3174-4-git-send-email-peter.senna@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 31, 2014 at 10:14:04AM -0300, Peter Senna Tschudin wrote:
> This patch remove variables that are initialized with a constant,
> are never updated, and are only used as parameter of return.
> Return the constant instead of using a variable.
> 
> Verified by compilation only.
> 
> The coccinelle script that find and fixes this issue is:
> // <smpl>
> @@
> type T;
> constant C;
> identifier ret;
> @@
> - T ret = C;
> ... when != ret
>     when strict
> return
> - ret
> + C
> ;
> // </smpl>
> 
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
> 
> ---
>  drivers/net/irda/via-ircc.c |    9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/irda/via-ircc.c b/drivers/net/irda/via-ircc.c
> index 2900af0..3fde116 100644
> --- a/drivers/net/irda/via-ircc.c
> +++ b/drivers/net/irda/via-ircc.c
> @@ -509,11 +509,9 @@ static void via_hw_init(struct via_ircc_cb *self)
>   *
>   */
>  static int via_ircc_read_dongle_id(int iobase)
> -{
> -	int dongle_id = 9;	/* Default to IBM */
> -
> +{/* Default to IBM */

Yuck.  And anyway, the comment should be on return line.  (And of course
there should have been a #define IBM_DONGLE_ID 9, but that's probably
something for another patch.

>  	IRDA_ERROR("via-ircc: dongle probing not supported, please specify dongle_id module parameter.\n");
> -	return dongle_id;
> +	return 9;

So put the comment here.

	return 9;  /* Everything is an IBM */
>  }
>  

regards,
dan carpenter

