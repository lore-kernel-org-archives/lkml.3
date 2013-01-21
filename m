Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab3AUJDW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 04:03:22 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:7894 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329Ab3AUJDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 04:03:19 -0500
Message-ID: <50FD0402.6060400@huawei.com>
Date: Mon, 21 Jan 2013 17:01:54 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Daniel Wagner <wagi@monom.org>
CC: John Fastabend <john.r.fastabend@intel.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Daniel Wagner <daniel.wagner@bmw-carit.de>,
        LKML <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Subject: Re: [BUG] Bug in netprio_cgroup and netcls_cgroup ?
References: <50FCDB5C.4050608@huawei.com> <50FD0144.1000401@monom.org>
In-Reply-To: <50FD0144.1000401@monom.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/1/21 16:50, Daniel Wagner wrote:
> Hi Li,
> 
> On 21.01.2013 07:08, Li Zefan wrote:
>> I'm not a network developer, so correct me if I'm wrong.
>>
>> Since commit 7955490f732c2b8
>> ("net: netprio_cgroup: rework update socket logic"), sock->sk->sk_cgrp_prioidx
>> is set when the socket is created, and won't be updated unless the task is
>> moved to another cgroup.
>>
>> Now the problem is, a socket can be _shared_ by multiple processes (fork, SCM_RIGHT).
>> If we place those processes in different cgroups, and each cgroup has
>> different configs, but all of the processes will send data via this socket
>> with the same network priority.
> 
> Wouldn't that be addressed by 48a87cc26c13b68f6cce4e9d769fcb17a6b3e4b8
> 
>    net: netprio: fd passed in SCM_RIGHTS datagram not set correctly
> 
>     A socket fd passed in a SCM_RIGHTS datagram was not getting
>     updated with the new tasks cgrp prioidx. This leaves IO on
>     the socket tagged with the old tasks priority.
> 
>     To fix this add a check in the scm recvmsg path to update the
>     sock cgrp prioidx with the new tasks value.
> 
> As I read this this should work for net_prio.
> 

But after process A passed the socket fd to B, both A and B can use the
same socket to send data, right? Then if A and B were placed in different
cgroups with differnt configs, A's config won't take effect anymore.

Am I missing something?


