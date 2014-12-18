Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979AbaLRDkg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 22:40:36 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:36330 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbaLRDke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 22:40:34 -0500
Message-ID: <54924CA4.7080403@huawei.com>
Date: Thu, 18 Dec 2014 11:40:20 +0800
From: Zefan Li <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: Stephane Eranian <eranian@gmail.com>,
        Stephane Eranian <eranian@googlemail.com>,
        Vince Weaver <vincent.weaver@maine.edu>,
        "Arnaldo Carvalho de Melo" <arnaldo.melo@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Tejun Heo <tj@kernel.org>
Subject: Re: [perf tool] cgroup support broken on Debian?
References: <alpine.DEB.2.11.1412151558550.15380@vincent-weaver-1.umelst.maine.edu> <20141215220150.GP9845@kernel.org> <CAMsRxfJ7EnA1DTXMK-UZtua8jLdn84C=Oc4yUkjqgL9tb5sTsQ@mail.gmail.com> <alpine.DEB.2.11.1412161211540.2154@vincent-weaver-1.umelst.maine.edu> <5490E856.6050904@huawei.com> <CAMsRxfL2GrA-1N7AZM42LC+aLBRB-pvtTXs1ovLine=Hv3PFag@mail.gmail.com> <5490F24C.7090202@huawei.com> <CABPqkBRnrEwcKgbfXroHm6q1+dho9h7MnfqamyL7SPxsrjnTqA@mail.gmail.com>
In-Reply-To: <CABPqkBRnrEwcKgbfXroHm6q1+dho9h7MnfqamyL7SPxsrjnTqA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>> What's the problem here?
>>>>
>>>> none /sys/fs/cgroup tmpfs rw,relatime,size=4k,mode=755 0 0
>>>> systemd /sys/fs/cgroup/systemd cgroup rw,nosuid,nodev,noexec,relatime,perf_event,name=systemd 0 0
>>>>
>>>> cgroup is mounted in /sys/fs/cgroup/systemd, so you should pass '/' to the -G argument:
>>>>
>>> Is that the only mountpoint possible?
>>> The tool needs to detect a valid mount point to locate the named cgroup.
>>> That's assuming that if I create cgroup foo, then it appears under
>>> //sys/fs/cgroup/systemd/foo
>>>
>>
>> There can be only one cgroupfs mountpoint which has perf_event subsystem
>> attached to it.
>>
>> So for this setup:
>>
>> mount -t tmpfs /sys/fs/cgroup
>> mkdir /sys/fs/cgroup/memory
>> mkdir /sys/fs/cgroup/perf
>> mount -t cgroup -o memory memcg /sys/fs/cgroup/memory
>> mount -t cgroup -o perf_event perf /sys/fs/cgroup/perf
>>
>> The perf tool will locate the mountpoint as /sys/fs/cgroup/perf.
>>
> You can mount the cgroup fs for perf_event multiple times. I
> tried and it works, though it is useless.
> 

Yes, but they are the same.

> Vince, I think the correct way to detect which entry is for perf_event
> is to look for filesystem type cgroup and option perf_event. It cannot
> be anything else. First match is good enough.
> .

+1

