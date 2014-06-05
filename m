Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829AbaFENPl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 09:15:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:18134 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbaFENPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 09:15:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,981,1392192000"; 
   d="scan'208";a="552060454"
Message-ID: <53906D78.60509@linux.intel.com>
Date: Thu, 05 Jun 2014 21:15:36 +0800
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Liu ShuoX <shuox.liu@intel.com>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Zhang Yanmin <yanmin.zhang@intel.com>
Subject: Re: [PATCH] perf: fix kernel panic when parsing user space CS saved
 in pt_regs
References: <20140605023610.GA12905@lskakaxi-intel> <20140605071919.GD3213@twins.programming.kicks-ass.net> <20140605073321.GA14869@lskakaxi-intel> <20140605075507.GA6758@twins.programming.kicks-ass.net> <53902398.70005@linux.intel.com> <20140605091517.GB6758@twins.programming.kicks-ass.net>
In-Reply-To: <20140605091517.GB6758@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/6/5 17:15, Peter Zijlstra wrote:
> On Thu, Jun 05, 2014 at 04:00:24PM +0800, Zhang, Yanmin wrote:
>> On 2014/6/5 15:55, Peter Zijlstra wrote:
>>> Why does pstore cause corruption? I thought that stuff was supposed to
>>> be 'good' ?
>> pstore is good if the board is reset by WarmReset as memory content is kept
>> across rebooting.
>> If it's a ColdReset, memory might lose some or all contents. My board uses
>> Coldreset, which is a very
>> fast ColdReset. Most memory content can be kept. But sometimes, some data
>> has little change.
> Oh, I thought pstore was persistent across cold resets or even power
> outages. My bad then.

Sorry for misleading you. It depends on backend. Pstore can use RAM or
other storage, for example, EFI-provided backend. If using EFI backend,
pstore can keep persistent across cold reset or even power outrages.

If using RAM, usually pstore can keep persistent at WarmReset. Since RAM
access (even at non-cache mode) is fast and more flexible, in fact, we often use
RAM as backend of pstore.

