Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501AbaJALRB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 07:17:01 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:26986 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbaJALRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 07:17:00 -0400
Message-ID: <542BE27B.6040006@oracle.com>
Date: Wed, 01 Oct 2014 07:16:11 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Cong Wang <cwang@twopensource.com>,
        Vince Weaver <vincent.weaver@maine.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: perf: perf_fuzzer triggers instant reboot
References: <alpine.DEB.2.11.1409091352260.15874@vincent-weaver-1.umelst.maine.edu> <20140910083136.GP6758@twins.programming.kicks-ass.net> <alpine.DEB.2.11.1409100914410.8981@vincent-weaver-1.umelst.maine.edu> <541059C9.1040200@oracle.com> <alpine.DEB.2.11.1409101027250.8981@vincent-weaver-1.umelst.maine.edu> <20140910143306.GD4783@worktop.ger.corp.intel.com> <alpine.DEB.2.11.1409110926120.11483@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.11.1409250052480.26664@vincent-weaver-1.umelst.maine.edu> <CAHA+R7Nu_2KORkf9uP1_HktRA+MLy6TS4vXCPS9Q_JzrcH2SYg@mail.gmail.com> <542789E5.7090805@oracle.com> <20140930172308.GI4241@worktop.programming.kicks-ass.net>
In-Reply-To: <20140930172308.GI4241@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2014 01:23 PM, Peter Zijlstra wrote:
> How about this then?
> 
> ---
> Subject: perf: Fix unclone_ctx() vs locking
> 
> The idiot who did 4a1c0f262f88 forgot to pay attention and fix all
> similar cases. Do so now.
> 
> In particular, unclone_ctx() must be called while holding ctx->lock,
> therefore all such sites are broken for the same reason. Pull the
> put_ctx() call out from under ctx->lock.
> 
> Reported-by: Sasha Levin <sasha.levin@oracle.com>
> Fixes: 4a1c0f262f88 ("perf: Fix lockdep warning on process exit")
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>

Looks good! The issue didn't reproduce anymore.


Thanks,
Sasha
