Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbaK0PoL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 10:44:11 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:51910 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865AbaK0PoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 10:44:04 -0500
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
Date: Thu, 27 Nov 2014 09:42:33 -0600
In-Reply-To: <1417101060.1805.21.camel@samsung.com> (Lukasz Pawelczyk's
	message of "Thu, 27 Nov 2014 16:11:00 +0100")
Message-ID: <87d288zm3a.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+rL2ya5eqeh9dKaFDqavQWo+Jo1+IUPLM=
X-SA-Exim-Connect-IP: 97.121.92.161
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Lukasz Pawelczyk <l.pawelczyk@samsung.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 366 ms - load_scoreonly_sql: 0.04 (0.0%),
	signal_user_changed: 3.1 (0.8%), b_tie_ro: 2.2 (0.6%), parse: 0.66 (0.2%),
	extract_message_metadata: 17 (4.7%), get_uri_detail_list: 1.27 (0.3%),
	tests_pri_-1000: 10 (2.7%), tests_pri_-950: 1.67 (0.5%), tests_pri_-900: 1.29
	(0.4%), tests_pri_-400: 29 (7.9%), check_bayes: 28 (7.6%), b_tokenize: 9
	(2.6%), b_tok_get_all: 8 (2.1%), b_comp_prob: 2.7 (0.7%), b_tok_touch_all:
	4.7 (1.3%), b_finish: 1.12 (0.3%), tests_pri_0: 274 (74.7%), tests_pri_500:
	26 (7.1%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [RFC] lsm: namespace hooks
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lukasz Pawelczyk <l.pawelczyk@samsung.com> writes:

> On czw, 2014-11-27 at 16:01 +0100, Richard Weinberger wrote:
>> Am 27.11.2014 um 15:44 schrieb Lukasz Pawelczyk:
>> > True, the last one is 0x80000000. I did not notice that. Thanks for
>> > pointing out.
>> 
>> Isn't this CLONE_IO?
>
> Yes, I was merely noticing out loud that it's the last bit of 32bit.
>
> After close look though the 0x00001000 appears to be unused
>
>> > Any suggestion on what can be done here? New syscal with flags2?
>> 
>> I'm not sure. But a new syscall would be a candidate.

We are probably going to need to go a couple rounds with this but at
first approximation I think this functionality needs to be tied to the
user namespace.  This functionality already looks half tied to it.

When mounting filesystems with user namespaces priveleges matures a
little more you should be able to use unmapped labels.  In the near term
we are looking at filesystems such as tmpfs, fuse and posibly extN.

Eric

