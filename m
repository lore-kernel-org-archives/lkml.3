Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751793AbaANR7Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 12:59:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54223 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500AbaANR7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 12:59:18 -0500
Message-ID: <52D57AC2.3090109@zytor.com>
Date: Tue, 14 Jan 2014 09:58:26 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
CC: Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Li Zefan <lizefan@huawei.com>,
        "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] x86: Add Cache QoS Monitoring (CQM) support
References: <20140106180636.GG30183@twins.programming.kicks-ass.net> <1389039035.32504.35.camel@ppwaskie-mobl.amr.corp.intel.com> <20140106212623.GH30183@twins.programming.kicks-ass.net> <1389044899.32504.43.camel@ppwaskie-mobl.amr.corp.intel.com> <20140106221251.GJ30183@twins.programming.kicks-ass.net> <1389048315.32504.57.camel@ppwaskie-mobl.amr.corp.intel.com> <20140107083440.GL30183@twins.programming.kicks-ass.net> <1389107743.32504.69.camel@ppwaskie-mobl.amr.corp.intel.com> <20140107211229.GF2480@laptop.programming.kicks-ass.net> <1389380100.32504.172.camel@ppwaskie-mobl.amr.corp.intel.com> <20140113075528.GR7572@laptop.programming.kicks-ass.net>
In-Reply-To: <20140113075528.GR7572@laptop.programming.kicks-ass.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2014 11:55 PM, Peter Zijlstra wrote:
> 
> The problem is, since there's a limited number of RMIDs we have to
> rotate at some point, but since changing RMIDs is nondeterministic we
> can't.
> 

This is fundamentally the crux here.  RMIDs are quite expensive for the
hardware to implement, so they are limited - but recycling them is
*very* expensive because you literally have to touch every line in the
cache.

	-hpa


