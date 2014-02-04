Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbaBDJOY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 04:14:24 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:60523 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbaBDJOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 04:14:10 -0500
Date: Tue, 4 Feb 2014 10:14:05 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Len Brown <len.brown@intel.com>, Preeti Murthy <preeti.lkml@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: Re: [RFC PATCH 3/3] idle: store the idle state index in the struct rq
Message-ID: <20140204091405.GB19156@gmail.com>
References: <CAM4v1pPwmRUOtNeGh5sZmj+wAsC8RstofNA5Gx862SEECvW-Lg@mail.gmail.com>
 <20140131090230.GM5002@laptop.programming.kicks-ass.net>
 <52EB6F65.8050008@linux.vnet.ibm.com>
 <52EBBC23.8020603@linux.intel.com>
 <52EBC33A.6080101@linaro.org>
 <52EBC645.2040607@linux.intel.com>
 <alpine.LFD.2.11.1401311236470.2312@knanqh.ubzr>
 <20140203125441.GD19029@e103034-lin>
 <52EFA9D3.1030601@linux.intel.com>
 <20140203145605.GL8874@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140203145605.GL8874@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> [...]
>
> The reason Ingo took it out was that these measured numbers would 
> slightly vary from boot to boot making it hard to compare 
> performance numbers across boots.
> 
> There's something to be said for either case I suppose.

Yeah, so we could put the parameters back by measuring it in 
user-space via a nice utility in tools/, and by matching it to 
relevant hardware signatures (CPU type and cache sizes), plus doing 
some defaults for when we don't have any signature... possibly based 
on a fuzzy search to find the 'closest' system in the table of 
constants.

That would stabilize the boot-to-boot figures while still keeping most 
of the system specific-ness, in a maintainable fashion.

The downside is that we'd have to continuously maintain a table of all 
this info, with new entries added when new CPUs are introduced on the 
market. That's an upside too, btw.

Thanks,

	Ingo
