Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758887Ab3B0B1p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 20:27:45 -0500
Received: from ozlabs.org ([203.10.76.45]:37748 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756920Ab3B0B1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 20:27:41 -0500
Date: Wed, 27 Feb 2013 12:27:37 +1100
From: Michael Ellerman <michael@ellerman.id.au>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        robert.richter@amd.com, Anton Blanchard <anton@au1.ibm.com>,
        linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        linuxppc-dev@ozlabs.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 5/6][v4]: perf: Create a sysfs entry for Power event
 format
Message-ID: <20130227012736.GD5819@concordia>
References: <20130123062201.GA13720@us.ibm.com>
 <20130123062613.GF13720@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130123062613.GF13720@us.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 10:26:13PM -0800, Sukadev Bhattiprolu wrote:
> 
> [PATCH 5/6][v4]: perf: Create a sysfs entry for Power event format
> 
> Create a sysfs entry, '/sys/bus/event_source/devices/cpu/format/event'
> which describes the format of a POWER cpu.

> diff --git a/arch/powerpc/perf/core-book3s.c b/arch/powerpc/perf/core-book3s.c
> index fa476d5..4ae044b 100644
> --- a/arch/powerpc/perf/core-book3s.c
> +++ b/arch/powerpc/perf/core-book3s.c
> @@ -1315,6 +1315,18 @@ ssize_t power_events_sysfs_show(struct device *dev,
>  	return sprintf(page, "event=0x%02llx\n", pmu_attr->id);
>  }
>  
> +PMU_FORMAT_ATTR(event, "config:0-20");

Just noticed, it's 20 bits, which is 0-19.

cheers
