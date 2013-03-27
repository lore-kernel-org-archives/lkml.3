Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab3C0PhJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 11:37:09 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:39894 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab3C0PhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 11:37:07 -0400
Date: Wed, 27 Mar 2013 11:37:03 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
cc: Peter Zijlstra <peterz@infradead.org>, alex.shi@intel.com,
        linaro-kernel@lists.linaro.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>, len.brown@intel.com,
        pjt@google.com, corbet@lwn.net, linux-kernel@vger.kernel.org,
        cmetcalf@tilera.com, morten.rasmussen@arm.com, tony.luck@intel.com,
        preeti@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        chander.kashyap@linaro.org, Arjan van de Ven <arjan@linux.intel.com>,
        mingo@kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH v3 3/6] sched: pack small tasks
In-Reply-To: <CAKfTPtAox+h0YmpP6W==hJ5FaNzDfF8bQmadmU86MrfnJt67QQ@mail.gmail.com>
Message-ID: <alpine.LFD.2.03.1303271134280.1372@syhkavp.arg>
References: <1363955155-18382-1-git-send-email-vincent.guittot@linaro.org> <1363955155-18382-4-git-send-email-vincent.guittot@linaro.org> <1364301998.5053.17.camel@laptop> <5151BEF2.9090100@linux.intel.com> <1364373980.5053.57.camel@laptop>
 <CAKfTPtAox+h0YmpP6W==hJ5FaNzDfF8bQmadmU86MrfnJt67QQ@mail.gmail.com>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Mar 2013, Vincent Guittot wrote:

> On 27 March 2013 09:46, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Tue, 2013-03-26 at 08:29 -0700, Arjan van de Ven wrote:
> >> > Isn't this basically related to picking the NO_HZ cpu; if the system
> >> > isn't fully symmetric with its power gates you want the NO_HZ cpu to be
> >> > the 'special' cpu. If it is symmetric we really don't care which core
> >> > is left 'running' and we can even select a new pack cpu from the idle
> >> > cores once the old one is fully utilized.
> >>
> >> you don't really care much sure, but there's some advantages for sorting "all the way left",
> >> e.g. to linux cpu 0.
> >> Some tasks only run there, and interrupts tend to be favored to that cpu as well on x86.
> >
> > Right, and I suspect all the big-little nonsense will have the little
> > cores on low numbers as well (is this architected or can a creative
> > licensee screw us over?)
> 
> It's not mandatory to have little cores on low numbers even if it's advised

We can trivially move things around in the logical CPU mapping if that 
simplifies things.  However  the boot CPU might not be CPU0 in that 
case which might be less trivial.


Nicolas
