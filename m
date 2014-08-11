Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbaHKMoG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 08:44:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52218 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529AbaHKMoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 08:44:04 -0400
Date: Mon, 11 Aug 2014 14:43:30 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 13/41] perf tools: Add machine__kernel_ip()
Message-ID: <20140811124330.GA31858@krava.brq.redhat.com>
References: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com>
 <1405332185-4050-14-git-send-email-adrian.hunter@intel.com>
 <20140716141519.GC9441@krava.redhat.com>
 <53C68A9E.6060302@intel.com>
 <20140811122321.GB26811@krava.brq.redhat.com>
 <53E8B8D8.4040809@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53E8B8D8.4040809@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 03:36:40PM +0300, Adrian Hunter wrote:
> On 08/11/2014 03:23 PM, Jiri Olsa wrote:
> > On Wed, Jul 16, 2014 at 05:22:22PM +0300, Adrian Hunter wrote:
> >> On 16/07/2014 5:15 p.m., Jiri Olsa wrote:
> >>> On Mon, Jul 14, 2014 at 01:02:37PM +0300, Adrian Hunter wrote:
> >>>
> >>> SNIP
> >>>
> >>>> +
> >>>> +int machine__get_kernel_start(struct machine *machine)
> >>>> +{
> >>>> +	struct map *map = machine__kernel_map(machine, MAP__FUNCTION);
> >>>> +	int err = 0;
> >>>> +
> >>>> +	/*
> >>>> +	 * The only addresses above 2^63 are kernel addresses of a 64-bit
> >>>> +	 * kernel.  Note that addresses are unsigned so that on a 32-bit system
> >>>> +	 * all addresses including kernel addresses are less than 2^32.  In
> >>>> +	 * that case (32-bit system), if the kernel mapping is unknown, all
> >>>> +	 * addresses will be assumed to be in user space - see
> >>>> +	 * machine__kernel_ip().
> >>>> +	 */
> >>>> +	machine->kernel_start = 1ULL << 63;
> >>>> +	if (map) {
> >>>> +		err = map__load(map, machine->symbol_filter);
> >>>> +		if (map->start)
> >>>> +			machine->kernel_start = map->start;
> >>>> +	}
> >>>> +	return err;
> >>>> +}
> >>>
> >>> we just recently got machine__get_kernel_start_addr function,
> >>> I think we want just one function for this
> >>
> >> They do quite different things.
> >>
> > 
> > so one of those two should have different name
> 
> Such as?

dont know ;-) but if they do 'quite different things' as u said,
I expect to see that at least in the function name

jirka
