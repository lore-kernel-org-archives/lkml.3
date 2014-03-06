Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009AbaCFCx6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 21:53:58 -0500
Received: from relay3.sgi.com ([192.48.152.1]:46371 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757436AbaCFCx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 21:53:57 -0500
Message-ID: <5317E33F.5000206@sgi.com>
Date: Wed, 05 Mar 2014 18:53:51 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Hedi Berriche <hedi@sgi.com>,
        Dimitri Sivanich <sivanich@sgi.com>
Subject: Re: [PATCH 31/48] uv: Replace __get_cpu_var
References: <20140214201841.826179349@linux.com> <20140214201907.228035121@linux.com> <20140304150217.ac9d364008a3c95cb2a79b34@linux-foundation.org> <alpine.DEB.2.10.1403042130250.3742@nuc> <20140304200023.7b991909.akpm@linux-foundation.org> <alpine.DEB.2.10.1403051547140.16786@nuc>
In-Reply-To: <alpine.DEB.2.10.1403051547140.16786@nuc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 3/5/2014 1:57 PM, Christoph Lameter wrote:
> The driver seems to use local64_t to define a single static instance of a
> counter and then seems to think that it is safe to increment the counter
> from multiple processors using local64_inc and friends. Common
> misunderstanding and a reason why I wanted the this_cpu operations.
> 
> The counters seem to be exported via module parameters.. So I guess we
> need to define these per cpu and then sum them up when they need to be
> displayed.
> 
> Dimitri?
> 
> Maybe lets move this outside of this patchset.
> 

Hi Christoph,

I haven't had much chance yet to look over your proposed changes but
FYI, the counters are strictly feedback to insure that there are not
unhandled NMI events from the perf subsystem.  The exact count is
irrelevant.  IOW, counts in the double or triple digits is okay,
counts > 100,000 is definitely not okay (there are multiple millions
of perf events every 'perf top' refresh.)

I'm not sure if this alters how you want to approach the changes.

Thanks,
Mike
