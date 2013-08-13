Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758421Ab3HMX3M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 19:29:12 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:63158 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756090Ab3HMX3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 19:29:10 -0400
Date: Tue, 13 Aug 2013 19:29:04 -0400
From: Tejun Heo <tj@kernel.org>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: Re: [PATCH v7 2/2] mm: make lru_add_drain_all() selective
Message-ID: <20130813232904.GJ28996@mtj.dyndns.org>
References: <520AAF9C.1050702@tilera.com>
 <201308132307.r7DN74M5029053@farm-0021.internal.tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201308132307.r7DN74M5029053@farm-0021.internal.tilera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Aug 13, 2013 at 06:53:32PM -0400, Chris Metcalf wrote:
>  int lru_add_drain_all(void)
>  {
> -	return schedule_on_each_cpu(lru_add_drain_per_cpu);
> +	return schedule_on_each_cpu_cond(lru_add_drain_per_cpu,
> +					 lru_add_drain_cond, NULL);

It won't nest and doing it simultaneously won't buy anything, right?
Wouldn't it be better to protect it with a mutex and define all
necessary resources statically (yeah, cpumask is pain in the ass and I
think we should un-deprecate cpumask_t for static use cases)?  Then,
there'd be no allocation to worry about on the path.

Thanks.

-- 
tejun
