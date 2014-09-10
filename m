Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272AbaIJOTR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:19:17 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:33153 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbaIJOTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:19:15 -0400
Date: Wed, 10 Sep 2014 16:19:05 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, preeti@linux.vnet.ibm.com,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        riel@redhat.com, Morten.Rasmussen@arm.com, efault@gmx.de,
        nicolas.pitre@linaro.org, linaro-kernel@lists.linaro.org,
        daniel.lezcano@linaro.org, dietmar.eggemann@arm.com
Subject: Re: [PATCH v5 07/12] sched: test the cpu's capacity in wake affine
Message-ID: <20140910141905.GR3190@worktop.ger.corp.intel.com>
References: <1409051215-16788-1-git-send-email-vincent.guittot@linaro.org>
 <1409051215-16788-8-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409051215-16788-8-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 01:06:50PM +0200, Vincent Guittot wrote:
> Currently the task always wakes affine on this_cpu if the latter is idle.
> Before waking up the task on this_cpu, we check that this_cpu capacity is not
> significantly reduced because of RT tasks or irq activity.
> 
> Use case where the number of irq and/or the time spent under irq is important
> will take benefit of this because the task that is woken up by irq or softirq
> will not use the same CPU than irq (and softirq) but a idle one.
> 
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>

Rik, you've been 'fighting' wake_affine, any objections?
