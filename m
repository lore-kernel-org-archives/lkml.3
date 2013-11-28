Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757618Ab3K1QtK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 11:49:10 -0500
Received: from mga02.intel.com ([134.134.136.20]:2659 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045Ab3K1QtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 11:49:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,791,1378882800"; 
   d="scan'208";a="443769161"
Message-ID: <529773FC.6020707@linux.intel.com>
Date: Thu, 28 Nov 2013 18:49:00 +0200
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Arjan van de Ven <arjan@linux.intel.com>, lenb@kernel.org,
        rjw@rjwysocki.net, David Miller <davem@davemloft.net>,
        rui.zhang@intel.com, jacob.jun.pan@linux.intel.com,
        Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>,
        hpa@zytor.com, Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH 7/8] sched, net: Fixup busy_loop_us_clock()
References: <20131126155743.116756708@infradead.org> <20131126160815.293633156@infradead.org>
In-Reply-To: <20131126160815.293633156@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/11/2013 17:57, Peter Zijlstra wrote:
> 
> Replace sched_clock() usage with local_clock() which has a bounded
> drift between CPUs (<2 jiffies).
> 

Peter,

I have tested this patch and I see a performance regression of about
1.5%.

Maybe it would be better, rather then testing in the fast path, to
simply disallow busy polling altogether when sched_clock_stable is
not true?

Thanks,
Eliezer
