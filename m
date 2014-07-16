Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964906AbaGPOPz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 10:15:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39349 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934267AbaGPOPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 10:15:53 -0400
Date: Wed, 16 Jul 2014 16:15:19 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 13/41] perf tools: Add machine__kernel_ip()
Message-ID: <20140716141519.GC9441@krava.redhat.com>
References: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com>
 <1405332185-4050-14-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405332185-4050-14-git-send-email-adrian.hunter@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 01:02:37PM +0300, Adrian Hunter wrote:

SNIP

> +
> +int machine__get_kernel_start(struct machine *machine)
> +{
> +	struct map *map = machine__kernel_map(machine, MAP__FUNCTION);
> +	int err = 0;
> +
> +	/*
> +	 * The only addresses above 2^63 are kernel addresses of a 64-bit
> +	 * kernel.  Note that addresses are unsigned so that on a 32-bit system
> +	 * all addresses including kernel addresses are less than 2^32.  In
> +	 * that case (32-bit system), if the kernel mapping is unknown, all
> +	 * addresses will be assumed to be in user space - see
> +	 * machine__kernel_ip().
> +	 */
> +	machine->kernel_start = 1ULL << 63;
> +	if (map) {
> +		err = map__load(map, machine->symbol_filter);
> +		if (map->start)
> +			machine->kernel_start = map->start;
> +	}
> +	return err;
> +}

we just recently got machine__get_kernel_start_addr function,
I think we want just one function for this

jirka
