Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038AbaKPDJS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 22:09:18 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:54565 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbaKPDJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 22:09:16 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Josh Triplett <josh@joshtriplett.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
        Linux API <linux-api@vger.kernel.org>,
        linux-man <linux-man@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <3ccec8a13019b5e8ce7b1d7889677b778b070dc8.1416041823.git.josh@joshtriplett.org>
	<0895c1f268bc0b01cc6c8ed4607d7c3953f49728.1416041823.git.josh@joshtriplett.org>
	<87d28osceg.fsf@x220.int.ebiederm.org> <20141115192924.GB19060@thin>
	<CALCETrUM=GqsOumTmDMF4B5GS1w=x56t41eE-2xW1bBOfUz02w@mail.gmail.com>
	<20141115202042.GA20900@thin> <20141116020511.GB5507@thunk.org>
	<6C690A2C-8EB1-421A-94C3-9803AFB95760@joshtriplett.org>
Date: Sat, 15 Nov 2014 21:08:07 -0600
In-Reply-To: <6C690A2C-8EB1-421A-94C3-9803AFB95760@joshtriplett.org> (Josh
	Triplett's message of "Sat, 15 Nov 2014 18:35:05 -0800")
Message-ID: <87vbmfq1uw.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18f7lkHhn/TNQd2KyYd5vkGvl9owVAF9sk=
X-SA-Exim-Connect-IP: 97.121.92.161
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  1.0 T_XMDrugObfuBody_04 obfuscated drug references
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ****;Josh Triplett <josh@joshtriplett.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 646 ms - load_scoreonly_sql: 0.06 (0.0%),
	signal_user_changed: 3.5 (0.5%), b_tie_ro: 2.5 (0.4%), parse: 1.31 (0.2%),
	extract_message_metadata: 26 (4.1%), get_uri_detail_list: 3.3 (0.5%),
	tests_pri_-1000: 9 (1.4%), tests_pri_-950: 2.1 (0.3%), tests_pri_-900: 1.70
	(0.3%), tests_pri_-400: 38 (5.9%), check_bayes: 36 (5.6%), b_tokenize: 14
	(2.1%), b_tok_get_all: 10 (1.5%), b_comp_prob: 6 (0.9%), b_tok_touch_all: 2.8
	(0.4%), b_finish: 0.83 (0.1%), tests_pri_0: 551 (85.2%), tests_pri_500: 7
	(1.2%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 2/2] groups: Allow unprivileged processes to use setgroups to drop groups
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Josh Triplett <josh@joshtriplett.org> writes:

> On November 15, 2014 6:05:11 PM PST, Theodore Ts'o <tytso@mit.edu> wrote:
>>On Sat, Nov 15, 2014 at 12:20:42PM -0800, Josh Triplett wrote:
>>> > However, sudoers seems to allow negative group matches.  So maybe
>>> > allowing this only with no_new_privs already set would make sense.
>>> 
>>> Sigh, bad sudo.  Sure, restricting this to no_new_privs only seems
>>fine.
>>> I'll do that in v2, and document that in the manpage.
>>
>>I've also seen use cases (generally back in the bad old days of big
>>timesharing VAX 750's :-) where the system admin might assign someone
>>to the "games-abusers" group, and then set /usr/games to mode 705
>>root:games-abusers --- presumably because it's easier to add a few
>>people to the deny list rather than having to add all of the EECS
>>department to the games group minus the abusers.
>>
>>So arbitrarily anyone to drop groups from their supplemental group
>>list will result in a change from both existing practice and legacy
>>Unix systems, and it could potentially lead to a security exposure.
>
> As Andy pointed out, you can already do that with a user namespace,

That may be a bug with the user namespace permission check.  Perhaps we
shouldn't allow dropping groups that aren't mapped in the user
namespace.

To add to the discussion there are also sg and newgroup, though I don't
think they touch supplementary groups.

> for any case not involving a setuid or setgid (or otherwise
> privilege-gaining) program.  And requiring no_new_privs handles that.

Frankly adding a no_new_privs check to allow something/anything scares
me.  That converts no_new_privs from something simple and easy to
understand to something much more complicated.

> Given the combination of those two things, do you still see any
> problematic cases?

Josh I think it is time to stop and make certain you understand how
unix groups work in the large.

It seems to me that either supplementary groups can be dropped or
supplementary groups can not be dropped.  If they can be dropped we
shouldn't need complicated checks to allow them to be dropped in some
circumstances but not others.

Unix groups are an old interface and they have been used in a lot of
ways over the years.  We need to be careful any change we make is good
and truly backwards compatible and that we do our darndest not to
introduce security holes.

Eric
