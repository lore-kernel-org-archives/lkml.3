Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279AbbAGWR1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 17:17:27 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:42596 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbbAGWRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 17:17:24 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Richard Weinberger <richard@nod.at>, Linux API <linux-api@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Tejun Heo <tj@kernel.org>,
        cgroups mailinglist <cgroups@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>
References: <1417744550-6461-9-git-send-email-adityakali@google.com>
	<548E17CE.8010704@nod.at>
	<CAGr1F2HA6mzFwgp5ngX8P7=198-5CmCjLmuCJ8j3eQ08J2d9Qw@mail.gmail.com>
	<54AB15BD.8020007@nod.at> <87lhlgpyxk.fsf@x220.int.ebiederm.org>
	<CAGr1F2HSi_D07r2c5CKOsjSR1+58k9G2MrtACsd+HV6XKvJ7cA@mail.gmail.com>
	<54AB2992.6060707@nod.at>
	<CAGr1F2EGOUSEd3-G4PS0mq=9kU1nWG4CwHUOQaNUATepc11_Sw@mail.gmail.com>
	<54ACFC38.5070007@nod.at> <87fvbmir9q.fsf@x220.int.ebiederm.org>
	<20150107193059.GA1857@mail.hallyn.com>
Date: Wed, 07 Jan 2015 16:14:40 -0600
In-Reply-To: <20150107193059.GA1857@mail.hallyn.com> (Serge E. Hallyn's
	message of "Wed, 7 Jan 2015 20:30:59 +0100")
Message-ID: <87bnma6xwv.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/1riHNvoDcGXREeS8fpuppyR750EydYyk=
X-SA-Exim-Connect-IP: 97.121.85.189
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4999]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;"Serge E. Hallyn" <serge@hallyn.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 194 ms - load_scoreonly_sql: 0.03 (0.0%),
	signal_user_changed: 2.7 (1.4%), b_tie_ro: 2.0 (1.1%), parse: 0.58 (0.3%),
	extract_message_metadata: 9 (4.6%), get_uri_detail_list: 0.74 (0.4%),
	tests_pri_-1000: 3.9 (2.0%), tests_pri_-950: 0.98 (0.5%), tests_pri_-900:
	0.85 (0.4%), tests_pri_-400: 20 (10.5%), check_bayes: 19 (10.0%), b_tokenize:
	5 (2.7%), b_tok_get_all: 7 (3.5%), b_comp_prob: 1.64 (0.8%), b_tok_touch_all:
	2.4 (1.2%), b_finish: 0.67 (0.3%), tests_pri_0: 148 (76.2%), tests_pri_500: 5
	(2.7%), poll_dns_idle: 0.35 (0.2%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCHv3 8/8] cgroup: Add documentation for cgroup namespaces
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serge@hallyn.com> writes:

>>   By unified hierarchy I mean that  every mount of cgroupfs has the
>> same directories with the same processes in each directory.
>
> No, my reading of Documentation/cgroups/unified-hierarchy.txt is that
> unified hierarchy means that all (sane) controllers are co-mounted into
> one hierarchy.

I see what you mean.  If it is indeed the case than a mount of cgroupfs
using the unified hiearchy and can not specify which controllers are
present under that mount that very significant bug and presents a very
significant regression in user space flexibility.

I think you can still mount the unified hierarchy and select which
controls you want to see.  If you can not that is a change significantly
past what was agreed to and a regression fix needs to be applied.

With a unified hierarchy and separate controllers per mount many cgroup
using applications will continue to work as before without changes, or
with minimal changes.  That is what was agreed to and what I expect has
been actually implemented and it is what needs to be implemented in any
case.

I will see about making time to see where things are really at.

Eric
