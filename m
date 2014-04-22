Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932805AbaDVPAk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 11:00:40 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:30496 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932736AbaDVPAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 11:00:32 -0400
Date: Tue, 22 Apr 2014 08:00:31 -0700
From: Drew Richardson <drew.richardson@arm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, Ben Greear <greearb@candelatech.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>
Subject: Re: [PATCH] Export irq tracepoints for use by kernel modules
Message-ID: <20140422150030.GA4969@dreric01-Precision-T1600>
References: <20140422142419.GD21121@dreric01-Precision-T1600>
 <20140422142613.GA14535@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140422142613.GA14535@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 03:26:13PM +0100, Christoph Hellwig wrote:
> On Tue, Apr 22, 2014 at 07:24:20AM -0700, Drew Richardson wrote:
> > After commit de7b2973903c6cc50b31ee5682a69b2219b9919d ("tracepoint:
> > Use struct pointer instead of name hash for reg/unreg tracepoints"),
> > any tracepoints used in a kernel module must be exported.
> 
> How does this matter given that there aren't any modular users?

Gator (http://git.linaro.org/arm/ds5/gator.git), an out of tree kernel
module, uses irq_handler_exit and softirq_exit. I thought it would be
helpful to export the other tracepoints from trace/events/irq.h in
case other users encountered a similar issue.

Drew
