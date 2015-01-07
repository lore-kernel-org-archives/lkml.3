Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717AbbAGXFD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 18:05:03 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:36764 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbbAGXFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 18:05:00 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Tejun Heo <tj@kernel.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Richard Weinberger <richard@nod.at>,
        Linux API <linux-api@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        cgroups mailinglist <cgroups@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>
References: <CAGr1F2HA6mzFwgp5ngX8P7=198-5CmCjLmuCJ8j3eQ08J2d9Qw@mail.gmail.com>
	<54AB15BD.8020007@nod.at> <87lhlgpyxk.fsf@x220.int.ebiederm.org>
	<CAGr1F2HSi_D07r2c5CKOsjSR1+58k9G2MrtACsd+HV6XKvJ7cA@mail.gmail.com>
	<54AB2992.6060707@nod.at>
	<CAGr1F2EGOUSEd3-G4PS0mq=9kU1nWG4CwHUOQaNUATepc11_Sw@mail.gmail.com>
	<54ACFC38.5070007@nod.at> <87fvbmir9q.fsf@x220.int.ebiederm.org>
	<20150107193059.GA1857@mail.hallyn.com>
	<87bnma6xwv.fsf@x220.int.ebiederm.org>
	<20150107224430.GA28414@htj.dyndns.org>
Date: Wed, 07 Jan 2015 17:02:17 -0600
In-Reply-To: <20150107224430.GA28414@htj.dyndns.org> (Tejun Heo's message of
	"Wed, 7 Jan 2015 17:45:11 -0500")
Message-ID: <878uhe42km.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18v1/Xq4vAhMTZ5RbnBqvNHLFeDJwyzboA=
X-SA-Exim-Connect-IP: 97.121.85.189
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Tejun Heo <tj@kernel.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 254 ms - load_scoreonly_sql: 0.04 (0.0%),
	signal_user_changed: 3.1 (1.2%), b_tie_ro: 2.2 (0.9%), parse: 0.70 (0.3%),
	extract_message_metadata: 4.2 (1.7%), get_uri_detail_list: 1.46 (0.6%),
	tests_pri_-1000: 5 (2.0%), tests_pri_-950: 1.53 (0.6%), tests_pri_-900: 1.32
	(0.5%), tests_pri_-400: 23 (9.2%), check_bayes: 22 (8.7%), b_tokenize: 7
	(2.9%), b_tok_get_all: 7 (2.8%), b_comp_prob: 2.1 (0.8%), b_tok_touch_all:
	2.7 (1.1%), b_finish: 0.87 (0.3%), tests_pri_0: 197 (77.5%), tests_pri_500: 5
	(2.1%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCHv3 8/8] cgroup: Add documentation for cgroup namespaces
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> On Wed, Jan 07, 2015 at 04:14:40PM -0600, Eric W. Biederman wrote:
>> I see what you mean.  If it is indeed the case than a mount of cgroupfs
>> using the unified hiearchy and can not specify which controllers are
>> present under that mount that very significant bug and presents a very
>> significant regression in user space flexibility.
>
> The parent always controls which controllers are made available at the
> children level.  Only if the parent enables a controller, its
> children, whether they're namespaces or not, can choose to further
> distribute resources using that controller.  It's a straight-forward
> top-down thing.

Ignoring namespace details for a moment. The following should be
possible with a unified hierarchy.  If it is not it is a show stopper
of a regression.

mount -t tmpfs none /sys/fs/cgroup
(cd /sys/fs/cgroup ; mkdir cpu cpuacct devices memory)
mount -t cgroupfs -o cpu /sys/fs/cgroup/cpu
mount -t cgroupfs -o cpuacct /sys/fs/cgroup/cpuacct
mount -t cgroupfs -o devices /sys/fs/cgroup/devices
mount -t cgroupfs -o memory /sys/fs/cgroup/memory

With the expectation that only the control files for the specified
controllers show up in those mounts.

That is a unified hierarchy is fine.  Requiring that there only be one
mount point and that every one use it is not ok and it actively a problem.

It is absolutely required to be able to avoid b0rked controllers, and
to my knowledge the only way to do that is to have multiple mounts where
we pick the controller on each mount.   Even if there is now a way that
doesn't require multiple mounts to keep b0rked controllers from being
enabled multiple mounts still need to work to support the existing
userspace programs.

This discussion is happening because Documentation/cgroups/unified-hierarchy.txt
implies the configuration I have just described will not work with
unified hierachies enabled.

Eric
