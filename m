Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab3DOQlW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 12:41:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:16635 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753559Ab3DOQlU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 12:41:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,476,1363158000"; 
   d="scan'208";a="295187771"
Message-ID: <516C2DAF.6010908@linux.intel.com>
Date: Mon, 15 Apr 2013 09:41:19 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: paulmck@linux.vnet.ibm.com, Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH documentation 1/2] nohz1: Add documentation.
References: <20130411160524.GA30384@linux.vnet.ibm.com> <1365696359-30958-1-git-send-email-paulmck@linux.vnet.ibm.com> <20130411182502.GA31684@pd.tnic> <20130411191355.GO29861@linux.vnet.ibm.com> <1365753904.17140.22.camel@laptop> <20130412175419.GG29861@linux.vnet.ibm.com> <51684AD3.7090305@linux.intel.com> <0000013e0e6cacbb-b7e44c6f-d551-49b9-aa07-62a4ee280ae7-000000@email.amazonses.com>
In-Reply-To: <0000013e0e6cacbb-b7e44c6f-d551-49b9-aa07-62a4ee280ae7-000000@email.amazonses.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/15/2013 9:00 AM, Christoph Lameter wrote:
> On Fri, 12 Apr 2013, Arjan van de Ven wrote:
>
>> but arguably, that's because of HRTIMERS more than NOHZ
>> (e.g. I bet we still turn off periodic even for nohz as long as hrtimers are
>> enabled)
>
> If we are able to only get rid of one timer tick on average with dynticks
> then I would think that is enough to justify having it on by default.
>
> If the scheduling period from the schduler is around 20ms then one may be
> able to save processing 20 timer ticks by going to htimers.
>
> The main issue with hrtimers is likely going to be that is it is too much
> effort for small timerframes less than 10ms. Could we  only switch off the
> timer tick if the next event is more than 10 ticks aways?
>

to put the "cost" into perspective; programming a timer in one-shot mode
is some math on the cpu (to go from kernel time to hardware time),
which is a multiply and a shift (or a divide), and then actually
programming the hardware, which is at the cost of (approximately) a cachemiss or two
(so give or take in the "hundreds" of cycles)
at least on moderately modern hardware (e.g. last few years)

not cheap. But also not INSANE expensive... and it breaks-even already if you only
save one or two cache misses elsewhere.

