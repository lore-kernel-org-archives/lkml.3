Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341AbaGSRdX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 13:33:23 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:60437 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932161AbaGSRdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 13:33:21 -0400
Message-ID: <53CAABCB.5080202@linux.vnet.ibm.com>
Date: Sat, 19 Jul 2014 23:02:59 +0530
From: Hemant Kumar <hemant@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, hegdevasant@linux.vnet.ibm.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org,
        namhyung@kernel.org, aravinda@linux.vnet.ibm.com, penberg@iki.fi
Subject: Re: [PATCH v2 0/3] perf/sdt : Support for SDT markers
References: <20140717054826.19995.61782.stgit@hemant-fedora> <53C903B7.6070905@hitachi.com>
In-Reply-To: <53C903B7.6070905@hitachi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14071917-0260-0000-0000-00000566ECCF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 07/18/2014 04:53 PM, Masami Hiramatsu wrote:
> Hi Hemant,
>
> (2014/07/17 14:53), Hemant Kumar wrote:
>> This patchset helps in listing dtrace style markers(SDT) present in user space
>> applications through perf.
>> Notes/markers are placed at important places by the
>> developers. They have a negligible overhead when not enabled.
>> We can enable them and probe at these places and find some important information
>> like the arguments' values, etc.
> Thanks for your work! This actually helps us a lot :)

Thanks a lot for the appreciation. :)

>
>> We have lots of applications which use SDT markers today, like:
>> Postgresql, MySql, Mozilla, Perl, Python, Java, Ruby, libvirt, QEMU, glib
>>
>> To add SDT markers into user applications:
>> We need to have this header sys/sdt.h present.
>> sys/sdt.h used is version 3.
>> If not present, install systemtap-sdt-devel package (for fedora-18).
>>
>> Please refer to the Documentation patch to see how the SDT markers are added into
>> a program.
>>
>> With this patchset,
>> - Use perf to list the markers in the app:
>> # perf list sdt ./user_app
>>
>> ./user_app :
>> %user_app:foo_start
>> %user_app:fun_start
>>
>> - Also, we can see the SDT markers present in our system in the usual binaries.
>> These usual binaries are libraries (dsos) listed by ldconfig --print-cache and some
>> binaries present in PATH environment variable.
>>
>> First, scan the binaries using :
>> # perf list sdt --scan
> At a glance, maybe we'd better have perf sdt-cache as like as perf buildid-cache
> for manage sdt information. what would you think?
>

I agree with you having perf sdt-cache similar to perf buildid-cache.
But I think if the functionality of perf sdt-cache is only to build the 
cache, then we can
go with the perf list sdt --scan. Since, "perf list sdt" is used for 
other purposes too, it
should be less confusing for the users to just add another option 
(--scan) to create/modify
the cache. What do you suggest?

>> Creating a cache of SDT markers...
>> perf sdt cache created!
>>   Use : "perf list sdt"
>>   to see the SDT markers
>>
>> After the sdt cache file is created, use perf list to view the markers :
>> # perf list sdt
>>
>> %rtld : init_start
>> %rtld : init_complete
>> %rtld : map_failed
>> %rtld : map_start
>> %rtld : lll_futex_wake
>> ...
>> ...
>> %libgcc : unwind
>> %libvirt : rpc_server_client_auth_allow
>> %libvirt : rpc_server_client_auth_fail
>> %libvirt : rpc_server_client_auth_deny
> Looks good :)
> It seems very useful for perf users.
>
> Thank you,

Thanks a lot for going through this.

-- 
Thanks,
Hemant Kumar

