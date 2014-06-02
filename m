Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbaFBOly (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 10:41:54 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:43095 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754693AbaFBOlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 10:41:53 -0400
Date: Mon, 2 Jun 2014 16:41:48 +0200 (CEST)
From: Sebastian Ott <sebott@linux.vnet.ibm.com>
X-X-Sender: sebott@denkbrett
To: Fabian Frederick <fabf@skynet.be>
cc: linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] drivers/s390/cio/qdio_main.c: replace shift loop by
 ilog2
In-Reply-To: <20140520183728.c28374c3f1a655a2e33996a3@skynet.be>
Message-ID: <alpine.LFD.2.11.1406021637300.1587@denkbrett>
References: <20140520183728.c28374c3f1a655a2e33996a3@skynet.be>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
Organization: =?ISO-8859-15?Q?=22IBM_Deutschland_Research_&_Development_GmbH_=2F_Vorsitzende_des_Aufsichtsrats=3A_Martina_Koederitz_Gesch=E4ftsf=FChrung=3A_Dirk_Wittkopp_Sitz_der_Gesellschaft=3A_B=F6blingen_=2F_Registergericht?=
 =?ISO-8859-15?Q?=3A_Amtsgericht_Stuttgart=2C_HRB_243294=22?=
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060214-0542-0000-0000-000009457C5C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Fabian,

On Tue, 20 May 2014, Fabian Frederick wrote:
> 
> This is untested.
> 
> Cc: Sebastian Ott <sebott@linux.vnet.ibm.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  drivers/s390/cio/qdio_main.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/s390/cio/qdio_main.c b/drivers/s390/cio/qdio_main.c
> index 77466c4..8bf9ec1 100644
> --- a/drivers/s390/cio/qdio_main.c
> +++ b/drivers/s390/cio/qdio_main.c
> @@ -411,15 +411,14 @@ static inline void qdio_stop_polling(struct qdio_q *q)
> 
>  static inline void account_sbals(struct qdio_q *q, int count)
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

Could you please resend the patch with a better description plus
the change Joe suggested.

Thanks,
Sebastian

