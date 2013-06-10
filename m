Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914Ab3FJXDA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 19:03:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33105 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab3FJXC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 19:02:59 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=wskK765KtKEA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=GqmPQ3klG2UA:10 a=-zKhaEYkIxt2RWRnXCUA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1370905376.9844.137.camel@gandalf.local.home>
Subject: Re: [PATCH RFC ticketlock] Auto-queued ticketlock
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, torvalds@linux-foundation.org
Date: Mon, 10 Jun 2013 19:02:56 -0400
In-Reply-To: <20130609193657.GA13392@linux.vnet.ibm.com>
References: <20130609193657.GA13392@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-06-09 at 12:36 -0700, Paul E. McKenney wrote:

> +/*
> + * Return a pointer to the queue header associated with the specified lock,
> + * or return NULL if there is no queue for the lock or if the lock's queue
> + * is in transition.
> + */
> +static struct tkt_q_head *tkt_q_find_head(arch_spinlock_t *asp)

BTW, what does "asp" mean? arch_spinlock?  If so, can we just call it
"lock" and be consistent with all the other spinlock calls in the
kernel. Because, I keep thinking this has something to do with Microsoft
dynamic web pages.

-- Steve

> +{
> +	int i;
> +	int start;
> +
> +	start = i = tkt_q_hash(asp);
> +	do
> +		if (tkt_q_heads[i].ref == asp)
> +			return &tkt_q_heads[i];
> +	while ((i = tkt_q_next_slot(i)) != start);
> +	return NULL;
> +}
> +


