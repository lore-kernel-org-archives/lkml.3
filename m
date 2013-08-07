Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932887Ab3HGR4g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 13:56:36 -0400
Received: from a9-42.smtp-out.amazonses.com ([54.240.9.42]:46967 "EHLO
	a9-42.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756071Ab3HGR4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 13:56:36 -0400
Date: Wed, 7 Aug 2013 17:56:34 +0000
From: Christoph Lameter <cl@gentwo.org>
To: Kent Overstreet <kmo@daterainc.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 04/10] idr: Percpu ida
In-Reply-To: <1375896905-6074-5-git-send-email-kmo@daterainc.com>
Message-ID: <0000014059ec4c34-1bb53d48-c9ee-4e71-81b8-253026431c5c-000000@email.amazonses.com>
References: <1375896905-6074-1-git-send-email-kmo@daterainc.com> <1375896905-6074-5-git-send-email-kmo@daterainc.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.08.07-54.240.9.42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Aug 2013, Kent Overstreet wrote:

> +{
> +	DEFINE_WAIT(wait);
> +	struct percpu_ida_cpu *tags;
> +	unsigned long flags;
> +	unsigned this_cpu;
> +	int tag;
> +
> +	local_irq_save(flags);

> +	this_cpu = smp_processor_id();
> +	tags = per_cpu_ptr(pool->tag_cpu, this_cpu);

tags = this_cpu_ptr(pool->tag_cpu);

> +		schedule();
> +
> +		local_irq_save(flags);
> +		this_cpu = smp_processor_id();
> +		tags = per_cpu_ptr(pool->tag_cpu, this_cpu);

And the same here.


> +void percpu_ida_free(struct percpu_ida *pool, unsigned tag)
> +{
> +	struct percpu_ida_cpu *tags;
> +	unsigned long flags;
> +	unsigned nr_free, this_cpu;
> +
> +	BUG_ON(tag >= pool->nr_tags);
> +
> +	local_irq_save(flags);
> +	this_cpu = smp_processor_id();
> +	tags = per_cpu_ptr(pool->tag_cpu, this_cpu);

And again


