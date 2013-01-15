Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757720Ab3AOS6M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 13:58:12 -0500
Received: from mail-gh0-f182.google.com ([209.85.160.182]:42696 "EHLO
	mail-gh0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757377Ab3AOS6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 13:58:09 -0500
Date: Tue, 15 Jan 2013 15:57:59 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Anton Blanchard <anton@au1.ibm.com>,
        Jiri Olsa <jolsa@redhat.com>, robert.richter@amd.com,
        linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Greg KH <greg@kroah.com>
Subject: Re: [PATCH 6/6][v3] perf: Document the ABI of perf sysfs entries
Message-ID: <20130115185759.GG5826@ghostprotocols.net>
References: <20130110010347.GA32590@us.ibm.com>
 <20130110010703.GF32590@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130110010703.GF32590@us.ibm.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jan 09, 2013 at 05:07:03PM -0800, Sukadev Bhattiprolu escreveu:
> [PATCH 6/6][v3] perf: Document the ABI of perf sysfs entries
> 
> This patchset addes two new sets of files to sysfs:
> 
> 	- generic and POWER-specific perf events in /sys/devices/cpu/events/
> 	- perf event config format in /sys/devices/cpu/format/event
> 
> Document the format of these files which would become part of the ABI.
> 
> Changelog[v3]:
> 	[Greg KH] Include ABI documentation.

Jiri, can I have your ack on this one too?

Greg, all ok now?

- Arnaldo
 
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> ---
>  Documentation/ABI/stable/sysfs-devices-cpu-events |   54 +++++++++++++++++++++
>  Documentation/ABI/stable/sysfs-devices-cpu-format |   27 ++++++++++
>  2 files changed, 81 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/ABI/stable/sysfs-devices-cpu-format
> 
> diff --git a/Documentation/ABI/stable/sysfs-devices-cpu-events b/Documentation/ABI/stable/sysfs-devices-cpu-events
> index e69de29..f37d542 100644
> --- a/Documentation/ABI/stable/sysfs-devices-cpu-events
> +++ b/Documentation/ABI/stable/sysfs-devices-cpu-events
> @@ -0,0 +1,54 @@
> +What:		/sys/devices/cpu/events/
> +		/sys/devices/cpu/events/branch-misses
> +		/sys/devices/cpu/events/cache-references
> +		/sys/devices/cpu/events/cache-misses
> +		/sys/devices/cpu/events/stalled-cycles-frontend
> +		/sys/devices/cpu/events/branch-instructions
> +		/sys/devices/cpu/events/stalled-cycles-backend
> +		/sys/devices/cpu/events/instructions
> +		/sys/devices/cpu/events/cpu-cycles
> +
> +Date:		2013/01/08
> +
> +Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
> +
> +Description:	Generic performance monitoring events
> +
> +		A collection of performance monitoring events that may be
> +		supported by many/most CPUs. These events can be monitored
> +		using the 'perf(1)' tool.
> +
> +		The contents of each file would look like:
> +
> +			event=0xNNNN
> +
> +		where 'N' is a hex digit.
> +
> +
> +What: 		/sys/devices/cpu/events/PM_LD_MISS_L1
> +		/sys/devices/cpu/events/PM_LD_REF_L1
> +		/sys/devices/cpu/events/PM_CYC
> +		/sys/devices/cpu/events/PM_BRU_FIN
> +		/sys/devices/cpu/events/PM_GCT_NOSLOT_CYC
> +		/sys/devices/cpu/events/PM_BRU_MPRED
> +		/sys/devices/cpu/events/PM_INST_CMPL
> +		/sys/devices/cpu/events/PM_CMPLU_STALL
> +
> +Date:		2013/01/08
> +
> +Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
> +		Linux Powerpc mailing list <linuxppc-dev@ozlabs.org>
> +
> +Description:	POWER specific performance monitoring events
> +
> +		A collection of performance monitoring events that may be
> +		supported by the POWER CPU. These events can be monitored
> +		using the 'perf(1)' tool.
> +
> +		These events may not be supported by other CPUs.
> +
> +		The contents of each file would look like:
> +
> +			event=0xNNNN
> +
> +		where 'N' is a hex digit.
> diff --git a/Documentation/ABI/stable/sysfs-devices-cpu-format b/Documentation/ABI/stable/sysfs-devices-cpu-format
> new file mode 100644
> index 0000000..b15cfb2
> --- /dev/null
> +++ b/Documentation/ABI/stable/sysfs-devices-cpu-format
> @@ -0,0 +1,27 @@
> +What:		/sys/devices/cpu/format/
> +		/sys/devices/cpu/format/event
> +
> +Date:		2013/01/08
> +
> +Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
> +
> +Description:	Format of performance monitoring events
> +
> +		Each CPU/architecture may use different format to represent
> +		the perf event.  The 'event' file describes the configuration
> +		format of the performance monitoring event on the CPU/system.
> +
> +		The contents of each file would look like:
> +
> +			config:m-n
> +
> +		where m and n are the starting and ending bits that are
> +		used to represent the event.
> +
> +		For example, on POWER,
> +
> +			$ cat /sys/devices/cpu/format/event
> +			config:0-20
> +
> +		meaning that POWER uses the first 20-bits to represent a perf
> +		event.
> -- 
> 1.7.1
