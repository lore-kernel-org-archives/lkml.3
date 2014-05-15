Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488AbaEOT1c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 15:27:32 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:51183 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552AbaEOT12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 15:27:28 -0400
Message-ID: <537514D3.4060308@linux.vnet.ibm.com>
Date: Fri, 16 May 2014 00:56:11 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: peterz@infradead.org, tglx@linutronix.de, mingo@kernel.org,
        rusty@rustcorp.com.au, akpm@linux-foundation.org, fweisbec@gmail.com,
        hch@infradead.org, mgorman@suse.de, riel@redhat.com, bp@suse.de,
        rostedt@goodmis.org, mgalbraith@suse.de, ego@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, oleg@redhat.com, rjw@rjwysocki.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 3/3] CPU hotplug, smp: Flush any pending IPI callbacks
 before CPU offline
References: <20140515191218.19811.25887.stgit@srivatsabhat.in.ibm.com> <20140515191358.19811.70381.stgit@srivatsabhat.in.ibm.com> <20140515191938.GB21306@htj.dyndns.org>
In-Reply-To: <20140515191938.GB21306@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051519-9264-0000-0000-000006178F99
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2014 12:49 AM, Tejun Heo wrote:
> Hello,
> 
> On Fri, May 16, 2014 at 12:44:13AM +0530, Srivatsa S. Bhat wrote:
>>  /*
>> + * flush_smp_call_function_queue - Flush any pending smp-call-function
> 
> Don't we need a blank line here?
>

Hmm? That sentence continues on the next line, hence I didn't add any blank
line there.

>> + * callbacks queued on this CPU (including those for which the source CPU's
>> + * IPIs might not have been received on this CPU yet). This is invoked by a
>> + * CPU about to go offline, to ensure that all pending IPI functions are run
>> + * before it goes completely offline.
>> + *
>> + * Loop through the call_single_queue and run all the queued functions.
>> + * Must be called with interrupts disabled.
>> + */
> 
> Other than that, looks good to me.
> 
> Reviewed-by: Tejun Heo <tj@kernel.org>
> 

Thank you!

Regards,
Srivatsa S. Bhat

