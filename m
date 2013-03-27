Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040Ab3C0RS6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 13:18:58 -0400
Received: from mail-qe0-f42.google.com ([209.85.128.42]:54309 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905Ab3C0RS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 13:18:56 -0400
Date: Wed, 27 Mar 2013 13:18:53 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>
cc: Peter Zijlstra <peterz@infradead.org>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "alex.shi@intel.com" <alex.shi@intel.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "corbet@lwn.net" <corbet@lwn.net>,
        Arjan van de Ven <arjan@linux.intel.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "chander.kashyap@linaro.org" <chander.kashyap@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "pjt@google.com" <pjt@google.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH v3 3/6] sched: pack small tasks
In-Reply-To: <20130327163642.GA1136@localhost.cambridge.arm.com>
Message-ID: <alpine.LFD.2.03.1303271314240.1372@syhkavp.arg>
References: <1363955155-18382-1-git-send-email-vincent.guittot@linaro.org> <1363955155-18382-4-git-send-email-vincent.guittot@linaro.org> <1364301998.5053.17.camel@laptop> <5151BEF2.9090100@linux.intel.com> <1364373980.5053.57.camel@laptop>
 <CAKfTPtAox+h0YmpP6W==hJ5FaNzDfF8bQmadmU86MrfnJt67QQ@mail.gmail.com> <1364374820.5053.63.camel@laptop> <20130327111855.GI801@MacBook-Pro.local> <1364393634.5053.71.camel@laptop> <20130327163642.GA1136@localhost.cambridge.arm.com>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Mar 2013, Catalin Marinas wrote:

> So if the above works, the scheduler guys can mandate that little CPUs
> are always first and for ARM it would be a matter of getting the right
> CPU topology in the DT (independent of what hw vendors think of CPU
> topology) and booting Linux on CPU 4 etc.

Just a note about that: if the scheduler mandates little CPUs first, 
that should _not_ have any implications on the DT content.  DT is not 
about encoding Linux specific implementation details.  It is simple 
enough to tweak the CPU logical map at run time when enumeratiing CPUs.


Nicolas
