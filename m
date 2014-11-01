Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758662AbaKADAq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 23:00:46 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:47043 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758082AbaKADAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 23:00:44 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andy Lutomirski <luto@amacapital.net>
Cc: Aditya Kali <adityakali@google.com>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, Serge Hallyn <serge.hallyn@ubuntu.com>,
        cgroups@vger.kernel.org,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Rohit Jnagal <jnagal@google.com>
References: <1414783141-6947-1-git-send-email-adityakali@google.com>
	<1414783141-6947-8-git-send-email-adityakali@google.com>
	<CALCETrXTaZ3SJ_t-gnbc93BVZXg-912NqO78kFd0Tpi-5-dZoQ@mail.gmail.com>
Date: Fri, 31 Oct 2014 19:59:45 -0700
In-Reply-To: <CALCETrXTaZ3SJ_t-gnbc93BVZXg-912NqO78kFd0Tpi-5-dZoQ@mail.gmail.com>
	(Andy Lutomirski's message of "Fri, 31 Oct 2014 17:07:51 -0700")
Message-ID: <87a94blj6m.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19B1OHPA1xsiYK/7oU+kN4njVM6l1J+5P8=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andy Lutomirski <luto@amacapital.net>
X-Spam-Relay-Country: 
X-Spam-Timing: total 456 ms - load_scoreonly_sql: 0.05 (0.0%),
	signal_user_changed: 3.6 (0.8%), b_tie_ro: 2.6 (0.6%), parse: 1.14 (0.2%),
	extract_message_metadata: 24 (5.2%), get_uri_detail_list: 2.3 (0.5%),
	tests_pri_-1000: 8 (1.8%), tests_pri_-950: 2.1 (0.5%), tests_pri_-900: 1.73
	(0.4%), tests_pri_-400: 29 (6.3%), check_bayes: 27 (5.9%), b_tokenize: 10
	(2.3%), b_tok_get_all: 7 (1.6%), b_comp_prob: 3.6 (0.8%), b_tok_touch_all:
	2.1 (0.5%), b_finish: 0.84 (0.2%), tests_pri_0: 373 (81.7%), tests_pri_500: 8
	(1.8%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCHv2 7/7] cgroup: mount cgroupns-root when inside non-init cgroupns
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> writes:
>> @@ -1862,6 +1904,7 @@ static struct file_system_type cgroup_fs_type = {
>>         .name = "cgroup",
>>         .mount = cgroup_mount,
>>         .kill_sb = cgroup_kill_sb,
>> +       .fs_flags = FS_USERNS_MOUNT,
>
> Aargh, another one!  Eric, can you either ack or nack my patch?
> Because if my patch goes in, then this line may need to change.  Or
> not, but if a stable release with cgroupfs and without my patch
> happens, then we'll have an ABI break.

cgroupfs has no device nodes.  So as long as we are consistent in any
given release what happens here is orthogonal.

I don't remember if we have managed to get the original problem fixed
with the trivial backportable solution.  I think so.

My apologies for not getting to that I haven't even had time to shepherd
through the regression associated regression fix.  I probably just lock
track of them but I haven't found the Tested-By's for it yet.

Nor have I had time to dig through and figure out how to safely deal
with umount -l aka MOUNT_DETACH.

Along with the question about what to do with nodev, there is also
your patch about nosuid.

Starting in about 5 minutes I am going to be mostly offline until
sometime in the 3rd week in November as I haul all of my stuff accross
the country to someplace that actually has winter and my allergies don't
kill me.

I am going to have to review and merge a lot of code as soon as I am
back to being a programmer full time again.  There is a lot of
interesting stuff coming in right now.

Eric
