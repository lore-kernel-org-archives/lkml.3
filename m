Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681AbaFDOVJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 10:21:09 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:58014 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485AbaFDOVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 10:21:06 -0400
Date: Wed, 4 Jun 2014 16:21:01 +0200 (CEST)
From: Sebastian Ott <sebott@linux.vnet.ibm.com>
X-X-Sender: sebott@denkbrett
To: Fabian Frederick <fabf@skynet.be>
cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH V2 2/2] drivers/s390/cio/qdio_main.c: replace shift loop
 by ilog2
In-Reply-To: <1401825315-5845-1-git-send-email-fabf@skynet.be>
Message-ID: <alpine.LFD.2.11.1406041620170.21183@denkbrett>
References: <1401825315-5845-1-git-send-email-fabf@skynet.be>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
Organization: =?ISO-8859-15?Q?=22IBM_Deutschland_Research_&_Development_GmbH_=2F_Vorsitzende_des_Aufsichtsrats=3A_Martina_Koederitz_Gesch=E4ftsf=FChrung=3A_Dirk_Wittkopp_Sitz_der_Gesellschaft=3A_B=F6blingen_=2F_Registergericht?=
 =?ISO-8859-15?Q?=3A_Amtsgericht_Stuttgart=2C_HRB_243294=22?=
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060414-8372-0000-0000-00000014AECF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jun 2014, Fabian Frederick wrote:
> account_sbals is called by get_inbound_buffer_frontier and
> get_outbound_buffer_frontier with 'count' value > 0 so we can safely convert
> shift loop to ilog2.
> 
> Cc: Sebastian Ott <sebott@linux.vnet.ibm.com>
> Cc: Joe Perches <joe@perches.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  drivers/s390/cio/qdio_main.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/s390/cio/qdio_main.c b/drivers/s390/cio/qdio_main.c
> index 9fda160..2eee7f1 100644
> --- a/drivers/s390/cio/qdio_main.c
> +++ b/drivers/s390/cio/qdio_main.c
> @@ -413,15 +413,14 @@ static inline void qdio_stop_polling(struct qdio_q *q)
> 
>  static inline void account_sbals(struct qdio_q *q, unsigned int count)
>  {
> -	int pos = 0;
> +	int pos;
> 
>  	q->q_stats.nr_sbal_total += count;
>  	if (count == QDIO_MAX_BUFFERS_MASK) {
>  		q->q_stats.nr_sbals[7]++;
>  		return;
>  	}
> -	while (count >>= 1)
> -		pos++;
> +	pos = ilog2(count);
>  	q->q_stats.nr_sbals[pos]++;
>  }
> 
> -- 
> 1.8.4.5
> 
> 

Thanks, applied.
Sebastian

