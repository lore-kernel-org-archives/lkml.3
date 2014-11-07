Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022AbaKGMVA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 07:21:00 -0500
Received: from casper.infradead.org ([85.118.1.10]:35199 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbaKGMU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 07:20:58 -0500
Date: Fri, 7 Nov 2014 13:20:52 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Kanaka Juvva <kanaka.d.juvva@intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v3 10/11] perf/x86/intel: Perform rotation on Intel CQM
 RMIDs
Message-ID: <20141107122052.GD3337@twins.programming.kicks-ass.net>
References: <1415276602-10337-1-git-send-email-matt@console-pimps.org>
 <1415276602-10337-11-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415276602-10337-11-git-send-email-matt@console-pimps.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 12:23:21PM +0000, Matt Fleming wrote:
> +/*
> + * If we fail to assign a new RMID for intel_cqm_rotation_rmid because
> + * cachelines are still tagged with RMIDs in limbo, we progressively
> + * increment the threshold until we find an RMID in limbo with <=
> + * __intel_cqm_threshold lines tagged. This is designed to mitigate the
> + * problem where cachelines tagged with an RMID are not steadily being
> + * evicted.
> + *
> + * On successful rotations we decrease the threshold back towards zero.
> + *
> + * __intel_cqm_max_threshold provides an upper bound on the threshold,
> + * and is measured in bytes because it's exposed to userland.
> + */
> +static unsigned int __intel_cqm_threshold;
> +static unsigned int __intel_cqm_max_threshold = -1;

Should we initialize that to a finite value? Surely results are absolute
crap if we do indeed reach that max?
