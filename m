Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935887Ab3BTPnr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 10:43:47 -0500
Received: from mga14.intel.com ([143.182.124.37]:23167 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934060Ab3BTPnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 10:43:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,702,1355126400"; 
   d="scan'208";a="204487814"
Date: Wed, 20 Feb 2013 07:43:44 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        acme@redhat.com, jolsa@redhat.com, namhyung.kim@lge.com
Subject: Re: [PATCH] perf, x86: add Intel IvyBridge event scheduling
 constraints
Message-ID: <20130220154344.GD23293@tassilo.jf.intel.com>
References: <1361355312-3323-1-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361355312-3323-1-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 11:15:12AM +0100, Stephane Eranian wrote:
> Intel IvyBridge processor has different constraints compared
> to SandyBridge. Therefore it needs its own contraint table.
> This patch adds the constraint table. Without this patch,
> the events listed in the patch may not be scheduled correctly
> and bogus counts may be collected.

Thanks. I ran into this problem too and was about to write 
a similar patch.

> +	INTEL_UEVENT_CONSTRAINT(0x04a3, 0xf), /* CYCLE_ACTIVITY.CYCLES_NO_EXECUTE */
> +	INTEL_UEVENT_CONSTRAINT(0x05a3, 0xf), /* CYCLE_ACTIVITY.STALLS_L2_PENDING */
> +	INTEL_UEVENT_CONSTRAINT(0x06a3, 0xf), /* CYCLE_ACTIVITY.STALLS_LDM_PENDING */
> +	INTEL_UEVENT_CONSTRAINT(0x08a3, 0x4), /* CYCLE_ACTIVITY.CYCLES_L1D_PENDING */
> +	INTEL_UEVENT_CONSTRAINT(0x0ca3, 0x4), /* CYCLE_ACTIVITY.STALLS_L1D_PENDING */


Except for LDM_PENDING the CYCLE_ACTIVITY events have been also added to Sandy Bridge.
So it should be also added there.

In fact I think you can still share the table because it would just add some 
non existent events to Sandy Bridge, which is a noop.

-Andi

