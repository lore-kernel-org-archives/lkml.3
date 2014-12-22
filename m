Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016AbaLVOk0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 09:40:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60414 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754561AbaLVOkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 09:40:25 -0500
Date: Mon, 22 Dec 2014 15:39:43 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>, dev@codyps.com,
        peterz@infradead.org, hbabu@us.ibm.com, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v6 3/4] perf Documentation: add event parameters
Message-ID: <20141222143943.GB29096@krava.brq.redhat.com>
References: <1419234567-22784-1-git-send-email-sukadev@linux.vnet.ibm.com>
 <1419234567-22784-4-git-send-email-sukadev@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419234567-22784-4-git-send-email-sukadev@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 21, 2014 at 11:49:26PM -0800, Sukadev Bhattiprolu wrote:
> From: Cody P Schafer <cody@linux.vnet.ibm.com>
> 
> Event parameters are a basic way for partial events to be specified in
> sysfs with per-event names given to the fields that need to be filled in
> when using a particular event.
> 
> It is intended for supporting cases where the single 'cpu' parameter is
> insufficient. For example, POWER 8 has events for physical
> sockets/cores/cpus that are accessible from with virtual machines. To
> keep using the single 'cpu' parameter we'd need to perform a mapping
> between Linux's cpus and the physical machine's cpus (in this case
> Linux is running under a hypervisor). This isn't possible because
> bindings between our cpus and physical cpus may not be fixed, and we
> probably won't have a "cpu" on each physical cpu.
> 
> Changelog[v6]
> 	Update event description to explain how required parameters
> 	are displayed.
> 
> CC: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> CC: Haren Myneni <hbabu@us.ibm.com>
> CC: Cody P Schafer <dev@codyps.com>
> Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
> ---
>  Documentation/ABI/testing/sysfs-bus-event_source-devices-events | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-event_source-devices-events b/Documentation/ABI/testing/sysfs-bus-event_source-devices-events
> index 20979f8..47ad2a1 100644
> --- a/Documentation/ABI/testing/sysfs-bus-event_source-devices-events
> +++ b/Documentation/ABI/testing/sysfs-bus-event_source-devices-events
> @@ -52,12 +52,18 @@ Description:	Per-pmu performance monitoring events specific to the running syste
>  			event=0x2abc
>  			event=0x423,inv,cmask=0x3
>  			domain=0x1,offset=0x8,starting_index=0xffff
> +			domain=0x1,offset=0x8,core=?
>  
>  		Each of the assignments indicates a value to be assigned to a
>  		particular set of bits (as defined by the format file
>  		corresponding to the <term>) in the perf_event structure passed
>  		to the perf_open syscall.
>  
> +		In the case of the last example, a value replacing "?" would
> +		need to be provided by the user selecting the particular event.
> +		This is referred to as "event parameterization". All
> +		non-numerical values indicate an event parameter.

I see.. here's the glitch ;-) I thought we agreed on forcing '?'
as the value for param events, not 'All non-numerical values'

thanks,
jirka
