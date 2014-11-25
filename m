Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131AbaKYKNF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:13:05 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:49551 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbaKYKNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:13:01 -0500
Date: Tue, 25 Nov 2014 15:42:38 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Khalid Aziz <khalid.aziz@oracle.com>
Cc: tglx@linutronix.de, corbet@lwn.net, mingo@redhat.com, hpa@zytor.com,
        peterz@infradead.org, riel@redhat.com, akpm@linux-foundation.org,
        rientjes@google.com, ak@linux.intel.com, mgorman@suse.de,
        liwanp@linux.vnet.ibm.com, raistlin@linux.it,
        kirill.shutemov@linux.intel.com, atomlin@redhat.com, avagin@openvz.org,
        gorcunov@openvz.org, serge.hallyn@canonical.com, athorlton@sgi.com,
        oleg@redhat.com, vdavydov@parallels.com, daeseok.youn@gmail.com,
        keescook@chromium.org, yangds.fnst@cn.fujitsu.com, sbauer@eng.utah.edu,
        vishnu.ps@samsung.com, axboe@fb.com, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH v3] sched/fair: Add advisory flag for borrowing a
 timeslice (was: Pre-emption control for userspace)
Message-ID: <20141125101238.GA19795@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <1416862595-24513-1-git-send-email-khalid.aziz@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1416862595-24513-1-git-send-email-khalid.aziz@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112510-0021-0000-0000-0000026EBB14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> - Request to borrow timeslice is not guranteed to be honored.
> - If the task is allowed to borrow, kernel will inform the task
>   of this. When this happens, task must yield the processor as soon
>   as it completes its critical section.
> - If the task fails to yield processor after being allowed to
>   borrow, it is penalized by forcing it to skip its next time slot
>   by the scheduler.
> - Task is charged additional time for the borrowed timeslice as
>   accumulated run time. This pushes it further down in consideration
>   for the next task to run.
> 

Is there a way for us to identify if the lock is contended?
Because it may not be prudent to allow a task to borrow timeslice for a
lock which isnt contended.

-- 
Thanks and Regards
Srikar Dronamraju

