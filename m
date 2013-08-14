Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932990Ab3HNQ5h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 12:57:37 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:58122 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932867Ab3HNQ5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 12:57:36 -0400
Date: Wed, 14 Aug 2013 12:57:23 -0400
From: Tejun Heo <tj@kernel.org>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: Re: [PATCH v7 2/2] mm: make lru_add_drain_all() selective
Message-ID: <20130814165723.GE28628@htj.dyndns.org>
References: <520AAF9C.1050702@tilera.com>
 <201308132307.r7DN74M5029053@farm-0021.internal.tilera.com>
 <20130813232904.GJ28996@mtj.dyndns.org>
 <520AC215.4050803@tilera.com>
 <20130813234629.4ce2ec70.akpm@linux-foundation.org>
 <520BAA5B.9070407@tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520BAA5B.9070407@tilera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Chris.

On Wed, Aug 14, 2013 at 12:03:39PM -0400, Chris Metcalf wrote:
> Tejun, I don't know if you have a better idea for how to mark a
> work_struct as being "not used" so we can set and test it here.
> Is setting entry.next to NULL good?  Should we offer it as an API
> in the workqueue header?

Maybe simply defining a static cpumask would be cleaner?

> We could wrap the whole thing in a new workqueue API too, of course
> (schedule_on_each_cpu_cond_sequential??) but it seems better at this
> point to wait until we find another caller with similar needs, and only
> then factor the code into a new workqueue API.

We can have e.g. __schedule_on_cpu(fn, pcpu_works) but yeah it seems a
bit excessive at this point.

Thanks.

-- 
tejun
