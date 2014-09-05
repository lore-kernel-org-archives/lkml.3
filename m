Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932258AbaIEMGj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 08:06:39 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:34227 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756833AbaIEMGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 08:06:37 -0400
Message-ID: <5409A73B.4050402@linux.vnet.ibm.com>
Date: Fri, 05 Sep 2014 17:36:19 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>, peterz@infradead.org,
        mingo@kernel.org, linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org
CC: riel@redhat.com, Morten.Rasmussen@arm.com, efault@gmx.de,
        nicolas.pitre@linaro.org, linaro-kernel@lists.linaro.org,
        daniel.lezcano@linaro.org, dietmar.eggemann@arm.com
Subject: Re: [PATCH v5 08/12] sched: move cfs task on a CPU with higher capacity
References: <1409051215-16788-1-git-send-email-vincent.guittot@linaro.org> <1409051215-16788-9-git-send-email-vincent.guittot@linaro.org>
In-Reply-To: <1409051215-16788-9-git-send-email-vincent.guittot@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14090512-0320-0000-0000-000000678ED6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vincent,

On 08/26/2014 04:36 PM, Vincent Guittot wrote:
> If the CPU is used for handling lot of IRQs, trig a load balance to check if
> it's worth moving its tasks on another CPU that has more capacity.
> 
> As a sidenote, this will note generate more spurious ilb because we already
> trig an ilb if there is more than 1 busy cpu. If this cpu is the only one that
> has a task, we will trig the ilb once for migrating the task.
> 
> The nohz_kick_needed function has been cleaned up a bit while adding the new
> test
> 
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>

So I see that there are added checks in your previous patches on if the
cpu capacity for CFS tasks is good enough to run tasks on the cpu. My
concern is although they appear sensible, would they trigger an increase
in the number of times we load balance to a large extent.

Ebizzy would not test this aspect right? There are no real time
tasks/interrupts that get generated.

Besides, what is the column that says patchset+irq? What is the irq
accounting patchset that you refer to in your cover letter?

Regards
Preeti U Murthy

