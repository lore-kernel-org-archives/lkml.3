Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232AbaBYViw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 16:38:52 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:48324 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbaBYViu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 16:38:50 -0500
Message-ID: <530D0D57.4030704@linux.vnet.ibm.com>
Date: Tue, 25 Feb 2014 13:38:31 -0800
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Michael Ellerman <mpe@ellerman.id.au>
CC: Linux PPC <linuxppc-dev@lists.ozlabs.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 02/11] perf core: export swevent hrtimer helpers
References: <1392415338-16288-3-git-send-email-cody@linux.vnet.ibm.com> <20140225033326.7BB942C0228@ozlabs.org> <20140225102008.GI9987@twins.programming.kicks-ass.net>
In-Reply-To: <20140225102008.GI9987@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022521-1542-0000-0000-0000069D52DD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2014 02:20 AM, Peter Zijlstra wrote:
> On Tue, Feb 25, 2014 at 02:33:26PM +1100, Michael Ellerman wrote:
>> On Fri, 2014-14-02 at 22:02:06 UTC, Cody P Schafer wrote:
>>> Export the swevent hrtimer helpers currently only used in events/core.c
>>> to allow the addition of architecture specific sw-like pmus.
>>
>> Peter, Ingo, can we get your ACK on this please?
>
> How are they used? I saw some usage in patch 9 or so; but its not
> explained anywhere. All patches have non-existent Changelogs and the few
> comments that are there are pretty hardware specific.
>
> So please do tell; what do you need this for?

 From this patch's change log:

> Export the swevent hrtimer helpers currently only used in events/core.c to allow the addition of architecture specific sw-like pmus.

The key part here is "architecture specific sw-like pmus", where the 
announcement explains why these pmus are sw-like:

> The counters supplied by these interfaces are continually counting and never
> need to be (and cannot be) disabled or enabled. They additionally do not
> generate any interrupts. This makes them in some regards similar to software
> counters, and as a result their implimentation shares some common code (which
> an initial patch exposes) with the sw counters.

Essentially, these pmus just provide access to a big array of counters 
which don't generate interrupts, and are all 64bit (and assumed to never 
overflow). Rather than duplicate the code that we already have for 
managing timing when reading from counters that don't have interrupts 
(the functions that are exposed by this patch), I've reused it.

