Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376AbbAGJ2f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 04:28:35 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752714AbbAGJ2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 04:28:32 -0500
Message-ID: <54ACFC38.5070007@nod.at>
Date: Wed, 07 Jan 2015 10:28:24 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Aditya Kali <adityakali@google.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, Serge Hallyn <serge.hallyn@ubuntu.com>,
        Andy Lutomirski <luto@amacapital.net>,
        cgroups mailinglist <cgroups@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Rohit Jnagal <jnagal@google.com>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCHv3 8/8] cgroup: Add documentation for cgroup namespaces
References: <1417744550-6461-1-git-send-email-adityakali@google.com> <1417744550-6461-9-git-send-email-adityakali@google.com> <548E17CE.8010704@nod.at> <CAGr1F2HA6mzFwgp5ngX8P7=198-5CmCjLmuCJ8j3eQ08J2d9Qw@mail.gmail.com> <54AB15BD.8020007@nod.at> <87lhlgpyxk.fsf@x220.int.ebiederm.org> <CAGr1F2HSi_D07r2c5CKOsjSR1+58k9G2MrtACsd+HV6XKvJ7cA@mail.gmail.com> <54AB2992.6060707@nod.at> <CAGr1F2EGOUSEd3-G4PS0mq=9kU1nWG4CwHUOQaNUATepc11_Sw@mail.gmail.com>
In-Reply-To: <CAGr1F2EGOUSEd3-G4PS0mq=9kU1nWG4CwHUOQaNUATepc11_Sw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 07.01.2015 um 00:20 schrieb Aditya Kali:
> I understand your point. But it will add some complexity to the code.
> 
> Before trying to make it work for non-unified hierarchy cases, I would
> like to get a clearer idea.
> What do you expect to be mounted when you run:
>   container:/ # mount -t cgroup none /sys/fs/cgroup/
> from inside the container?
> 
> Note that cgroup-namespace wont be able to change the way cgroups are
> mounted .. i.e., if say cpu and cpuacct subsystems are mounted
> together at a single mount-point, then we cannot mount them any other
> way (inside a container or outside). This restriction exists today and
> cgroup-namespaces won't change that.

I wondered why cgroup namespaces won't change that and looked at your patches
in more detail.
What you propose as cgroup namespace is much more a cgroup chroot() than
a namespace.
As you pass relative paths into the namespace you depend on the mount structure
of the host side.
Hence, the abstraction between namespaces happens on the mount paths of the initial
cgroupfs. But we really want a new cgroupfs instance within a container and not just
a cut out of the initial cgroupfs mount.

I fear you approach is over simplified and won't work for all cases. It may work
for your specific use case at Google but we really want something generic.
Eric, what do you think?

Thanks,
//richard
