Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111Ab3LQSVg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 13:21:36 -0500
Received: from mga01.intel.com ([192.55.52.88]:15566 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755951Ab3LQSVd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 13:21:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,502,1384329600"; 
   d="scan'208";a="451527140"
Message-ID: <52B095C9.7040105@linux.intel.com>
Date: Tue, 17 Dec 2013 20:19:53 +0200
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Arjan van de Ven <arjan@linux.intel.com>, lenb@kernel.org,
        rjw@rjwysocki.net, rui.zhang@intel.com, jacob.jun.pan@linux.intel.com,
        Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>,
        hpa@zytor.com, paulmck@linux.vnet.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
        Eliezer Tamir <eliezer@tamir.org.il>
Subject: Re: [PATCH 00/15] cleanups and optimizations
References: <20131212140835.729222186@infradead.org> <52AAE61D.4060406@linux.intel.com> <20131213135626.GL21999@twins.programming.kicks-ass.net> <52AF3CF0.3090502@linux.intel.com> <20131217133204.GK21999@twins.programming.kicks-ass.net> <52B059CE.9090709@linux.intel.com> <20131217151337.GN21999@twins.programming.kicks-ass.net>
In-Reply-To: <20131217151337.GN21999@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/12/2013 17:13, Peter Zijlstra wrote:
> On Tue, Dec 17, 2013 at 04:03:58PM +0200, Eliezer Tamir wrote:
>>
>> I'm not sure that subtracting the spin time is the optimal thing to do.
>>
>> The busy poll time is supposed to be limited to something less than 1ms.
>> (I'm using 50us in most of my tests)
>> This is typically orders of magnitude smaller than the poll timeout.
>> Would it make more sense to just enforce a limit on poll time?
>>
>> What do you think?
> 
> I've no idea what people normally expect of select/poll wakeup
> granularity but typically we already have 50us of timer slack, although
> RT tasks go without this.

If RT tasks can't accept 50us of fuzziness, then the
path of least astonishment would be to have fully accurate
timekeeping, as you suggested. OK, so that's the plan.

Thanks,
Eliezer

