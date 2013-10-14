Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222Ab3JNRTJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 13:19:09 -0400
Received: from service87.mimecast.com ([91.220.42.44]:46451 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932187Ab3JNRTH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 13:19:07 -0400
Date: Mon, 14 Oct 2013 18:19:09 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "pjt@google.com" <pjt@google.com>, "rjw@sisk.pl" <rjw@sisk.pl>,
        "dirk.j.brandewie@intel.com" <dirk.j.brandewie@intel.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "alex.shi@linaro.org" <alex.shi@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "efault@gmx.de" <efault@gmx.de>, "corbet@lwn.net" <corbet@lwn.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [RFC][PATCH 4/7] sched: power: Remove power capacity hints for
 kworker threads
Message-ID: <20131014171909.GQ31039@e103034-lin>
References: <1381511957-29776-1-git-send-email-morten.rasmussen@arm.com>
 <1381511957-29776-5-git-send-email-morten.rasmussen@arm.com>
 <20131014133356.GN3081@twins.programming.kicks-ass.net>
 <20131014161011.GO31039@e103034-lin>
 <525C1817.1050909@linux.intel.com>
MIME-Version: 1.0
In-Reply-To: <525C1817.1050909@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 14 Oct 2013 17:19:01.0825 (UTC) FILETIME=[79F01310:01CEC901]
X-MC-Unique: 113101418190507301
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 05:13:11PM +0100, Arjan van de Ven wrote:
> On 10/14/2013 9:10 AM, Morten Rasmussen wrote:
> > On Mon, Oct 14, 2013 at 02:33:56PM +0100, Peter Zijlstra wrote:
> >> On Fri, Oct 11, 2013 at 06:19:14PM +0100, Morten Rasmussen wrote:
> >>> Removing power hints for kworker threads enables easier use of
> >>> workqueues in the power driver late callback. That would otherwise
> >>> lead to an endless loop unless it is prevented in the power driver.
> >>
> >> There's many kworker users; some of them actually consume lots of
> >> cputime. Therefore how did you come to the conclusion that excepting all
> >> users was the better choice of a little added complexity in the one
> >> place where it actually matters?
> >
> > Agreed that it is not ideal. I will find a better solution for this
> > problem.
> >
> 
> can you explain which architectures we're talking about that need this?
> is it only old stuff, or is there anything current ?
> 

For now I need it for the cpufreq wrapper governor. I hope it can be
avoided for native power drivers, but I don't have a complete overview
of all architectures yet.

