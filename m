Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab3AUJ1a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 04:27:30 -0500
Received: from hotel311.server4you.de ([85.25.146.15]:43929 "EHLO
	hotel311.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558Ab3AUJ12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 04:27:28 -0500
Message-ID: <50FD09FD.4010804@monom.org>
Date: Mon, 21 Jan 2013 10:27:25 +0100
From: Daniel Wagner <wagi@monom.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Li Zefan <lizefan@huawei.com>
CC: John Fastabend <john.r.fastabend@intel.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Daniel Wagner <daniel.wagner@bmw-carit.de>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        Cgroups <cgroups@vger.kernel.org>
Subject: Re: [BUG] Bug in netprio_cgroup and netcls_cgroup ?
References: <50FCDB5C.4050608@huawei.com> <50FD0144.1000401@monom.org> <50FD0402.6060400@huawei.com>
In-Reply-To: <50FD0402.6060400@huawei.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.01.2013 10:01, Li Zefan wrote:
> On 2013/1/21 16:50, Daniel Wagner wrote:
>> Hi Li,
>>
>> On 21.01.2013 07:08, Li Zefan wrote:
>>> I'm not a network developer, so correct me if I'm wrong.
>>>
>>> Since commit 7955490f732c2b8
>>> ("net: netprio_cgroup: rework update socket logic"), sock->sk->sk_cgrp_prioidx
>>> is set when the socket is created, and won't be updated unless the task is
>>> moved to another cgroup.
>>>
>>> Now the problem is, a socket can be _shared_ by multiple processes (fork, SCM_RIGHT).
>>> If we place those processes in different cgroups, and each cgroup has
>>> different configs, but all of the processes will send data via this socket
>>> with the same network priority.
>>
>> Wouldn't that be addressed by 48a87cc26c13b68f6cce4e9d769fcb17a6b3e4b8
>>
>>     net: netprio: fd passed in SCM_RIGHTS datagram not set correctly
>>
>>      A socket fd passed in a SCM_RIGHTS datagram was not getting
>>      updated with the new tasks cgrp prioidx. This leaves IO on
>>      the socket tagged with the old tasks priority.
>>
>>      To fix this add a check in the scm recvmsg path to update the
>>      sock cgrp prioidx with the new tasks value.
>>
>> As I read this this should work for net_prio.
>>
> 
> But after process A passed the socket fd to B, both A and B can use the
> same socket to send data, right? Then if A and B were placed in different
> cgroups with differnt configs, A's config won't take effect anymore.
> 
> Am I missing something?

I don't know. I guess at one point the socket resources are shared and then
one configuration is taking preference. As you can see I am far away of
being
an expert in this field. Hopefully someone who understands this bits
can chip in.

BTW, isn't this a similar to what should happen with the block io cgroup?
What is the behavior with a fd writing to a file in the scenario you
describe above?

