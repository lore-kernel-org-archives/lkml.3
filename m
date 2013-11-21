Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530Ab3KUQVH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 11:21:07 -0500
Received: from mga02.intel.com ([134.134.136.20]:22010 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609Ab3KUQVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 11:21:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,745,1378882800"; 
   d="scan'208";a="439294736"
Message-ID: <528E32EF.2050300@linux.intel.com>
Date: Thu, 21 Nov 2013 08:21:03 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com, Peter Zijlstra <peterz@infradead.org>
CC: Jacob Pan <jacob.jun.pan@linux.intel.com>, lenb@kernel.org,
        rjw@rjwysocki.net, Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        Chris Leech <christopher.leech@intel.com>,
        David Miller <davem@davemloft.net>, rui.zhang@intel.com,
        Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>,
        hpa@zytor.com, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH 3/7] idle, thermal, acpi: Remove home grown idle implementations
References: <20131120160450.072555619@infradead.org> <20131120162736.508462614@infradead.org> <20131120165406.14fa0f09@ultegra> <20131121082151.GU10022@twins.programming.kicks-ass.net> <20131121160716.GT4138@linux.vnet.ibm.com>
In-Reply-To: <20131121160716.GT4138@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2013 8:07 AM, Paul E. McKenney wrote:
> As long as RCU has some reliable way to identify an idle task, I am
> good.  But I have to ask -- why can't idle injection coordinate with
> the existing idle tasks rather than temporarily making alternative
> idle tasks?

it's not a real idle. that's the whole problem of the situation.
to the rest of the OS, this is being BUSY (busy saving power using
a CPU instruction, but it might as well have been an mdelay() operation)
and it's also what end users expect; they want to be able to see
where there performance (read: cpu time in "top") is going.

