Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101Ab3KNI7Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 03:59:24 -0500
Received: from mailout1.zih.tu-dresden.de ([141.30.67.72]:52648 "EHLO
	mailout1.zih.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751284Ab3KNI7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 03:59:22 -0500
Message-ID: <528490DE.4080204@tu-dresden.de>
Date: Thu, 14 Nov 2013 09:59:10 +0100
From: Joseph Schuchart <joseph.schuchart@tu-dresden.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        thomas.ilsche@tu-dresden.de, linux-kernel@vger.kernel.org,
        Fr??d??ric Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH] Perf: Correct Assumptions about Sample Timestamps in
 Passes
References: <528484CB.7@tu-dresden.de> <20131114083930.GC16543@gmail.com>
In-Reply-To: <20131114083930.GC16543@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TUD-Virus-Scanned: mailout1.zih.tu-dresden.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Just a quick side note, while I realize that you are 
> (rightfully!) concerned about correctness primarily, if that loop 
> over MAX_NR_CPUS executes often enough then this might hurt 
> performance:
> 
>    perf.h:#define MAX_NR_CPUS                      256
> 
> So it might be better to maintain a rolling min_max_timestamp in 
> this place:
> 
> +       os->max_timestamps[sample->cpu] = timestamp;
> 
> ?
> 
> If done that way then AFAICS we could even eliminate the 
> ->max_timestamps[NR_CPUS] array.

I can understand your performance concerns. However, I am not sure how
we can determine the minimal max_timestamp of all cpus without storing
the information on a per-cpu basis first. Accumulating it on the fly
would only lead to a global max_timestamp. If we had any information
about the number of CPUs, we could limit the number of iterations in
set_next_flush() to a minimum, though. However, that would require
keeping track of the maximum cpu id while reading the samples. Or is
there an easy way to determine the actual number cpus in the trace?

Thanks
Joseph

> 
> Thanks,
> 
> 	Ingo
> 
