Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173AbaETQpu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 12:45:50 -0400
Received: from smtprelay0087.hostedemail.com ([216.40.44.87]:33300 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932143AbaETQpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 12:45:49 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3871:3876:4321:5007:7652:7901:10004:10400:10848:11026:11232:11473:11658:11914:12043:12294:12438:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bone30_32135d6e5a704
X-Filterd-Recvd-Size: 1506
Message-ID: <1400604342.26709.2.camel@joe-AO725>
Subject: Re: [PATCH 1/1] drivers/s390/cio/qdio_main.c: replace shift loop by
 ilog2
From: Joe Perches <joe@perches.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Sebastian Ott <sebott@linux.vnet.ibm.com>,
        akpm <akpm@linux-foundation.org>
Date: Tue, 20 May 2014 09:45:42 -0700
In-Reply-To: <20140520183728.c28374c3f1a655a2e33996a3@skynet.be>
References: <20140520183728.c28374c3f1a655a2e33996a3@skynet.be>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-05-20 at 18:37 +0200, Fabian Frederick wrote:
> This is untested.
[]
> diff --git a/drivers/s390/cio/qdio_main.c b/drivers/s390/cio/qdio_main.c
[]
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

What guarantees count > 0 here?

count may be better unsigned.

