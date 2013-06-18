Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932508Ab3FRMht (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 08:37:49 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:43738 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932381Ab3FRMhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 08:37:46 -0400
Date: Tue, 18 Jun 2013 14:37:42 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Vince Weaver <vincent.weaver@maine.edu>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        trinity@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 2/2] hw_breakpoint: Introduce "struct bp_cpuinfo"
Message-ID: <20130618123741.GC17619@somewhere.redhat.com>
References: <alpine.DEB.2.02.1305201206480.29892@vincent-weaver-1.um.maine.edu>
 <20130602194912.GA3277@redhat.com>
 <20130602195057.GC3277@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130602195057.GC3277@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 02, 2013 at 09:50:57PM +0200, Oleg Nesterov wrote:
> This patch simply moves all per-cpu variables into the new single
> per-cpu "struct bp_cpuinfo".
> 
> To me this looks more logical and clean, but this can also simplify
> the further potential changes. In particular, I do not think this
> memory should be per-cpu, it is never used "locally". After this
> change it is trivial to turn it into, say, bootmem[nr_cpu_ids].
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

I'm ok with the patch because it's indeed more logical and clean to pack the info
to a single struct.

But I'm not sure why you think using per-cpu is a problem. It's not only
deemed for optimized local uses, it's also convenient for allocations and
de-allocation, or static definitions. I'm not sure why bootmem would make
more sense.

Other than this in the changelog, the patch is nice, thanks!

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
