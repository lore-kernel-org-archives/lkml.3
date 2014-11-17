Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018AbaKQWox (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 17:44:53 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:54537 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135AbaKQWls convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 17:41:48 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <CALCETrVn4gVXp7F=5h-bkN5VWuRMG9BoxgeQfKhX4+ZXxGE=wQ@mail.gmail.com>
References: <3ccec8a13019b5e8ce7b1d7889677b778b070dc8.1416041823.git.josh@joshtriplett.org> <0895c1f268bc0b01cc6c8ed4607d7c3953f49728.1416041823.git.josh@joshtriplett.org> <546A3942.5040906@schaufler-ca.com> <CALCETrWy-3C1on3+2wE9aqcChBUCUY0i_4AL_Om8CSZ5QB18sQ@mail.gmail.com> <CALCETrVn4gVXp7F=5h-bkN5VWuRMG9BoxgeQfKhX4+ZXxGE=wQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8BIT
From: "Eric W.Biederman" <ebiederm@xmission.com>
Date: Mon, 17 Nov 2014 17:41:33 -0500
To: Andy Lutomirski <luto@amacapital.net>,
        Casey Schaufler <casey@schaufler-ca.com>
CC: Josh Triplett <josh@joshtriplett.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
        Linux API <linux-api@vger.kernel.org>,
        linux-man <linux-man@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <9f43a787-165e-4256-a097-f7691204d9d6@email.android.com>
X-XM-AID: U2FsdGVkX18zEDl7Kr/iIz282q03pCU7Cl/NdVEayeM=
X-SA-Exim-Connect-IP: 208.54.64.219
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.3 TooManyTo_001 Multiple "To" Header Recipients 2x (uncommon)
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5099]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.1 XMSolicitRefs_0 Weightloss drug
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Andy Lutomirski <luto@amacapital.net>,Casey Schaufler
	<casey@schaufler-ca.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 299 ms - load_scoreonly_sql: 0.03 (0.0%),
	signal_user_changed: 2.8 (0.9%), b_tie_ro: 2.1 (0.7%), parse: 0.66 (0.2%),
	extract_message_metadata: 14 (4.8%), get_uri_detail_list: 1.55 (0.5%),
	tests_pri_-1000: 8 (2.6%), tests_pri_-950: 1.00 (0.3%), tests_pri_-900: 0.85
	(0.3%), tests_pri_-400: 20 (6.8%), check_bayes: 19 (6.5%), b_tokenize: 5
	(1.8%), b_tok_get_all: 8 (2.5%), b_comp_prob: 2.0 (0.7%), b_tok_touch_all:
	2.7 (0.9%), b_finish: 0.57 (0.2%), tests_pri_0: 245 (81.9%), tests_pri_500:
	4.1 (1.4%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 2/2] groups: Allow unprivileged processes to use setgroups to drop groups
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On November 17, 2014 1:46:59 PM EST, Andy Lutomirski <luto@amacapital.net> wrote:
>On Mon, Nov 17, 2014 at 10:31 AM, Andy Lutomirski <luto@amacapital.net>
>wrote:
>> On Mon, Nov 17, 2014 at 10:06 AM, Casey Schaufler
>> <casey@schaufler-ca.com> wrote:
>>> On 11/15/2014 1:01 AM, Josh Triplett wrote:
>>>> Currently, unprivileged processes (without CAP_SETGID) cannot call
>>>> setgroups at all.  In particular, processes with a set of
>supplementary
>>>> groups cannot further drop permissions without obtaining elevated
>>>> permissions first.
>>>
>>> Has anyone put any thought into how this will interact with
>>> POSIX ACLs? I don't see that anywhere in the discussion.
>>
>> That means that user namespaces are a problem, too, and we need to
>fix
>> it.  Or we should add some control to turn unprivileged user
>namespace
>> creation on and off and document that turning it on defeats POSIX
>ACLs
>> with a group entry that is more restrictive than the other entry.
>>
>
>This is a significant enough issue that I posted it to oss-security:
>
>http://www.openwall.com/lists/oss-security/2014/11/17/19
>
>It's not at all obvious to me how to fix it.  We could disallow userns
>creation of any supplementary groups don't match fsuid, or we could
>keep negative-only groups around in the userns.
>
>It may be worth adding a sysctl to change the behavior, too.  IMO it's
>absurd to use groups to deny permissions that are otherwise available.

There is an obvious user namespace fix.  Don't allow dropping supplemental groups that are not mapped.

That will require a little bit of fancy footwork if you want to play with supplemental groups in your unprivileged user namespace.   I would like to get a grip on what hoops would be required before we add the additional restriction.  Possibly something as simple as calling sg.

I also want to look at what Tizen and any other concrete pieces of code I can find using this negative permission pattern are actually doing.   Bugs definitely exist, but I have this erie feeling that the bugs may be in instances of userspace using this negative group permission pattern.  I think we may have a hideous case of one setuid binary defeating a privilege check of another piece of code.

This issue looks like it is worth a full scale investigation.  Sigh.

Eric
