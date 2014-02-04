Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025AbaBDO4L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 09:56:11 -0500
Received: from mga03.intel.com ([143.182.124.21]:37416 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214AbaBDO4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 09:56:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,780,1384329600"; 
   d="scan'208";a="338703996"
Message-ID: <52F0FF87.3040102@linux.intel.com>
Date: Tue, 04 Feb 2014 06:56:07 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
CC: Morten Rasmussen <morten.rasmussen@arm.com>,
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
Subject: Re: [RFC PATCH 3/3] idle: store the idle state index in the struct
 rq
References: <CAM4v1pPwmRUOtNeGh5sZmj+wAsC8RstofNA5Gx862SEECvW-Lg@mail.gmail.com> <20140131090230.GM5002@laptop.programming.kicks-ass.net> <52EB6F65.8050008@linux.vnet.ibm.com> <52EBBC23.8020603@linux.intel.com> <52EBC33A.6080101@linaro.org> <52EBC645.2040607@linux.intel.com> <alpine.LFD.2.11.1401311236470.2312@knanqh.ubzr> <20140203125441.GD19029@e103034-lin> <52EFA9D3.1030601@linux.intel.com> <20140203145605.GL8874@twins.programming.kicks-ass.net> <20140204091405.GB19156@gmail.com>
In-Reply-To: <20140204091405.GB19156@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Yeah, so we could put the parameters back by measuring it in
> user-space via a nice utility in tools/, and by matching it to
> relevant hardware signatures (CPU type and cache sizes), plus doing
> some defaults for when we don't have any signature... possibly based
> on a fuzzy search to find the 'closest' system in the table of
> constants.
>
> That would stabilize the boot-to-boot figures while still keeping most
> of the system specific-ness, in a maintainable fashion.
>
> The downside is that we'd have to continuously maintain a table of all
> this info, with new entries added when new CPUs are introduced on the
> market. That's an upside too, btw.

one way out could be to define "buckets" of values this way, and on
the machine round the calibration to the nearest bucket

(but in practice caches get flushed a LOT if the system is not 100%
busy so not sure if this logic really matters outside of benchmarks)


