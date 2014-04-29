Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955AbaD2PEY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 11:04:24 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:37767 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752687AbaD2PEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 11:04:22 -0400
Date: Tue, 29 Apr 2014 16:04:30 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alex Shi <alex.shi@linaro.org>, "mingo@redhat.com" <mingo@redhat.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "efault@gmx.de" <efault@gmx.de>,
        "wangyun@linux.vnet.ibm.com" <wangyun@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mgorman@suse.de" <mgorman@suse.de>
Subject: Re: [RESEND PATCH V5 0/8] remove cpu_load idx
Message-ID: <20140429150430.GI2639@e103034-lin>
References: <1397616209-27275-1-git-send-email-alex.shi@linaro.org>
 <20140424162029.GV11096@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140424162029.GV11096@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 05:20:29PM +0100, Peter Zijlstra wrote:
> OK, this series is a lot saner, with the exception of 3/8 and
> dependents.
> 
> I do still worry a bit for loosing the longer term view for the big
> domains though. Sadly I don't have any really big machines.
> 
> I think the entire series is equivalent to setting LB_BIAS to false. So
> I suppose we could do that for a while and if nobody reports horrible
> things we could just do this.
> 
> Anybody?

I can't say what will happen on big machines, but I think the LB_BIAS
test could be a way to see what happens. I'm not convinced that it won't
lead to more task migrations since we will use the instantaneous cpu
load (weighted_cpuload()) unfiltered.

Morten
