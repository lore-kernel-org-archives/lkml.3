Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629AbbAEXz4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 18:55:56 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:50441 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060AbbAEXzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 18:55:53 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Richard Weinberger <richard@nod.at>
Cc: Aditya Kali <adityakali@google.com>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, Serge Hallyn <serge.hallyn@ubuntu.com>,
        Andy Lutomirski <luto@amacapital.net>,
        cgroups mailinglist <cgroups@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Rohit Jnagal <jnagal@google.com>, Vivek Goyal <vgoyal@redhat.com>
References: <1417744550-6461-1-git-send-email-adityakali@google.com>
	<1417744550-6461-9-git-send-email-adityakali@google.com>
	<548E17CE.8010704@nod.at>
	<CAGr1F2HA6mzFwgp5ngX8P7=198-5CmCjLmuCJ8j3eQ08J2d9Qw@mail.gmail.com>
	<54AB15BD.8020007@nod.at>
Date: Mon, 05 Jan 2015 17:53:11 -0600
In-Reply-To: <54AB15BD.8020007@nod.at> (Richard Weinberger's message of "Mon,
	05 Jan 2015 23:52:45 +0100")
Message-ID: <87lhlgpyxk.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19ge/W4XqQpYAsdx0VNEOypvtlYJHLoeF0=
X-SA-Exim-Connect-IP: 97.121.85.189
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  0.7 XMSubLong Long Subject
	*  1.2 LotsOfNums_01 BODY: Lots of long strings of numbers
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Richard Weinberger <richard@nod.at>
X-Spam-Relay-Country: 
X-Spam-Timing: total 996 ms - load_scoreonly_sql: 0.04 (0.0%),
	signal_user_changed: 3.6 (0.4%), b_tie_ro: 2.5 (0.3%), parse: 1.19 (0.1%),
	extract_message_metadata: 18 (1.8%), get_uri_detail_list: 7 (0.7%),
	tests_pri_-1000: 6 (0.6%), tests_pri_-950: 1.24 (0.1%), tests_pri_-900: 1.08
	(0.1%), tests_pri_-400: 41 (4.1%), check_bayes: 40 (4.0%), b_tokenize: 15
	(1.5%), b_tok_get_all: 12 (1.2%), b_comp_prob: 3.3 (0.3%), b_tok_touch_all:
	3.3 (0.3%), b_finish: 0.76 (0.1%), tests_pri_0: 916 (91.9%), tests_pri_500: 5
	(0.5%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCHv3 8/8] cgroup: Add documentation for cgroup namespaces
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Weinberger <richard@nod.at> writes:

> Am 05.01.2015 um 23:48 schrieb Aditya Kali:
>> On Sun, Dec 14, 2014 at 3:05 PM, Richard Weinberger <richard@nod.at> wrote:
>>> Aditya,
>>>
>>> I gave your patch set a try but it does not work for me.
>>> Maybe you can bring some light into the issues I'm facing.
>>> Sadly I still had no time to dig into your code.
>>>
>>> Am 05.12.2014 um 02:55 schrieb Aditya Kali:
>>>> Signed-off-by: Aditya Kali <adityakali@google.com>
>>>> ---
>>>>  Documentation/cgroups/namespace.txt | 147 ++++++++++++++++++++++++++++++++++++
>>>>  1 file changed, 147 insertions(+)
>>>>  create mode 100644 Documentation/cgroups/namespace.txt
>>>>
>>>> diff --git a/Documentation/cgroups/namespace.txt b/Documentation/cgroups/namespace.txt
>>>> new file mode 100644
>>>> index 0000000..6480379
>>>> --- /dev/null
>>>> +++ b/Documentation/cgroups/namespace.txt
>>>> @@ -0,0 +1,147 @@
>>>> +                     CGroup Namespaces
>>>> +
>>>> +CGroup Namespace provides a mechanism to virtualize the view of the
>>>> +/proc/<pid>/cgroup file. The CLONE_NEWCGROUP clone-flag can be used with
>>>> +clone() and unshare() syscalls to create a new cgroup namespace.
>>>> +The process running inside the cgroup namespace will have its /proc/<pid>/cgroup
>>>> +output restricted to cgroupns-root. cgroupns-root is the cgroup of the process
>>>> +at the time of creation of the cgroup namespace.
>>>> +
>>>> +Prior to CGroup Namespace, the /proc/<pid>/cgroup file used to show complete
>>>> +path of the cgroup of a process. In a container setup (where a set of cgroups
>>>> +and namespaces are intended to isolate processes), the /proc/<pid>/cgroup file
>>>> +may leak potential system level information to the isolated processes.
>>>> +
>>>> +For Example:
>>>> +  $ cat /proc/self/cgroup
>>>> +  0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/batchjobs/container_id1
>>>> +
>>>> +The path '/batchjobs/container_id1' can generally be considered as system-data
>>>> +and its desirable to not expose it to the isolated process.
>>>> +
>>>> +CGroup Namespaces can be used to restrict visibility of this path.
>>>> +For Example:
>>>> +  # Before creating cgroup namespace
>>>> +  $ ls -l /proc/self/ns/cgroup
>>>> +  lrwxrwxrwx 1 root root 0 2014-07-15 10:37 /proc/self/ns/cgroup -> cgroup:[4026531835]
>>>> +  $ cat /proc/self/cgroup
>>>> +  0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/batchjobs/container_id1
>>>> +
>>>> +  # unshare(CLONE_NEWCGROUP) and exec /bin/bash
>>>> +  $ ~/unshare -c
>>>> +  [ns]$ ls -l /proc/self/ns/cgroup
>>>> +  lrwxrwxrwx 1 root root 0 2014-07-15 10:35 /proc/self/ns/cgroup -> cgroup:[4026532183]
>>>> +  # From within new cgroupns, process sees that its in the root cgroup
>>>> +  [ns]$ cat /proc/self/cgroup
>>>> +  0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/
>>>> +
>>>> +  # From global cgroupns:
>>>> +  $ cat /proc/<pid>/cgroup
>>>> +  0:cpuset,cpu,cpuacct,memory,devices,freezer,hugetlb:/batchjobs/container_id1
>>>> +
>>>> +  # Unshare cgroupns along with userns and mountns
>>>> +  # Following calls unshare(CLONE_NEWCGROUP|CLONE_NEWUSER|CLONE_NEWNS), then
>>>> +  # sets up uid/gid map and execs /bin/bash
>>>> +  $ ~/unshare -c -u -m
>>>
>>> This command does not issue CLONE_NEWUSER, -U does.
>>>
>> I was using a custom unshare binary. But I will update the command
>> line to be similar to the one in util-linux.
>> 
>>>> +  # Originally, we were in /batchjobs/container_id1 cgroup. Mount our own cgroup
>>>> +  # hierarchy.
>>>> +  [ns]$ mount -t cgroup cgroup /tmp/cgroup
>>>> +  [ns]$ ls -l /tmp/cgroup
>>>> +  total 0
>>>> +  -r--r--r-- 1 root root 0 2014-10-13 09:32 cgroup.controllers
>>>> +  -r--r--r-- 1 root root 0 2014-10-13 09:32 cgroup.populated
>>>> +  -rw-r--r-- 1 root root 0 2014-10-13 09:25 cgroup.procs
>>>> +  -rw-r--r-- 1 root root 0 2014-10-13 09:32 cgroup.subtree_control
>>>
>>> I've patched libvirt-lxc to issue CLONE_NEWCGROUP and not bind mount cgroupfs into a container.
>>> But I'm unable to mount cgroupfs within the container, mount(2) is failing with EINVAL.
>>> And /proc/self/cgroup still shows the cgroup from outside.
>>>
>>> ---cut---
>>> container:/ # ls /sys/fs/cgroup/
>>> container:/ # mount -t cgroup none /sys/fs/cgroup/
>> 
>> You need to provide "-o __DEVEL_sane_behavior" flag. Inside the
>> container, only unified hierarchy can be mounted. So, for now, that
>> flag is needed. I will fix the documentation too.
>> 
>>> mount: wrong fs type, bad option, bad superblock on none,
>>>        missing codepage or helper program, or other error
>>>
>>>        In some cases useful info is found in syslog - try
>>>        dmesg | tail or so.
>>> container:/ # cat /proc/self/cgroup
>>> 8:memory:/machine/test00.libvirt-lxc
>>> 7:devices:/machine/test00.libvirt-lxc
>>> 6:hugetlb:/
>>> 5:cpuset:/machine/test00.libvirt-lxc
>>> 4:blkio:/machine/test00.libvirt-lxc
>>> 3:cpu,cpuacct:/machine/test00.libvirt-lxc
>>> 2:freezer:/machine/test00.libvirt-lxc
>>> 1:name=systemd:/user.slice/user-0.slice/session-c2.scope
>>> container:/ # ls -la /proc/self/ns
>>> total 0
>>> dr-x--x--x 2 root root 0 Dec 14 23:02 .
>>> dr-xr-xr-x 8 root root 0 Dec 14 23:02 ..
>>> lrwxrwxrwx 1 root root 0 Dec 14 23:02 cgroup -> cgroup:[4026532240]
>>> lrwxrwxrwx 1 root root 0 Dec 14 23:02 ipc -> ipc:[4026532238]
>>> lrwxrwxrwx 1 root root 0 Dec 14 23:02 mnt -> mnt:[4026532235]
>>> lrwxrwxrwx 1 root root 0 Dec 14 23:02 net -> net:[4026532242]
>>> lrwxrwxrwx 1 root root 0 Dec 14 23:02 pid -> pid:[4026532239]
>>> lrwxrwxrwx 1 root root 0 Dec 14 23:02 user -> user:[4026532234]
>>> lrwxrwxrwx 1 root root 0 Dec 14 23:02 uts -> uts:[4026532236]
>>> container:/ #
>>>
>>> #host side
>>> lxc-os132:~ # ls -la /proc/self/ns
>>> total 0
>>> dr-x--x--x 2 root root 0 Dec 14 23:56 .
>>> dr-xr-xr-x 8 root root 0 Dec 14 23:56 ..
>>> lrwxrwxrwx 1 root root 0 Dec 14 23:56 cgroup -> cgroup:[4026531835]
>>> lrwxrwxrwx 1 root root 0 Dec 14 23:56 ipc -> ipc:[4026531839]
>>> lrwxrwxrwx 1 root root 0 Dec 14 23:56 mnt -> mnt:[4026531840]
>>> lrwxrwxrwx 1 root root 0 Dec 14 23:56 net -> net:[4026531957]
>>> lrwxrwxrwx 1 root root 0 Dec 14 23:56 pid -> pid:[4026531836]
>>> lrwxrwxrwx 1 root root 0 Dec 14 23:56 user -> user:[4026531837]
>>> lrwxrwxrwx 1 root root 0 Dec 14 23:56 uts -> uts:[4026531838]
>>> ---cut---
>>>
>>> Any ideas?
>>>
>> 
>> Please try with "-o __DEVEL_sane_behavior" flag to the mount command.
>
> Ohh, this renders the whole patch useless for me as systemd needs the "old/default" behavior of cgroups. :-(
> I really hoped that cgroup namespaces will help me running systemd in a sane way within Linux containers.

Ugh.  It sounds like there is a real mess here.  At the very least there
is misunderstanding.

I have a memory that systemd should have been able to use a unified
hierarchy.  As you could still mount the different controllers
independently (they just use the same directory structure on each
mount).

That said from a practical standpoint I am not certain that a cgroup
namespace is viable if it can not support the behavior of cgroupsfs
that everyone is using.

Eric
