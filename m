Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab3COAt6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 20:49:58 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:33155 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732Ab3COAt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 20:49:57 -0400
Message-ID: <1363308584.3194.124.camel@thor.lan>
Subject: Re: [RFC PATCH] Linux kernel Wait-Free Concurrent Queue
 Implementation
From: Peter Hurley <peter@hurleysoftware.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Eric Wong <normalperson@yhbt.net>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Davide Libenzi <davidel@xmailserver.org>, linux-kernel@vger.kernel.org
Date: Thu, 14 Mar 2013 20:49:44 -0400
In-Reply-To: <20130311213602.GB9829@Krystal>
References: <20130311213602.GB9829@Krystal>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-11 at 17:36 -0400, Mathieu Desnoyers wrote:
> +/*
> + * Do not put head and tail on the same cache-line if concurrent
> + * enqueue/dequeue are expected from many CPUs. This eliminates
> + * false-sharing between enqueue and dequeue.
> + */
> +struct wfcq_head {
> +	struct wfcq_node node;
> +	struct mutex lock;
> +};
> +
> +struct wfcq_tail {
> +	struct wfcq_node *p;
> +};


If you want to force separate cachelines for SMP, this would be

struct wfcq_head {
	struct wfcq_node node;
	struct mutex lock;
} ____cacheline_aligned_in_smp;

struct wfcq_tail {
	struct wfcq_node *p;
} ____cacheline_aligned_in_smp;

