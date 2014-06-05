Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890AbaFEEXs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:23:48 -0400
Received: from ozlabs.org ([103.22.144.67]:37395 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753881AbaFEEXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:23:46 -0400
Date: Thu, 5 Jun 2014 14:23:36 +1000
From: Paul Mackerras <paulus@samba.org>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
        svaidyan@in.ibm.com, srivatsa.bhat@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 2/6] powerpc, powernv, CPU hotplug: Put offline CPUs in
 Fast-Sleep instead of Nap
Message-ID: <20140605042336.GA3199@drongo>
References: <20140528043703.15676.58580.stgit@preeti.in.ibm.com>
 <20140528043856.15676.35844.stgit@preeti.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140528043856.15676.35844.stgit@preeti.in.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 10:08:56AM +0530, Preeti U Murthy wrote:
> From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> 
> The offline cpus are put to fast sleep if the idle state is discovered in the
> device tree. This is to gain maximum powersavings in the offline state.

...

>  	while (!generic_check_cpu_restart(cpu)) {
>  		ppc64_runlatch_off();
> -		power7_nap();
> +
> +		/* If sleep is supported, go to sleep, instead of nap */
> +		if (idle_states & IDLE_USE_SLEEP)
> +			power7_sleep();
> +		else
> +			power7_nap();
> +
>  		ppc64_runlatch_on();
>  		if (!generic_check_cpu_restart(cpu)) {
>  			DBG("CPU%d Unexpected exit while offline !\n", cpu);

What is the latency for waking up from fast sleep state?  I'm concerned
this will increase the latency for entering KVM guests.

Paul.
