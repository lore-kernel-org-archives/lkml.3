Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939Ab3FCNf2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 09:35:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34674 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757274Ab3FCNfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 09:35:24 -0400
Date: Mon, 3 Jun 2013 15:36:19 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH RFC -tip 0/6] perf: IRQ-bound performance events
Message-ID: <20130603133618.GK30878@dhcp-26-207.brq.redhat.com>
References: <20130603094132.GB30878@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130603094132.GB30878@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 11:41:32AM +0200, Alexander Gordeev wrote:
> # ./tools/perf/perf stat -I 8 -a -e L1-dcache-load-misses:k sleep 1
> 
>  Performance counter stats for process id '8':
> 
>                  0 L1-dcache-load-misses                                       
> 
>        1.001235781 seconds time elapsed
> 
> # ./tools/perf/perf stat -I 8 -a -e L1-dcache-load-misses:k hwclock --test
> Mon 03 Jun 2013 04:42:59 AM EDT  -0.891274 seconds
> 
>  Performance counter stats for process id '8':

Oops, the most interesting part did not make it in. Very sorry :) Here:

# ./tools/perf/perf stat -I 8 -a -e L1-dcache-load-misses:k hwclock --test
Mon 03 Jun 2013 09:32:49 AM EDT  -0.719514 seconds

 Performance counter stats for process id '8':

               447 L1-dcache-load-misses                                       

       0.720874208 seconds time elapsed


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
