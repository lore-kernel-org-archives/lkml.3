Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751199AbaKXV3G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 16:29:06 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:56107 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbaKXV3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 16:29:04 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Aaron Tomlin <atomlin@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Sterling Alexander <stalexan@redhat.com>, linux-kernel@vger.kernel.org
References: <20141107201424.GA22209@redhat.com>
	<20141124200602.GA20575@redhat.com>
Date: Mon, 24 Nov 2014 15:27:47 -0600
In-Reply-To: <20141124200602.GA20575@redhat.com> (Oleg Nesterov's message of
	"Mon, 24 Nov 2014 21:06:02 +0100")
Message-ID: <87fvd8gugc.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18ka+iDA07VBCMsJJRG8URuVJKB1MdE8ko=
X-SA-Exim-Connect-IP: 97.121.92.161
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 175 ms - load_scoreonly_sql: 0.05 (0.0%),
	signal_user_changed: 4.4 (2.5%), b_tie_ro: 3.2 (1.8%), parse: 1.14 (0.7%),
	extract_message_metadata: 4.4 (2.5%), get_uri_detail_list: 1.97 (1.1%),
	tests_pri_-1000: 2.8 (1.6%), tests_pri_-950: 1.01 (0.6%), tests_pri_-900:
	0.84 (0.5%), tests_pri_-400: 16 (9.4%), check_bayes: 15 (8.7%), b_tokenize:
	3.8 (2.2%), b_tok_get_all: 6 (3.3%), b_comp_prob: 1.61 (0.9%),
	b_tok_touch_all: 2.4 (1.4%), b_finish: 0.62 (0.4%), tests_pri_0: 128 (73.3%),
	tests_pri_500: 3.8 (2.2%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 0/2] exit/pid_ns: comments + simple fix
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> Eric, Pavel, could you review 1/2 ? (documentation only). It is based on the
> code inspection, I didn't bother to verify that my understanding matches the
> reality ;)

Oleg you are being subtle, introducing some gratuitous changes and
slightly off base which makes this all very hard to review.

Eric


> On 11/20, Oleg Nesterov wrote:
>>
>>
>> Probably this is not the last series... in particular it seems that we
>> have some problems with sys_setns() in this area, but I need to recheck.
>
> So far only the documentation fix. I'll write another email (hopefully with the
> patch), afaics at least setns() doesn't play well with PR_SET_CHILD_SUBREAPER.
>
> Contrary to what I thought zap_pid_ns_processes() looks fine, but it seems only
> by accident. Unless I am totally confused, wait for "nr_hashed == init_pids"
> could be removed after 0a01f2cc390e10633a "pidns: Make the pidns proc mount/
> umount logic obvious". However, now that setns() + fork() can inject a task
> into a child namespace, we need this code again for another reason.
>
> I _think_ we can actually remove it and simplify free_pid() as well, but lets
> discuss this later and fix the wrong/confusing documentation first.
>
> 2/2 looks "obviously correct", but I'll appreciate your review anyway.
>
> Oleg.
>
>  kernel/pid.c           |    7 +++----
>  kernel/pid_namespace.c |   23 +++++++++++++++++++----
>  2 files changed, 22 insertions(+), 8 deletions(-)
