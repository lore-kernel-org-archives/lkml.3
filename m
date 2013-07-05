Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933777Ab3GEQmL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 12:42:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35511 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757045Ab3GEQmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 12:42:10 -0400
Message-ID: <51D6F729.8030101@zytor.com>
Date: Fri, 05 Jul 2013 09:41:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Seiji Aguchi <seiji.aguchi@hds.com>
Subject: Re: Yet more softlockups.
References: <20130704015525.GA8486@redhat.com> <CA+55aFykwkTVtZuoCEvwpF+5q1LUscw1shkWNPtGdHu+1DgDJA@mail.gmail.com> <20130705143821.GB325@redhat.com> <alpine.DEB.2.02.1307051710070.32106@ionos.tec.linutronix.de> <20130705160043.GF325@redhat.com> <alpine.DEB.2.02.1307051802070.32106@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1307051802070.32106@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2013 09:02 AM, Thomas Gleixner wrote:
> On Fri, 5 Jul 2013, Dave Jones wrote:
>> On Fri, Jul 05, 2013 at 05:15:07PM +0200, Thomas Gleixner wrote:
>>   > On Fri, 5 Jul 2013, Dave Jones wrote:
>>   >
>>   > > BUG: soft lockup - CPU#3 stuck for 23s! [trinity-child1:14565]
>>   > > perf samples too long (2519 > 2500), lowering kernel.perf_event_max_sample_rate to 50000
>>   > > INFO: NMI handler (perf_event_nmi_handler) took too long to run: 238147.002 msecs
>>   >
>>   > So we see a softlockup of 23 seconds and the perf_event_nmi_handler
>>   > claims it did run 23.8 seconds.
>>   >
>>   > Are there more instances of NMI handler messages ?
>>
>> [ 2552.006181] perf samples too long (2511 > 2500), lowering kernel.perf_event_max_sample_rate to 50000
>> [ 2552.008680] INFO: NMI handler (perf_event_nmi_handler) took too long to run: 500392.002 msecs
>
> Yuck. Spending 50 seconds in NMI context surely explains a softlockup :)
>

Hmmm... this makes me wonder if the interrupt tracepoint stuff is at 
fault here, as it changes the IDT handling for NMI context.

	-hpa

