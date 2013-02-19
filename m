Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933555Ab3BSSbi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:31:38 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:40340 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933537Ab3BSSbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:31:35 -0500
Message-ID: <5123C482.5070704@linux.vnet.ibm.com>
Date: Tue, 19 Feb 2013 23:59:22 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
CC: tglx@linutronix.de, peterz@infradead.org, tj@kernel.org, oleg@redhat.com,
        paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au, mingo@kernel.org,
        akpm@linux-foundation.org, namhyung@kernel.org, rostedt@goodmis.org,
        wangyun@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com,
        rjw@sisk.pl, sbw@mit.edu, fweisbec@gmail.com, linux@arm.linux.org.uk,
        nikunj@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 29/45] x86/xen: Use get/put_online_cpus_atomic() to
 prevent CPU offline
References: <20130122073210.13822.50434.stgit@srivatsabhat.in.ibm.com> <20130122074046.13822.61950.stgit@srivatsabhat.in.ibm.com> <20130219181038.GB18244@phenom.dumpdata.com>
In-Reply-To: <20130219181038.GB18244@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13021918-8878-0000-0000-000005F4B994
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2013 11:40 PM, Konrad Rzeszutek Wilk wrote:
> On Tue, Jan 22, 2013 at 01:10:51PM +0530, Srivatsa S. Bhat wrote:
>> Once stop_machine() is gone from the CPU offline path, we won't be able to
>> depend on preempt_disable() or local_irq_disable() to prevent CPUs from
>> going offline from under us.
>>
>> Use the get/put_online_cpus_atomic() APIs to prevent CPUs from going offline,
>> while invoking from atomic context.
>>
>> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> 
> Weird. I see this in the patch but I don't see it in the header?

Meaning, you didn't get this email at all?

> Did you
> explicitly suppress the CC part?
> 

No.. I sent the entire patchset to a set of email ids and in addition to
that I CC'ed individual patches to the respective maintainers/lists (the
CC: list in the changelog). I used the --auto knob from stgit to do that.

> 
> Anyhow, the patch looks sane enough, thought I need to to run it through
> a test framework just to be on a sure side.
>

Sure, thank you. But you might want to test the v6 that I sent out
yesterday instead of v5. Oh, wait a min, you didn't get the v6 mail also?

Here it is, for your reference:
http://marc.info/?l=linux-kernel&m=136119260122255&w=2

Regards,
Srivatsa S. Bhat

>> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
>> Cc: "H. Peter Anvin" <hpa@zytor.com>
>> Cc: x86@kernel.org
>> Cc: xen-devel@lists.xensource.com
>> Cc: virtualization@lists.linux-foundation.org
>> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
>> ---

