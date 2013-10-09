Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910Ab3JII61 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 04:58:27 -0400
Received: from relay.parallels.com ([195.214.232.42]:45082 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab3JII6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 04:58:24 -0400
Message-ID: <52551A8F.5080904@parallels.com>
Date: Wed, 9 Oct 2013 12:57:51 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Janani Venkataraman1 <jananive@in.ibm.com>
CC: <adobriyan@gmail.com>, <akpm@linux-foundation.org>, <amwang@redhat.com>,
        <ananth@linux.vnet.ibm.com>, <andi@firstfloor.org>,
        <aravinda@linux.vnet.ibm.com>, <avagin@openvz.org>,
        <d.hatayama@jp.fujitsu.com>, <eparis@redhat.com>,
        <gorcunov@openvz.org>, <hch@lst.de>, <james.hogan@imgtec.com>,
        <jeremy.fitzhardinge@citrix.com>, <kosaki.motohiro@jp.fujitsu.com>,
        <linux-kernel@vger.kernel.org>, <mhiramat@redhat.com>,
        <oleg@redhat.com>, <rdunlap@xenotime.net>, <roland@hack.frob.com>,
        <suzuki@linux.vnet.ibm.com>, <tarundsk@linux.vnet.ibm.com>,
        <tj@kernel.org>, <torvalds@linux-foundation.org>, <vapier@gentoo.org>
Subject: Re: [RFC] [PATCH 00/19] Non disruptive application core dump infrastructure
 using task_work_add()
References: <20131004102532.1612.24185.stgit@f19-x64> <524E9AB3.2080307@parallels.com> <OFE96703A1.612D0E95-ON65257BFE.00379B31-65257BFE.0037FF3B@in.ibm.com>
In-Reply-To: <OFE96703A1.612D0E95-ON65257BFE.00379B31-65257BFE.0037FF3B@in.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.16.114]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2013 02:12 PM, Janani Venkataraman1 wrote:
> 
> 
> 
> 
> From:	Pavel Emelyanov <xemul@parallels.com>
> To:	Janani Venkataraman1/India/IBM@IBMIN,
> Cc:	<linux-kernel@vger.kernel.org>, <amwang@redhat.com>,
>             <rdunlap@xenotime.net>, <andi@firstfloor.org>,
>             <aravinda@linux.vnet.ibm.com>, <hch@lst.de>,
>             <mhiramat@redhat.com>, <jeremy.fitzhardinge@citrix.com>,
>             <suzuki@linux.vnet.ibm.com>, <kosaki.motohiro@jp.fujitsu.com>,
>             <adobriyan@gmail.com>, <tarundsk@linux.vnet.ibm.com>,
>             <vapier@gentoo.org>, <roland@hack.frob.com>, <tj@kernel.org>,
>             <ananth@linux.vnet.ibm.com>, <gorcunov@openvz.org>,
>             <avagin@openvz.org>, <oleg@redhat.com>, <eparis@redhat.com>,
>             <d.hatayama@jp.fujitsu.com>, <james.hogan@imgtec.com>,
>             <akpm@linux-foundation.org>, <torvalds@linux-foundation.org>
> Date:	10/04/2013 04:08 PM
> Subject:	Re: [RFC] [PATCH 00/19] Non disruptive application core dump
>             infrastructure using task_work_add()
> 
> 
> 
> On 10/04/2013 02:30 PM, Janani Venkataraman wrote:
>> Hi all,
>>
> 
>> This series is based on the Task work add approach. We didn't adopt the
> CRIU
>> approch because of the following reasons:
>>
>> * It is not upstream yet.
> 
> It is, starting from criu-v0.7 + linux-3.11
> 
>> * There are concerns about the security of the dump.
> 
> Can you elaborate on this? Is it fixable in CRIU at all?
> 
>> * It involves a lot of changes and this approach provides a UNIX style
>>   interface.
> 
> Can you also shed more light on this -- what changes do you mean?
> 
> We had a prototype ready earlier using the freezer approach.
> http://lwn.net/Articles/419756/
> 
> We made a couple of minor changes to it and implemented using task work
> add.
> We  wanted to know what the community felt about this approach.
> 
> Also in the previous RFD, Andi Kleen had mentioned a concern on the
> security with
> respect to the daemon approach for a self dump in CRIU.

We have this thing addressed -- when one requests a self-dump from criu daemon
the latter 

a) gets pid to dump from SO_PEERCRED, thus requester cannot just send some other's pid
b) doesn't dump tasks that belong to user other than the one who requested the dump

What other security concerns do you have? We're also interested in addressing them.

> Thanks.
> Janani
> 
> .
> 


