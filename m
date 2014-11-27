Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391AbaK0QqG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 11:46:06 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:34962 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbaK0QqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 11:46:04 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Lukasz Pawelczyk <l.pawelczyk@samsung.com>
Cc: Richard Weinberger <richard@nod.at>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Paul Moore <pmoore@redhat.com>,
        Kees Cook <keescook@chromium.org>, Miklos Szeredi <mszeredi@suse.cz>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Nikolay Aleksandrov <nikolay@redhat.com>,
        Mark Rustad <mark.d.rustad@intel.com>,
        David Howells <dhowells@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Juri Lelli <juri.lelli@gmail.com>,
        Daeseok Youn <daeseok.youn@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Dario Faggioli <raistlin@linux.it>, Alex Thorlton <athorlton@sgi.com>,
        Matthew Dempsky <mdempsky@chromium.org>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "open list\:ABI\/API" <linux-api@vger.kernel.org>,
        linux-security-module@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        Lukasz Pawelczyk <havner@gmail.com>
References: <1417096866-25563-1-git-send-email-l.pawelczyk@samsung.com>
	<1417096866-25563-2-git-send-email-l.pawelczyk@samsung.com>
	<CAFLxGvzw4N4QFv5Vg1dDf9pdRe+Szbevmqn5QNwjLHN4xrokCg@mail.gmail.com>
	<1417098928.1805.15.camel@samsung.com> <54773757.8090905@nod.at>
	<1417099455.1805.17.camel@samsung.com> <54773CE7.5040303@nod.at>
	<1417101060.1805.21.camel@samsung.com>
	<87d288zm3a.fsf@x220.int.ebiederm.org>
	<1417104439.1805.25.camel@samsung.com>
Date: Thu, 27 Nov 2014 10:44:39 -0600
In-Reply-To: <1417104439.1805.25.camel@samsung.com> (Lukasz Pawelczyk's
	message of "Thu, 27 Nov 2014 17:07:19 +0100")
Message-ID: <871tooy4nc.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/lvmA5Lby3zF0+SGCbxMJDqBwxVMMMiSY=
X-SA-Exim-Connect-IP: 97.121.92.161
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  2.0 XMFreeBegin URI: free-something.com
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Lukasz Pawelczyk <l.pawelczyk@samsung.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 796 ms - load_scoreonly_sql: 0.04 (0.0%),
	signal_user_changed: 3.1 (0.4%), b_tie_ro: 2.1 (0.3%), parse: 1.10 (0.1%),
	extract_message_metadata: 23 (2.9%), get_uri_detail_list: 2.8 (0.3%),
	tests_pri_-1000: 14 (1.7%), tests_pri_-950: 1.66 (0.2%), tests_pri_-900: 1.75
	(0.2%), tests_pri_-400: 29 (3.7%), check_bayes: 28 (3.5%), b_tokenize: 9
	(1.2%), b_tok_get_all: 9 (1.2%), b_comp_prob: 2.5 (0.3%), b_tok_touch_all:
	3.7 (0.5%), b_finish: 0.69 (0.1%), tests_pri_0: 306 (38.4%), tests_pri_500:
	412 (51.8%), poll_dns_idle: 406 (51.0%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [RFC] lsm: namespace hooks
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lukasz Pawelczyk <l.pawelczyk@samsung.com> writes:

> On czw, 2014-11-27 at 09:42 -0600, Eric W. Biederman wrote:
>> Lukasz Pawelczyk <l.pawelczyk@samsung.com> writes:
>> 
>> > On czw, 2014-11-27 at 16:01 +0100, Richard Weinberger wrote:
>> >> Am 27.11.2014 um 15:44 schrieb Lukasz Pawelczyk:
>> >> > True, the last one is 0x80000000. I did not notice that. Thanks for
>> >> > pointing out.
>> >> 
>> >> Isn't this CLONE_IO?
>> >
>> > Yes, I was merely noticing out loud that it's the last bit of 32bit.
>> >
>> > After close look though the 0x00001000 appears to be unused
>> >
>> >> > Any suggestion on what can be done here? New syscal with flags2?
>> >> 
>> >> I'm not sure. But a new syscall would be a candidate.
>> 
>> We are probably going to need to go a couple rounds with this but at
>> first approximation I think this functionality needs to be tied to the
>> user namespace.  This functionality already looks half tied to it.
>> 
>> When mounting filesystems with user namespaces priveleges matures a
>> little more you should be able to use unmapped labels.  In the near term
>> we are looking at filesystems such as tmpfs, fuse and posibly extN.
>
> I presume you are referring to the Smack namespace readme where I
> mentioned mounts with specifying smack labels in the mount options, not
> to the quote above?
>
> I was referring the to the check here that has been changed to
> smack_ns_privileged() using ns_capable():
> http://lxr.free-electrons.com/source/security/smack/smack_lsm.c#L462
>
> And you can't use an unmapped Smack label inside the namespace, this
> would be completely against its idea.
>
> Anyway, at this point I'm more interested in the LSM namespace. I'll be
> doing an RFC for Smack namespace later.
>
> Unless I misunderstood your mail.

I had two points.
a) Tie the label mapping to the user namespace, then we don't need any
   new namespaces.

   Is there a reason not to tie the label mapping to the user namespace?

   Needing to modify every userspace that create containers to know
   about every different lsm looks like a maintenance difficulty I would
   prefer to avoid.

b) For filesystems that don't need uid mapping (say ext2 mounted with
   user namespace permissions) we shouldn't need LSM mapping either.

Eric
