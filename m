Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab3AUTr0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 14:47:26 -0500
Received: from webmail.solarflare.com ([12.187.104.25]:10357 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab3AUTrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 14:47:24 -0500
Message-ID: <1358797641.3758.4.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [PATCH 4/15] drivers/net/ethernet/sfc/ptp.c: adjust duplicate
 test
From: Ben Hutchings <bhutchings@solarflare.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
CC: Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        <kernel-janitors@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Date: Mon, 21 Jan 2013 19:47:21 +0000
In-Reply-To: <1358773378-4700-5-git-send-email-Julia.Lawall@lip6.fr>
References: <1358773378-4700-1-git-send-email-Julia.Lawall@lip6.fr>
	 <1358773378-4700-5-git-send-email-Julia.Lawall@lip6.fr>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-19570.005
X-TM-AS-Result: No--15.291900-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-21 at 14:02 +0100, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Delete successive tests to the same location.  rc was previously tested and
> not subsequently updated.  efx_phc_adjtime can return an error code, so the
> call is updated so that is tested instead.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @s exists@
> local idexpression y;
> expression x,e;
> @@
> 
> *if ( \(x == NULL\|IS_ERR(x)\|y != 0\) )
>  { ... when forall
>    return ...; }
> ... when != \(y = e\|y += e\|y -= e\|y |= e\|y &= e\|y++\|y--\|&y\)
>     when != \(XT_GETPAGE(...,y)\|WMI_CMD_BUF(...)\)
> *if ( \(x == NULL\|IS_ERR(x)\|y != 0\) )
>  { ... when forall
>    return ...; }
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Acked-by: Ben Hutchings <bhutchings@solarflare.com>

> ---
> Not tested.  I'm not familiar with this function, so I don't know whether it
> is desirable to test its result.

Yes, the result should be tested.  Thanks.

Ben.

>  drivers/net/ethernet/sfc/ptp.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
> index 0767043..3f93624 100644
> --- a/drivers/net/ethernet/sfc/ptp.c
> +++ b/drivers/net/ethernet/sfc/ptp.c
> @@ -1439,7 +1439,7 @@ static int efx_phc_settime(struct ptp_clock_info *ptp,
>  
>  	delta = timespec_sub(*e_ts, time_now);
>  
> -	efx_phc_adjtime(ptp, timespec_to_ns(&delta));
> +	rc = efx_phc_adjtime(ptp, timespec_to_ns(&delta));
>  	if (rc != 0)
>  		return rc;
>  
> 

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

