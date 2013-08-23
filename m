Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440Ab3HWT4U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 15:56:20 -0400
Received: from mail-gh0-f180.google.com ([209.85.160.180]:59124 "EHLO
	mail-gh0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755844Ab3HWT4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 15:56:18 -0400
Date: Fri, 23 Aug 2013 16:02:50 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Vince Weaver <vincent.weaver@maine.edu>
cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, mingo@kernel.org,
        acme@redhat.com, Stephane Eranian <eranian@gmail.com>
Subject: Re: [PATCH 1/2] Update perf_event ABI documentation: format and
 events
In-Reply-To: <alpine.DEB.2.10.1307250004590.25162@vincent-weaver-1.um.maine.edu>
Message-ID: <alpine.DEB.2.10.1308231601370.24098@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1307250004590.25162@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It's been a month, are there any objections to these perf_event ABI 
documentation updates?  

Vince


On Thu, 25 Jul 2013, Vince Weaver wrote:

> 
> This clarifies some of the ABI, as there has been some confusion
> and minor breakages lately.  Most notably it documents that as of
> 3.10 the events entries can contain decimal values in addition to
> hex.
> 
> This is version 2 containing whitespace fixes suggested by
> Jiri Olsa.
> 
> Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-event_source-devices-events b/Documentation/ABI/testing/sysfs-bus-event_source-devices-events
> index 3c1cc24..16d9107 100644
> --- a/Documentation/ABI/testing/sysfs-bus-event_source-devices-events
> +++ b/Documentation/ABI/testing/sysfs-bus-event_source-devices-events
> @@ -1,30 +1,52 @@
> -What:		/sys/devices/cpu/events/
> +What:		/sys/bus/event_source/devices/<dev>/events
> +
> +Date:		2013/01/08
> +
> +Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
> +
> +Description:	Generic performance monitoring events
> +
> +		A collection of performance monitoring events that are
> +		supported by the PMU (performance monitoring unit)
> +		specified by "<dev>". These events can be monitored
> +		using the 'perf(1)' tool.
> +
> +		The contents of each file is a list of attribute names
> +		(as found in the corresponding
> +			/sys/bus/event_source/devices/<dev>/format
> +		file) separated by commas.  Each entry has
> +		an optional value (either hex or decimal).  If no
> +		value is specified than it is assumed to be a single-bit
> +		field with a value of 1.
> +
> +		An example of what you might find:
> +			event=0x2,inv,ldlat=3
> +
> +
> +What:		/sys/devices/cpu/events/branch-instructions
>  		/sys/devices/cpu/events/branch-misses
> -		/sys/devices/cpu/events/cache-references
> +		/sys/devices/cpu/events/bus-cycles
>  		/sys/devices/cpu/events/cache-misses
> -		/sys/devices/cpu/events/stalled-cycles-frontend
> -		/sys/devices/cpu/events/branch-instructions
> -		/sys/devices/cpu/events/stalled-cycles-backend
> -		/sys/devices/cpu/events/instructions
> +		/sys/devices/cpu/events/cache-references
>  		/sys/devices/cpu/events/cpu-cycles
> +		/sys/devices/cpu/events/instructions
> +		/sys/devices/cpu/events/ref-cycles
> +		/sys/devices/cpu/events/stalled-cycles-backend
> +		/sys/devices/cpu/events/stalled-cycles-frontend
>  
>  Date:		2013/01/08
>  
>  Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
>  
> -Description:	Generic performance monitoring events
> +Description:	Generic CPU performance monitoring events
>  
>  		A collection of performance monitoring events that may be
>  		supported by many/most CPUs. These events can be monitored
>  		using the 'perf(1)' tool.
>  
> -		The contents of each file would look like:
> -
> -			event=0xNNNN
> -
> -		where 'N' is a hex digit and the number '0xNNNN' shows the
> -		"raw code" for the perf event identified by the file's
> -		"basename".
> +		The format of these files matches that of
> +		/sys/bus/event_source/devices/<dev>/events as described
> +		previously in this file.
>  
>  
>  What: 		/sys/devices/cpu/events/PM_1PLUS_PPC_CMPL
> diff --git a/Documentation/ABI/testing/sysfs-bus-event_source-devices-format b/Documentation/ABI/testing/sysfs-bus-event_source-devices-format
> index 77f47ff..8f4c13f 100644
> --- a/Documentation/ABI/testing/sysfs-bus-event_source-devices-format
> +++ b/Documentation/ABI/testing/sysfs-bus-event_source-devices-format
> @@ -15,6 +15,12 @@ Description:
>  			attr2 = 'config:0-7'
>  			attr3 = 'config:12-35'
>  
> -		Example: 'config1:1,6-10,44'
> +		Example: event = 'config1:1,6-10,44'
>  		Defines contents of attribute that occupies bits 1,6-10,44 of
>  		perf_event_attr::config1.
> +
> +		In this example, the events file would have the value
> +			event=0x7f
> +		to set all of the specified bits (they will be split up).
> +		You would not use 0x10000007c2 (which is what the bits
> +		actually passed into config1 would look like).
> 

