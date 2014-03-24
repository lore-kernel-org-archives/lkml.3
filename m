Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634AbaCXJjG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 05:39:06 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:37739 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbaCXJjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 05:39:02 -0400
Message-ID: <532FFD2C.1020004@linux.vnet.ibm.com>
Date: Mon, 24 Mar 2014 15:08:52 +0530
From: Janani Venkataraman <jananive@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Karel Zak <kzak@redhat.com>
CC: linux-kernel@vger.kernel.org, amwang@redhat.com, rdunlap@xenotime.net,
        andi@firstfloor.org, aravinda@linux.vnet.ibm.com, hch@lst.de,
        mhiramat@redhat.com, jeremy.fitzhardinge@citrix.com,
        xemul@parallels.com, suzuki@linux.vnet.ibm.com,
        kosaki.motohiro@jp.fujitsu.com, adobriyan@gmail.com,
        tarundsk@linux.vnet.ibm.com, vapier@gentoo.org, roland@hack.frob.com,
        tj@kernel.org, ananth@linux.vnet.ibm.com, gorcunov@openvz.org,
        avagin@openvz.org, oleg@redhat.com, eparis@redhat.com,
        d.hatayama@jp.fujitsu.com, james.hogan@imgtec.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        coreutils@gnu.org, procps@freelists.org, util-linux@vger.kernel.org
Subject: Re: [PATCH 00/33] [RFC] Non disruptive application core dump infrastructure
References: <20140320093040.14878.903.stgit@localhost.localdomain> <20140321080855.GE26374@x2.net.home>
In-Reply-To: <20140321080855.GE26374@x2.net.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032409-5816-0000-0000-00000D01884A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 03/21/2014 01:47 PM, Karel Zak wrote:
> On Thu, Mar 20, 2014 at 03:09:03PM +0530, Janani Venkataraman wrote:
>> Gencore Daemon
>>
>> The programs can request a dump using gencore() API, provided through
>> libgencore. This is implemented through a daemon which listens on a UNIX File
>> socket. The daemon is started immediately post installation.
>   The gencore command looks like a good idea, but why we need the
>   client-server infrastructure? At least at first glance it seems
>   like overkill.
We are also looking at a process being able to do a self dump. ptrace 
SEIZE/INTERRUPT
cannot be used on one-self and hencewe need to offload the dump another 
'process'.
Since we can't fork(), as it is not signal safe, we need a dedicated 
process to handle
such requests. Hence the server.

https://lkml.org/lkml/2013/9/3/122


>> We would like to push this to one of the following packages:
>> a) util-linux
>> b) coreutils
>> c) procps-ng
>    d) somewhere near to gdb :-)
>
>      Karel
>

