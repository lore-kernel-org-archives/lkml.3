Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922AbaKGM7O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 07:59:14 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:45574 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbaKGM7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 07:59:10 -0500
Date: Fri, 7 Nov 2014 13:58:57 +0100
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
Message-ID: <20141107125857.GF3337@twins.programming.kicks-ass.net>
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
> +static unsigned int __rotation_period = 250; /* ms */

There's two things being conflated here I think, even though they're
related.

The one is how long we'll let RMIDs settle before trying to reuse them,
the second is how often we attempt the rotation. Clearly the rotation
time is limited by the settle time, but they need not be the same.

Also, we already have a per pmu rotation interval in
pmu::hrtimer_interval_ms, I suppose we should reuse that to be
consistent.
