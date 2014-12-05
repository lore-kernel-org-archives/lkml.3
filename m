Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879AbaLEDU3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 22:20:29 -0500
Received: from mail-oi0-f54.google.com ([209.85.218.54]:39082 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbaLEDU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 22:20:26 -0500
MIME-Version: 1.0
In-Reply-To: <1417744550-6461-1-git-send-email-adityakali@google.com>
References: <1417744550-6461-1-git-send-email-adityakali@google.com>
From: Aditya Kali <adityakali@google.com>
Date: Thu, 4 Dec 2014 19:20:05 -0800
Message-ID: <CAGr1F2EvVXE6nVo035zPJeC2gMvNLHZ9hRGQ7y4fZn-xnBcyxg@mail.gmail.com>
Subject: Re: [PATCHv3 0/8] CGroup Namespaces
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        cgroups mailinglist <cgroups@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        Rohit Jnagal <jnagal@google.com>, Vivek Goyal <vgoyal@redhat.com>,
        Richard Weinberger <richard.weinberger@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches are now also hosted on github at
https://github.com/adityakali/linux/tree/cgroupns_v3.

Thanks,

On Thu, Dec 4, 2014 at 5:55 PM, Aditya Kali <adityakali@google.com> wrote:
> Another spin for CGroup Namespaces feature.
>
> Changes from V2:
> 1. Added documentation in Documentation/cgroups/namespace.txt
> 2. Fixed a bug that caused crash
> 3. Incorporated some other suggestions from last patchset:
>    - removed use of threadgroup_lock() while creating new cgroupns
>    - use task_lock() instead of rcu_read_lock() while accessing
>      task->nsproxy
>    - optimized setns() to own cgroupns
>    - simplified code around sane-behavior mount option parsing
> 4. Restored ACKs from Serge Hallyn from v1 on few patches that have
>    not changed since then.
>
> Changes from V1:
> 1. No pinning of processes within cgroupns. Tasks can be freely moved
>    across cgroups even outside of their cgroupns-root. Usual DAC/MAC policies
>    apply as before.
> 2. Path in /proc/<pid>/cgroup is now always shown and is relative to
>    cgroupns-root. So path can contain '/..' strings depending on cgroupns-root
>    of the reader and cgroup of <pid>.
> 3. setns() does not require the process to first move under target
>    cgroupns-root.
>
> Changes form RFC (V0):
> 1. setns support for cgroupns
> 2. 'mount -t cgroup cgroup <mntpt>' from inside a cgroupns now
>    mounts the cgroup hierarcy with cgroupns-root as the filesystem root.
> 3. writes to cgroup files outside of cgroupns-root are not allowed
> 4. visibility of /proc/<pid>/cgroup is further restricted by not showing
>    anything if the <pid> is in a sibling cgroupns and its cgroup falls outside
>    your cgroupns-root.
>
> ---
>  Documentation/cgroups/namespace.txt | 147 +++++++++++++++++++++++++++
>  fs/kernfs/dir.c                     | 195 ++++++++++++++++++++++++++++++++----
>  fs/kernfs/mount.c                   |  48 +++++++++
>  fs/proc/namespaces.c                |   1 +
>  include/linux/cgroup.h              |  52 +++++++++-
>  include/linux/cgroup_namespace.h    |  36 +++++++
>  include/linux/kernfs.h              |   5 +
>  include/linux/nsproxy.h             |   2 +
>  include/linux/proc_ns.h             |   4 +
>  include/uapi/linux/sched.h          |   3 +-
>  kernel/Makefile                     |   2 +-
>  kernel/cgroup.c                     | 106 +++++++++++++++-----
>  kernel/cgroup_namespace.c           | 140 ++++++++++++++++++++++++++
>  kernel/fork.c                       |   2 +-
>  kernel/nsproxy.c                    |  19 +++-
>  15 files changed, 711 insertions(+), 51 deletions(-)
>  create mode 100644 Documentation/cgroups/namespace.txt
>  create mode 100644 include/linux/cgroup_namespace.h
>  create mode 100644 kernel/cgroup_namespace.c
>
> [PATCHv3 1/8] kernfs: Add API to generate relative kernfs path
> [PATCHv3 2/8] sched: new clone flag CLONE_NEWCGROUP for cgroup
> [PATCHv3 3/8] cgroup: add function to get task's cgroup on default
> [PATCHv3 4/8] cgroup: export cgroup_get() and cgroup_put()
> [PATCHv3 5/8] cgroup: introduce cgroup namespaces
> [PATCHv3 6/8] cgroup: cgroup namespace setns support
> [PATCHv3 7/8] cgroup: mount cgroupns-root when inside non-init cgroupns
> [PATCHv3 8/8] cgroup: Add documentation for cgroup namespaces



-- 
Aditya
