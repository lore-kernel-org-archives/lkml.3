Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236AbaKTV3w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 16:29:52 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758095AbaKTV3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 16:29:50 -0500
Message-ID: <546E5D46.4070805@nod.at>
Date: Thu, 20 Nov 2014 22:29:42 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: "Chen, Hanxiao" <chenhanxiao@cn.fujitsu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
CC: "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mateusz Guzik <mguzik@redhat.com>, David Howells <dhowells@redhat.com>
Subject: Re: [PATCH v8 1/2] procfs: show hierarchy of pid namespace
References: <1416303013-13762-1-git-send-email-chenhanxiao@cn.fujitsu.com> <1416303013-13762-2-git-send-email-chenhanxiao@cn.fujitsu.com> <5871495633F38949900D2BF2DC04883E73748A47@G08CNEXMBPEKD03.g08.fujitsu.local>
In-Reply-To: <5871495633F38949900D2BF2DC04883E73748A47@G08CNEXMBPEKD03.g08.fujitsu.local>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 20.11.2014 um 10:57 schrieb Chen, Hanxiao:
> 
> 
>> -----Original Message-----
>> From: containers-bounces@lists.linux-foundation.org
>> [mailto:containers-bounces@lists.linux-foundation.org] On Behalf Of Chen
>> Hanxiao
>> Sent: Tuesday, November 18, 2014 5:30 PM
>> To: Eric W. Biederman; Serge Hallyn; Oleg Nesterov; Richard Weinberger
>> Cc: containers@lists.linux-foundation.org; linux-kernel@vger.kernel.org;
>> Mateusz Guzik; David Howells
>> Subject: [PATCH v8 1/2] procfs: show hierarchy of pid namespace
>>
>> We lack of pid hierarchy information, and this will lead to:
>> a) we don't know pids' relationship, who is whose child:
>>    /proc/PID/ns/pid only tell us whether two pids live in different ns
>> b) bring trouble to nested lxc container check/restore/migration
>> c) bring trouble to pid translation between containers;
>>
>> This patch will show the hierarchy of pid namespace
>> by pidns_hierarchy like:
>>
>> <init_PID> <parent_of_init_PID> <relative PID level>
>>
>> Ex:
>> [root@localhost ~]#cat /proc/pidns_hierarchy
>> 18060 1 1
>> 18102 18060 2
>> 1534  18102 3
>> 1600  18102 3
>> 1550  1 1
>> *Note: numbers represent the pid 1 in different ns
>>
>> It shows the pid hierarchy below:
>>
>>       init_pid_ns 1
>>               │
>> ┌────────────┐
>> ns1                      ns2
>> │                        │
>> 1550                    18060
>>                           │
>>                           │
>>                          ns3
>>                           │
>>                         18102
>>                           │
>>                  ┌──────────┐
>>                  ns4                   ns5
>>                  │                    │
>>                 1534                  1600
>>
>> Every pid printed in pidns_hierarchy
>> is the init pid of that pid ns level.
>>
>> Signed-off-by: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
>> ---
>> v8: fix some improper comments
>>     use max() from kernel.h
>> v7: change stype to be consistent with current interface like
>>     <init_PID> <parent_of_init_PID> <relative PID level>
>>     remove EXPERT dependent in Kconfig
>> v6: fix a get_pid leak and do some cleanups;
>> v5: collect pid by find_ge_pid;
>>     use local list inside nslist_proc_show;
>>     use get_pid, remove mutex lock.
>> v4: simplify pid collection and some performance optimizamtion
>>     fix another race issue.
>> v3: fix a race issue and memory leak issue
>> v2: use a procfs text file instead of dirs under /proc
>>
> 
> Hi,
> 
> Any comments?

FWIW, Acked-by: Richard Weinberer <richard@nod.at>

The more challenging question is who will pickup this series?
Eric? Andrew?

Thanks,
//richard
