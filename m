Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab3ILEqC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 00:46:02 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:57338 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753322Ab3ILEqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 00:46:00 -0400
Message-ID: <523146F1.7060905@in.ibm.com>
Date: Thu, 12 Sep 2013 10:15:37 +0530
From: "Suzuki K. Poulose" <suzuki@in.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
CC: Janani Venkataraman <jananive@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>,
        Roland McGrath <roland@hack.frob.com>,
        Amerigo Wang <amwang@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>, xemul@parallels.com,
        Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
        avagin@openvz.org, gorcunov@openvz.org,
        James Hogan <james.hogan@imgtec.com>,
        Mike Frysinger <vapier@gentoo.org>,
        "Randy.Dunlap" <rdunlap@xenotime.net>, Eric Paris <eparis@redhat.com>,
        ananth@in.ibm.com, aravinda@linux.vnet.ibm.com,
        tarundeep.singh@in.ibm.com
Subject: Re: RFD: Non-Disruptive Core Dump Infrastructure
References: <522472DA.4000702@linux.vnet.ibm.com> <5225A02B.6080901@linux.vnet.ibm.com> <5230C405.8040108@gmail.com>
In-Reply-To: <5230C405.8040108@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091204-9332-0000-0000-00000163D914
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2013 12:57 AM, KOSAKI Motohiro wrote:
> (9/3/13 4:39 AM), Janani Venkataraman wrote:
>> Hello,
>>
>> We are working on an infrastructure to create a system core file of a
>> specific
>> process at run-time, non-disruptively. It can also be extended to a
>> case where
>> a process is able to take a self-core dump.
>>
>> gcore, an existing utility creates a core image of the specified
>> process. It
>> attaches to the process using gdb and runs the gdb gcore command and then
>> detaches. In gcore the dump cannot be issued from a signal handler
>> context as
>> fork() is not signal safe and moreover it is disruptive in nature as
>> the gdb
>> attaches using ptrace which sends a SIGSTOP signal. Hence the gcore
>> method
>> cannot be used if the process wants to initiate a self dump.
> 
> Maybe I'm missing something. But why gcore uses c-level fork()? gcore
> need to
> call pthread-at-fork handler? No. gcore need to flush stdio buffer? No.
> 
Let me clarify. If an application wants to dump itself, it has to do a
fork() and then exec the gcore with the pid of the appication to
generate the dump.

So, if the application wants to initiate the dump from a signal handler
context, it may lead to trouble.

Thanks
Suzuki

