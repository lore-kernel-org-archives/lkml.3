Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbbAGOrw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 09:47:52 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:38923 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbbAGOru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 09:47:50 -0500
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
	<54AB15BD.8020007@nod.at> <87lhlgpyxk.fsf@x220.int.ebiederm.org>
	<CAGr1F2HSi_D07r2c5CKOsjSR1+58k9G2MrtACsd+HV6XKvJ7cA@mail.gmail.com>
	<54AB2992.6060707@nod.at>
	<CAGr1F2EGOUSEd3-G4PS0mq=9kU1nWG4CwHUOQaNUATepc11_Sw@mail.gmail.com>
	<54ACFC38.5070007@nod.at>
Date: Wed, 07 Jan 2015 08:45:05 -0600
In-Reply-To: <54ACFC38.5070007@nod.at> (Richard Weinberger's message of "Wed,
	07 Jan 2015 10:28:24 +0100")
Message-ID: <87fvbmir9q.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/JAyO4e1UlqGafV0LEiQ8uJ43lSzuSLNI=
X-SA-Exim-Connect-IP: 97.121.85.189
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Richard Weinberger <richard@nod.at>
X-Spam-Relay-Country: 
X-Spam-Timing: total 538 ms - load_scoreonly_sql: 0.07 (0.0%),
	signal_user_changed: 3.8 (0.7%), b_tie_ro: 2.7 (0.5%), parse: 1.19 (0.2%),
	extract_message_metadata: 20 (3.7%), get_uri_detail_list: 3.3 (0.6%),
	tests_pri_-1000: 9 (1.7%), tests_pri_-950: 1.80 (0.3%), tests_pri_-900: 1.61
	(0.3%), tests_pri_-400: 34 (6.3%), check_bayes: 32 (6.0%), b_tokenize: 13
	(2.4%), b_tok_get_all: 10 (1.8%), b_comp_prob: 4.4 (0.8%), b_tok_touch_all:
	2.5 (0.5%), b_finish: 0.75 (0.1%), tests_pri_0: 456 (84.8%), tests_pri_500: 6
	(1.2%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCHv3 8/8] cgroup: Add documentation for cgroup namespaces
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Weinberger <richard@nod.at> writes:

> Am 07.01.2015 um 00:20 schrieb Aditya Kali:
>> I understand your point. But it will add some complexity to the code.
>> 
>> Before trying to make it work for non-unified hierarchy cases, I would
>> like to get a clearer idea.
>> What do you expect to be mounted when you run:
>>   container:/ # mount -t cgroup none /sys/fs/cgroup/
>> from inside the container?
>> 
>> Note that cgroup-namespace wont be able to change the way cgroups are
>> mounted .. i.e., if say cpu and cpuacct subsystems are mounted
>> together at a single mount-point, then we cannot mount them any other
>> way (inside a container or outside). This restriction exists today and
>> cgroup-namespaces won't change that.
>
> I wondered why cgroup namespaces won't change that and looked at your patches
> in more detail.
> What you propose as cgroup namespace is much more a cgroup chroot() than
> a namespace.
> As you pass relative paths into the namespace you depend on the mount structure
> of the host side.
> Hence, the abstraction between namespaces happens on the mount paths of the initial
> cgroupfs. But we really want a new cgroupfs instance within a container and not just
> a cut out of the initial cgroupfs mount.
>
> I fear you approach is over simplified and won't work for all cases. It may work
> for your specific use case at Google but we really want something generic.
> Eric, what do you think?

I think I probably need to go back upthread and read the patches.

I think it is a reasonable practical requirement that a widely used long
term supported distribution like RHEL 7 needs to be able to run in a linux
container bizarre init system and all.  And that we the abstractions
should be that that we should be able to migrate such a beast.

There are a couple of issues in play and I think we need actual testing
rather than reports that something shouldn't work before we reject a set
of patches.    Aditya in one of his replies to me has reported a
configuration that he expects will work.  So I think that configuration
needs to be tested.

cgroups is a weird beast and the problems tend not to lie where a person
would first expect.

I suspect no one strongly cares if the cgroup hierarchy is unified or
not.  By unified hierarchy I mean that  every mount of cgroupfs has the
same directories with the same processes in each directory.

I do think people will care which controllers will show up in differ
mounts of cgroupfs, and I think that is relevant to process migration.




I am going to segway into scope of what is achievable with a cgroup namespace.

- If there are files in cgroupfs that are not safe to delegate we can
  not support those files in a container. 

  Last I looked there were such files and systemd used them.

- Which controllers share hierarchies of processes to track resources is
  a core cgroup issue and not a cgroup namespace issue.

  If we find problems with using a unified hierarchy support we need to
  go fix cgroups in general not cgroupfs.

Eric
