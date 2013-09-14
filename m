Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393Ab3INCru (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 22:47:50 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47222 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860Ab3INCrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 22:47:49 -0400
Message-ID: <5233CE44.7080605@jp.fujitsu.com>
Date: Fri, 13 Sep 2013 22:47:32 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: suzuki@in.ibm.com
CC: kosaki.motohiro@gmail.com, jananive@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, jeremy.fitzhardinge@citrix.com,
        d.hatayama@jp.fujitsu.com, andi@firstfloor.org, roland@hack.frob.com,
        amwang@redhat.com, hch@lst.de, torvalds@linux-foundation.org,
        kosaki.motohiro@jp.fujitsu.com, mhiramat@redhat.com,
        akpm@linux-foundation.org, adobriyan@gmail.com, xemul@parallels.com,
        oleg@redhat.com, tj@kernel.org, avagin@openvz.org, gorcunov@openvz.org,
        james.hogan@imgtec.com, vapier@gentoo.org, rdunlap@xenotime.net,
        eparis@redhat.com, ananth@in.ibm.com, aravinda@linux.vnet.ibm.com,
        tarundeep.singh@in.ibm.com
Subject: Re: RFD: Non-Disruptive Core Dump Infrastructure
References: <522472DA.4000702@linux.vnet.ibm.com> <5225A02B.6080901@linux.vnet.ibm.com> <5230C405.8040108@gmail.com> <523146F1.7060905@in.ibm.com>
In-Reply-To: <523146F1.7060905@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/12/2013 12:45 AM, Suzuki K. Poulose wrote:
> On 09/12/2013 12:57 AM, KOSAKI Motohiro wrote:
>> (9/3/13 4:39 AM), Janani Venkataraman wrote:
>>> Hello,
>>>
>>> We are working on an infrastructure to create a system core file of a
>>> specific
>>> process at run-time, non-disruptively. It can also be extended to a
>>> case where
>>> a process is able to take a self-core dump.
>>>
>>> gcore, an existing utility creates a core image of the specified
>>> process. It
>>> attaches to the process using gdb and runs the gdb gcore command and then
>>> detaches. In gcore the dump cannot be issued from a signal handler
>>> context as
>>> fork() is not signal safe and moreover it is disruptive in nature as
>>> the gdb
>>> attaches using ptrace which sends a SIGSTOP signal. Hence the gcore
>>> method
>>> cannot be used if the process wants to initiate a self dump.
>>
>> Maybe I'm missing something. But why gcore uses c-level fork()? gcore
>> need to
>> call pthread-at-fork handler? No. gcore need to flush stdio buffer? No.
>>
> Let me clarify. If an application wants to dump itself, it has to do a
> fork() and then exec the gcore with the pid of the appication to
> generate the dump.

Oh, I did think the fork() is used for no application stop dump. But it is
incorrect.

Hmm. However, if an application _itself_ want to dump itself. They can avoid
to use signal handler properly. I'm missing the point of this discussion
completely.

So, I'd keep silence while.

> 
> So, if the application wants to initiate the dump from a signal handler
> context, it may lead to trouble.


