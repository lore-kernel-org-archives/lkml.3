Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274Ab3KLRDP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 12:03:15 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37041 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641Ab3KLRDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 12:03:11 -0500
Date: Tue, 12 Nov 2013 18:03:02 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mikey@neuling.org,
        linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH v2] sched: Check sched_domain before computing group
 power.
Message-ID: <20131112170302.GC16796@laptop.programming.kicks-ass.net>
References: <tip-db2pe0vxwunv37plc7onnugj@git.kernel.org>
 <20131112105547.GA27310@linux.vnet.ibm.com>
 <20131112115736.GO5056@laptop.programming.kicks-ass.net>
 <20131112164126.GF2559@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131112164126.GF2559@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 10:11:26PM +0530, Srikar Dronamraju wrote:
> After Commit-id 863bffc80898 (sched/fair: Fix group power_orig
> computation), we might end up computing group power before the
> sched_domain for a cpu is updated.
> 
> Update with cpu_power, if rq->sd is not yet updated.
> 
> Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> ---
> Changelog since v1: Fix divide by zero errors that can result because
> power/power_orig was set to 0.

Hurm.. can you provide the actual topology of the machine that triggers
this? My brain hurts trying to thing through the weird cases of this
code.
