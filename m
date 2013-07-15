Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab3GOSMY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 14:12:24 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:41956 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751901Ab3GOSMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 14:12:23 -0400
Message-ID: <1373911942.2062.24.camel@joe-AO722>
Subject: Re: [PATCH BUGFIX] pkt_sched: sch_qfq: remove a source of high
 packet delay/jitter
From: Joe Perches <joe@perches.com>
To: Paolo Valente <paolo.valente@unimore.it>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S. Miller" <davem@davemloft.net>, shemminger@vyatta.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        fchecconi@gmail.com, rizzo@iet.unipi.it
Date: Mon, 15 Jul 2013 11:12:22 -0700
In-Reply-To: <1373911290-6237-1-git-send-email-paolo.valente@unimore.it>
References: <1373911290-6237-1-git-send-email-paolo.valente@unimore.it>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-15 at 20:01 +0200, Paolo Valente wrote:
> QFQ+ inherits from QFQ a design choice that may cause a high packet
> delay/jitter and a severe short-term unfairness.
[]
> diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
[]
> @@ -189,6 +188,7 @@ struct qfq_sched {
>  	struct qfq_aggregate	*in_serv_agg;   /* Aggregate being served. */
>  	u32			num_active_agg; /* Num. of active aggregates */
>  	u32			wsum;		/* weight sum */
> +	unsigned long		iwsum;		/* inverse weight sum*/

This is a different size for 32/64 bit compiles
and may be better as u32.

