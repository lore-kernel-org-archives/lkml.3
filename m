Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757027Ab3IKT1I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 15:27:08 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:60298 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab3IKT1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 15:27:06 -0400
Message-ID: <5230C405.8040108@gmail.com>
Date: Wed, 11 Sep 2013 15:27:01 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Janani Venkataraman <jananive@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org,
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
        ananth@in.ibm.com, suzuki@in.ibm.com, aravinda@linux.vnet.ibm.com,
        tarundeep.singh@in.ibm.com, kosaki.motohiro@gmail.com
Subject: Re: RFD: Non-Disruptive Core Dump Infrastructure
References: <522472DA.4000702@linux.vnet.ibm.com> <5225A02B.6080901@linux.vnet.ibm.com>
In-Reply-To: <5225A02B.6080901@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(9/3/13 4:39 AM), Janani Venkataraman wrote:
> Hello,
>
> We are working on an infrastructure to create a system core file of a specific
> process at run-time, non-disruptively. It can also be extended to a case where
> a process is able to take a self-core dump.
>
> gcore, an existing utility creates a core image of the specified process. It
> attaches to the process using gdb and runs the gdb gcore command and then
> detaches. In gcore the dump cannot be issued from a signal handler context as
> fork() is not signal safe and moreover it is disruptive in nature as the gdb
> attaches using ptrace which sends a SIGSTOP signal. Hence the gcore method
> cannot be used if the process wants to initiate a self dump.

Maybe I'm missing something. But why gcore uses c-level fork()? gcore need to
call pthread-at-fork handler? No. gcore need to flush stdio buffer? No.
