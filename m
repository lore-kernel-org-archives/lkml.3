Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab3LQOEP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 09:04:15 -0500
Received: from mga11.intel.com ([192.55.52.93]:41555 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752958Ab3LQOEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 09:04:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,501,1384329600"; 
   d="scan'208";a="451374127"
Message-ID: <52B059CE.9090709@linux.intel.com>
Date: Tue, 17 Dec 2013 16:03:58 +0200
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
        Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Subject: Re: [PATCH 00/15] cleanups and optimizations
References: <20131212140835.729222186@infradead.org> <52AAE61D.4060406@linux.intel.com> <20131213135626.GL21999@twins.programming.kicks-ass.net> <52AF3CF0.3090502@linux.intel.com> <20131217133204.GK21999@twins.programming.kicks-ass.net>
In-Reply-To: <20131217133204.GK21999@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

n 17/12/2013 15:32, Peter Zijlstra wrote:
> 
> Awesomeness.. you'll work on subtracting the spin time from the sleep
> time?

Me or someone on our team will work on it.

I'm not sure that subtracting the spin time is the optimal thing to do.

The busy poll time is supposed to be limited to something less than 1ms.
(I'm using 50us in most of my tests)
This is typically orders of magnitude smaller than the poll timeout.
Would it make more sense to just enforce a limit on poll time?

What do you think?

Thanks,
Eliezer
