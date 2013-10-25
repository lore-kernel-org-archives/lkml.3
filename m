Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461Ab3JYLPV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 07:15:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53394 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099Ab3JYLPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 07:15:19 -0400
Date: Fri, 25 Oct 2013 13:14:22 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, acme@redhat.com, zheng.z.yan@intel.com,
        bp@alien8.de
Subject: Re: [PATCH v3 3/4] perf,x86: add Intel RAPL PMU support
Message-ID: <20131025111422.GC1219@krava.redhat.com>
References: <1382533085-7166-1-git-send-email-eranian@google.com>
 <1382533085-7166-4-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382533085-7166-4-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 02:58:04PM +0200, Stephane Eranian wrote:

SNIP

> +
> +static void rapl_init_cpu(int cpu)
> +{
> +	int i, phys_id = topology_physical_package_id(cpu);
> +
> +	spin_lock(&rapl_hotplug_lock);
> +
> +	/* check if phys_is is already covered */
> +	for_each_cpu(i, &rapl_cpu_mask) {
> +		if (phys_id == topology_physical_package_id(i))
> +			return;

missing 'spin_unlock(&rapl_hotplug_lock)' above

> +	}
> +	/* was not found, so add it */
> +	cpumask_set_cpu(cpu, &rapl_cpu_mask);
> +
> +	spin_unlock(&rapl_hotplug_lock);
> +}
> +
