Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751277AbaLQCWN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 21:22:13 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:39268 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbaLQCWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 21:22:12 -0500
Message-ID: <5490E856.6050904@huawei.com>
Date: Wed, 17 Dec 2014 10:20:06 +0800
From: Zefan Li <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Vince Weaver <vincent.weaver@maine.edu>
CC: <eranian@gmail.com>, Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [perf tool] cgroup support broken on Debian?
References: <alpine.DEB.2.11.1412151558550.15380@vincent-weaver-1.umelst.maine.edu> <20141215220150.GP9845@kernel.org> <CAMsRxfJ7EnA1DTXMK-UZtua8jLdn84C=Oc4yUkjqgL9tb5sTsQ@mail.gmail.com> <alpine.DEB.2.11.1412161211540.2154@vincent-weaver-1.umelst.maine.edu>
In-Reply-To: <alpine.DEB.2.11.1412161211540.2154@vincent-weaver-1.umelst.maine.edu>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/12/17 1:17, Vince Weaver wrote:
> On Mon, 15 Dec 2014, Stephane Eranian wrote:
>> On Mon, Dec 15, 2014 at 11:01 PM, Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com> wrote:
> 
>> fs is visible. The cgroup file system type is not there anymore. They are using
>> tmpfs which is not ideal to detect just cgroup. Looks like now, we have to look
>> at the mount point which is flaky.
> 
> The trivial fix is to just always assume things will be under
> 	/sys/fs/cgroup
> which looks like to be the new official mount point.
> 
> This will break on older systems though, or systems that mount cgroupfs in 
> multiple locations.
> 
> Another alternative is to change the interface to require the full 
> cgroupfs pathname as an argument to -G
> 

What's the problem here?

none /sys/fs/cgroup tmpfs rw,relatime,size=4k,mode=755 0 0
systemd /sys/fs/cgroup/systemd cgroup rw,nosuid,nodev,noexec,relatime,perf_event,name=systemd 0 0

cgroup is mounted in /sys/fs/cgroup/systemd, so you should pass '/' to the -G argument:

	sudo perf stat -a -e cycles:u,cycles:u,cycles:u -G / -- sleep 1

