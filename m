Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880AbaEOMwE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 08:52:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47343 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445AbaEOMwC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 08:52:02 -0400
Date: Thu, 15 May 2014 14:51:32 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Don Zickus <dzickus@redhat.com>
Subject: Re: [PATCH 08/20] perf tools: Allow hpp fields to be sort keys
Message-ID: <20140515125132.GC25858@krava.brq.redhat.com>
References: <1399876133-17963-1-git-send-email-namhyung@kernel.org>
 <1399876133-17963-9-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399876133-17963-9-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 03:28:41PM +0900, Namhyung Kim wrote:

SNIP

> +static struct hpp_dimension hpp_sort_dimensions[] = {
> +	DIM(PERF_HPP__OVERHEAD, "overhead"),
> +	DIM(PERF_HPP__OVERHEAD_SYS, "overhead_sys"),
> +	DIM(PERF_HPP__OVERHEAD_US, "overhead_us"),
> +	DIM(PERF_HPP__OVERHEAD_GUEST_SYS, "overhead_guest_sys"),
> +	DIM(PERF_HPP__OVERHEAD_GUEST_US, "overhead_guest_us"),
> +	DIM(PERF_HPP__SAMPLES, "sample"),
> +	DIM(PERF_HPP__PERIOD, "period"),
> +};

just a nit.. overhead_guest_us|sys misplace are not properly aligned


[jolsa@krava perf]$ ./perf report -s overhead_guest_us,period,dso,sym --stdio
# To display the perf.data header info, please use --header/--header-only options.
#
# Samples: 9  of event 'cycles'
# Event count (approx.): 3808201
#
# Overhead  guest usr        Period      Shared Object                      Symbol
# ........  .........  ............  .................  ..........................
#
    43.05%     0.00%       1639423  ld-2.17.so         [.] _dl_map_object_deps   
    36.86%     0.00%       1403626  [kernel.kallsyms]  [k] _raw_spin_lock_irqsave

....


jirka
