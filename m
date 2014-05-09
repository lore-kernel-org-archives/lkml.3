Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924AbaEIIH1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 04:07:27 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:44416 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755809AbaEIIHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 04:07:21 -0400
Date: Fri, 9 May 2014 11:07:06 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        nandu.hgowda@gmail.com, sachin.kamat@linaro.org,
        peter.p.waskiewicz.jr@intel.com, linux-kernel@vger.kernel.org,
        himangi774@gmail.com, fempsci@gmail.com
Subject: Re: [PATCH 2/3] Staging: cxt1e1: Fix line length over 80 characters
 in musycc.c
Message-ID: <20140509080706.GK26890@mwanda>
References: <20140509013948.GA30935@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140509013948.GA30935@devel.8.8.4.4>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is ok, but here are some additional hints.

On Fri, May 09, 2014 at 10:39:48AM +0900, Daeseok Youn wrote:
> @@ -1100,7 +1102,9 @@ musycc_bh_rx_eom(mpi_t *pi, int gchan)
>  			 */
>  			if (hdlcnum >= 228) {
>  				if (nciProcess_RX_packet)
> -					(*nciProcess_RX_packet) (hdlcnum, status & 0x3fff, m, ch->user);
> +					(*nciProcess_RX_packet)(hdlcnum, status &
> +								0x3fff, m,
> +								ch->user);

It's possible to break this one up at the commas.

					(*nciProcess_RX_packet)(hdlcnum,
								status & 0x3fff,
								m, ch->user);

>  			} else
>  #endif /* CONFIG_SBE_WAN256T3_NCOMM */
>  			{
> @@ -1379,7 +1383,8 @@ musycc_intr_bh_tasklet(ci_t *ci)
>  			else
>  				ci->iqd_p[headx] =
>  					__constant_cpu_to_le32(INT_EMPTY_ENTRY);
> -			ci->iqp_headx = (headx + 1) & (INT_QUEUE_SIZE - 1); /* insure wrapness */
> +			/* insure wrapness */
> +			ci->iqp_headx = (headx + 1) & (INT_QUEUE_SIZE - 1);
>  			FLUSH_MEM_WRITE();
>  			FLUSH_MEM_READ();
>  			continue;
> @@ -1516,7 +1521,8 @@ musycc_intr_bh_tasklet(ci_t *ci)
>  					pr_info("%s: RX buffer overflow [ONR] on channel %d, mode %x\n",
>  						ci->devname, ch->channum,
>  						ch->p.chan_mode);
> -					//musycc_dump_rxbuffer_ring (ch, 0);        /* RLD DEBUG */
> +					/* RLD DEBUG */
> +					//musycc_dump_rxbuffer_ring (ch, 0);

Just delete this commented out code.

>  				}
>  			}
>  			musycc_chan_restart(ch);
> @@ -1573,7 +1579,8 @@ musycc_intr_bh_tasklet(ci_t *ci)
>  		} /* switch on err */
>  
>  		/* Check for interrupt lost condition */
> -		if ((currInt & INTRPT_ILOST_M) && (cxt1e1_log_level >= LOG_ERROR))
> +		if ((currInt & INTRPT_ILOST_M) &&
> +		    (cxt1e1_log_level >= LOG_ERROR))
>  			pr_info("%s: Interrupt queue overflow - ILOST asserted\n",
>  				ci->devname);
>  		/* insure wrapness */
> @@ -1684,7 +1691,8 @@ musycc_del_chan(ci_t *ci, int channum)
>  {
>  	mch_t      *ch;
>  
> -	if ((channum < 0) || (channum >= (MUSYCC_NPORTS * MUSYCC_NCHANS)))  /* sanity chk param */
> +	/* sanity chk param */

This kind of comment is too obvious.  Just delete it.

> +	if ((channum < 0) || (channum >= (MUSYCC_NPORTS * MUSYCC_NCHANS)))
>  		return ECHRNG;
>  	ch = sd_find_chan(ci, channum);
>  	if (!ch)

regards,
dan carpenter
