Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab3GYIAf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 04:00:35 -0400
Received: from service87.mimecast.com ([91.220.42.44]:50717 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071Ab3GYIAQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 04:00:16 -0400
Date: Thu, 25 Jul 2013 09:00:13 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "alex.shi@intel.com" <alex.shi@intel.com>,
        "efault@gmx.de" <efault@gmx.de>, "pjt@google.com" <pjt@google.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [RFC][PATCH 0/9] sched: Power scheduler design proposal
Message-ID: <20130725080013.GG12572@e103034-lin>
References: <20130713064909.GW25631@dyad.programming.kicks-ass.net>
 <20130713102350.GA8067@MacBook-Pro.local>
 <20130715203922.GD23818@dyad.programming.kicks-ass.net>
 <20130716124248.GB10036@arm.com>
 <51E5655C.7050304@linux.intel.com>
 <20130717141426.GG27948@arm.com>
 <20130724135011.GE12572@e103034-lin>
 <51EFEFD4.4020808@linux.intel.com>
 <20130724164607.GF12572@e103034-lin>
 <51F0056A.7020208@linux.intel.com>
MIME-Version: 1.0
In-Reply-To: <51F0056A.7020208@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 25 Jul 2013 08:00:12.0719 (UTC) FILETIME=[FD92C3F0:01CE890C]
X-MC-Unique: 113072509001400201
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 05:48:42PM +0100, Arjan van de Ven wrote:
> >
> > I would expect performance to be disjoint for most tasks. If there was
> > an overlap, the big would probably be less power efficient (as in
> > energy/instruction) than the little so you would prefer to run on the
> > little anyway.
> >
> > In what way would you use the overlap?
> 
> if the scheduler thinks a task would be better off on the other side
> than where it is now, it could first move it into the "overlap area" on the
> same side by means of experiment, and if the task behaves as expected there,
> THEN move it over.

You could do that, but due to the different uarchs you wouldn't really
know how a cpu bound task would behave on the other side. It would
probably work for memory bound tasks.

Also, for interactive applications (smartphones and such) intermediate
steps will increase latency when going little to big. Going the other
way it would be fine.

