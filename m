Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872AbaLRWo0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 17:44:26 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:18228 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbaLRWoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 17:44:25 -0500
Message-ID: <54935842.5020507@oracle.com>
Date: Thu, 18 Dec 2014 15:42:10 -0700
From: Khalid Aziz <khalid.aziz@oracle.com>
Organization: Oracle Corp
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: tglx@linutronix.de, corbet@lwn.net, mingo@redhat.com, hpa@zytor.com,
        riel@redhat.com, akpm@linux-foundation.org, rientjes@google.com,
        ak@linux.intel.com, mgorman@suse.de, raistlin@linux.it,
        kirill.shutemov@linux.intel.com, atomlin@redhat.com, avagin@openvz.org,
        gorcunov@openvz.org, serge.hallyn@canonical.com, athorlton@sgi.com,
        oleg@redhat.com, vdavydov@parallels.com, daeseok.youn@gmail.com,
        keescook@chromium.org, yangds.fnst@cn.fujitsu.com, sbauer@eng.utah.edu,
        vishnu.ps@samsung.com, axboe@fb.com, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH RESEND v4] sched/fair: Add advisory flag for borrowing
 a timeslice
References: <1418928259-6311-1-git-send-email-khalid.aziz@oracle.com> <20141218222846.GH30905@twins.programming.kicks-ass.net>
In-Reply-To: <20141218222846.GH30905@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2014 03:28 PM, Peter Zijlstra wrote:
> On Thu, Dec 18, 2014 at 11:44:19AM -0700, Khalid Aziz wrote:
>> sched/fair: Add advisory flag for borrowing a timeslice
>
> yuck hatred and much of that.
>
> Also, you fail to explain why a kernel side spin futex-lock is not an
> option.
>

I had explained that when this question came up in the last round of 
discussions. The queuing problem I am trying to solve stems from 
userspace locks. Java and databases implement their own userspace locks 
that do not use futex. Solving this with futex will not help the primary 
users of this solution.

Hope this helps.

Thanks,
Khalid
