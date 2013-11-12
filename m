Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951Ab3KLMHl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 07:07:41 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:54852 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751868Ab3KLMHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 07:07:39 -0500
Date: Tue, 12 Nov 2013 12:06:34 +0000
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Paul Turner <pjt@google.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Tony Luck <tony.luck@intel.com>,
        "alex.shi@intel.com" <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "l.majewski@samsung.com" <l.majewski@samsung.com>,
        Jonathan Corbet <corbet@lwn.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [RFC][PATCH v5 00/14] sched: packing tasks
Message-ID: <20131112120634.GA5762@e103034-lin>
References: <1382097147-30088-1-git-send-email-vincent.guittot@linaro.org>
 <CAHkRjk69GNYtLGBSWCNcsCzkBHywKrD0qQQbNkJRpMbcdsCPyw@mail.gmail.com>
 <20131111163630.GD26898@twins.programming.kicks-ass.net>
 <52810851.4090907@linux.intel.com>
 <20131111181805.GE29572@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131111181805.GE29572@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 06:18:05PM +0000, Catalin Marinas wrote:
> On Mon, Nov 11, 2013 at 04:39:45PM +0000, Arjan van de Ven wrote:
> > having a hardware driver give a prefered CPU ordering for wakes can indeed be useful.
> > (I'm doubtful that changing the recommendation for each idle is going to pay off,
> > but proof is in the pudding; there are certainly long term effects where this can help)
> 
> The ordering is based on the actual C-state, so a simple way is to wake
> up the CPU in the shallowest C-state. With asymmetric configurations
> (big.LITTLE) we have different costs for the same C-state, so this would
> come in handy.

Asymmetric configurations add a bit of extra fun to deal with as you
don't want to pick the cpu in the shallowest C-state if it is the wrong
type of cpu for the task waking up. That goes for both big and little
cpus in big.LITTLE.

So the hardware driver would need to know which cpus that are suitable
targets for the task, or we need to somehow limit the driver query to
suitable cpus, or the driver should return a list of cpus guaranteed to
include cpus of all types (big, little, whatever...).

Morten
