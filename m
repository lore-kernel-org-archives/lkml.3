Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988Ab3JGGH4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 02:07:56 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:37781 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab3JGGHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 02:07:54 -0400
Message-ID: <52524FAA.1030901@in.ibm.com>
Date: Mon, 07 Oct 2013 11:37:38 +0530
From: "Suzuki K. Poulose" <suzuki@in.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130923 Thunderbird/17.0.9
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Janani Venkataraman <jananive@in.ibm.com>, linux-kernel@vger.kernel.org,
        amwang@redhat.com, rdunlap@xenotime.net, aravinda@linux.vnet.ibm.com,
        hch@lst.de, mhiramat@redhat.com, jeremy.fitzhardinge@citrix.com,
        xemul@parallels.com, suzuki@linux.vnet.ibm.com,
        kosaki.motohiro@jp.fujitsu.com, adobriyan@gmail.com,
        tarundsk@linux.vnet.ibm.com, vapier@gentoo.org, roland@hack.frob.com,
        tj@kernel.org, ananth@linux.vnet.ibm.com, gorcunov@openvz.org,
        avagin@openvz.org, oleg@redhat.com, eparis@redhat.com,
        d.hatayama@jp.fujitsu.com, james.hogan@imgtec.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [RFC] [PATCH 00/19] Non disruptive application core dump infrastructure
 using task_work_add()
References: <20131004102532.1612.24185.stgit@f19-x64> <20131004134421.GG6882@two.firstfloor.org>
In-Reply-To: <20131004134421.GG6882@two.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100706-0928-0000-0000-00000230B38A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2013 07:14 PM, Andi Kleen wrote:
> On Fri, Oct 04, 2013 at 04:00:12PM +0530, Janani Venkataraman wrote:
>> Hi all,
>>
>> The following series implements an infrastructure for capturing the core of an 
>> application without disrupting its process.
> 
> The problem is that gcore et.al. have to stop the process briefly
> to attach and then use the pid mmap ptrace interfaces, right?
> 
Correct.

> Couldn't they just use the new process_vm_readv() syscalls instead?
> AFAIK those do not require ptrace.
> 
We need the register set and hence would need a ptrace.

> Then this could be all done in user space.
> 
> Or are there some specific races with this approach?
> 
Cheers
Suzuki

