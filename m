Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbaKCPvr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 10:51:47 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:40509 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272AbaKCPvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 10:51:41 -0500
Date: Mon, 3 Nov 2014 16:51:29 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, preeti@linux.vnet.ibm.com,
        Morten.Rasmussen@arm.com, kamalesh@linux.vnet.ibm.com,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        riel@redhat.com, efault@gmx.de, nicolas.pitre@linaro.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH v8 10/10] sched: make scale_rt invariant with frequency
Message-ID: <20141103155129.GK12706@worktop.programming.kicks-ass.net>
References: <1414745252-4895-1-git-send-email-vincent.guittot@linaro.org>
 <1414745252-4895-11-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414745252-4895-11-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 09:47:32AM +0100, Vincent Guittot wrote:
> The call to arch_scale_frequency_capacity in the rt scheduling path might be
> a concern for RT folks because I'm not sure whether we can rely on
> arch_scale_freq_capacity to be short and efficient ?

Well, you put it in quite a hot path on the CFS side too, so it had
better be blazing fast anyhow.


That said, can you move all the running + invariance bits at the
beginning of the patch set, these appear to be the least controversial
bits and 'desired' by quite a few people, so we'll try and get those
agreed upon and merged first.
