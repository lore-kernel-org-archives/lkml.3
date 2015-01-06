Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407AbbAFXVD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 18:21:03 -0500
Received: from mail-oi0-f53.google.com ([209.85.218.53]:51607 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbbAFXU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 18:20:59 -0500
MIME-Version: 1.0
In-Reply-To: <54AB2992.6060707@nod.at>
References: <1417744550-6461-1-git-send-email-adityakali@google.com>
 <1417744550-6461-9-git-send-email-adityakali@google.com> <548E17CE.8010704@nod.at>
 <CAGr1F2HA6mzFwgp5ngX8P7=198-5CmCjLmuCJ8j3eQ08J2d9Qw@mail.gmail.com>
 <54AB15BD.8020007@nod.at> <87lhlgpyxk.fsf@x220.int.ebiederm.org>
 <CAGr1F2HSi_D07r2c5CKOsjSR1+58k9G2MrtACsd+HV6XKvJ7cA@mail.gmail.com> <54AB2992.6060707@nod.at>
From: Aditya Kali <adityakali@google.com>
Date: Tue, 6 Jan 2015 15:20:38 -0800
Message-ID: <CAGr1F2EGOUSEd3-G4PS0mq=9kU1nWG4CwHUOQaNUATepc11_Sw@mail.gmail.com>
Subject: Re: [PATCHv3 8/8] cgroup: Add documentation for cgroup namespaces
To: Richard Weinberger <richard@nod.at>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, Serge Hallyn <serge.hallyn@ubuntu.com>,
        Andy Lutomirski <luto@amacapital.net>,
        cgroups mailinglist <cgroups@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Rohit Jnagal <jnagal@google.com>, Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I understand your point. But it will add some complexity to the code.

Before trying to make it work for non-unified hierarchy cases, I would
like to get a clearer idea.
What do you expect to be mounted when you run:
  container:/ # mount -t cgroup none /sys/fs/cgroup/
from inside the container?

Note that cgroup-namespace wont be able to change the way cgroups are
mounted .. i.e., if say cpu and cpuacct subsystems are mounted
together at a single mount-point, then we cannot mount them any other
way (inside a container or outside). This restriction exists today and
cgroup-namespaces won't change that.

So, If on the host we have:
root@adityakali-vm2:/sys/fs/cgroup# cat /proc/mounts | grep cgroup
tmpfs /sys/fs/cgroup tmpfs rw,relatime 0 0
cgroup /sys/fs/cgroup/cpu cgroup rw,relatime,cpuset,cpu,cpuacct 0 0
cgroup /sys/fs/cgroup/mem cgroup rw,relatime,memory,hugetlb 0 0
cgroup /sys/fs/cgroup/rest cgroup
rw,relatime,devices,freezer,net_cls,blkio,perf_event,net_prio 0 0

And inside the container we want each subsystem to be on its own
mount-point, then it will fail. Do you think even then its useful to
support virtualizing paths for non-unified hierarchies?

Thanks,


On Mon, Jan 5, 2015 at 4:17 PM, Richard Weinberger <richard@nod.at> wrote:
> Am 06.01.2015 um 01:10 schrieb Aditya Kali:
>> Since the old/default behavior is on its way out, I didn't invest time
>> in fixing that. Also, some of the properties that make
>> cgroup-namespace simpler are only provided by unified hierarchy (for
>> example: a single root-cgroup per container).
>
> Does the new sane cgroupfs behavior even have a single real world user?
> I always thought it isn't stable yet.
>
> Linux distros currently use systemd v210. They don't dare to use a newer one.
> Even *if* systemd would support the sane sane cgroupfs behavior in the most recent
> version it will take 1-2 years until it would hit a recent distro.
>
> So please support also the old and nasty behavior such that one day we can run current
> systemd distros in Linux containers.
>
> Thanks,
> //richard



-- 
Aditya
