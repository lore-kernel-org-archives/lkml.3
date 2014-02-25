Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbaBYErL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 23:47:11 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:34894 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558AbaBYErJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 23:47:09 -0500
Message-ID: <530C2045.1090704@linux.vnet.ibm.com>
Date: Tue, 25 Feb 2014 12:47:01 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Sasha Levin <sasha.levin@oracle.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched: hang in migrate_swap
References: <5304F32A.4040907@oracle.com> <5305856F.3000109@linux.vnet.ibm.com> <53078241.3060201@oracle.com> <53080122.609@linux.vnet.ibm.com> <530ABB44.5000601@oracle.com> <530AD653.3000808@linux.vnet.ibm.com> <20140224071028.GW9987@twins.programming.kicks-ass.net> <530B1B80.4000307@linux.vnet.ibm.com> <20140224121218.GR15586@twins.programming.kicks-ass.net> <20140224131025.GG3104@twins.programming.kicks-ass.net>
In-Reply-To: <20140224131025.GG3104@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022504-8256-0000-0000-00000BA1A2DB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2014 09:10 PM, Peter Zijlstra wrote:
> On Mon, Feb 24, 2014 at 01:12:18PM +0100, Peter Zijlstra wrote:
>> +		if (p) {
>> +			if (unlikely(p == RETRY_TASK))
>> +				goto again;
> 
> We could even make that: unlikely(p & 1), I think most CPUs can encode
> that far better than the full pointer immediate.

Agree, unless odd-align stuff appeared...

Regards,
Michael Wang

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

