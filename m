Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571AbaLHWqn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 17:46:43 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:46503 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbaLHWqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 17:46:40 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
        Linux API <linux-api@vger.kernel.org>,
        linux-man <linux-man@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Richard Weinberger <richard@nod.at>,
        Kenton Varda <kenton@sandstorm.io>, stable <stable@vger.kernel.org>
References: <52e0643bd47b1e5c65921d6e00aea1f724bb510a.1417281801.git.luto@amacapital.net>
	<87h9xez20g.fsf@x220.int.ebiederm.org>
	<CALCETrXOz4C7Tu8mggBtR=k47ZmkuAhinVUxWJSFyS1Ep0HvRw@mail.gmail.com>
	<87mw75ygwp.fsf@x220.int.ebiederm.org>
	<CALCETrVfO4sBdZcQiZXsofPZMj7pqKeVbX+4g3dAj6WjUca+1w@mail.gmail.com>
	<87fvcxyf28.fsf_-_@x220.int.ebiederm.org>
	<874mtdyexp.fsf_-_@x220.int.ebiederm.org>
	<CALCETrXyC7XPaqj6oe-TmyypOVc_CkZbF6UAAx8YfkyD=gEMOQ@mail.gmail.com>
	<87a935u3nj.fsf@x220.int.ebiederm.org>
	<CALCETrXkEOiyzpvqtXtk1f4sL+M1Q-Y6rV=K91ez3yv2nb4Y0Q@mail.gmail.com>
	<87388xodlj.fsf@x220.int.ebiederm.org>
	<CALCETrXWx2-ZejEHmOi7aSoF-qJMRGR5yseeMhuurZwJRrQbUg@mail.gmail.com>
	<87h9x5re41.fsf_-_@x220.int.ebiederm.org>
	<87mw6xpzb0.fsf_-_@x220.int.ebiederm.org>
	<CALCETrU-o5mPr1jCaLXDuuF6J2N470zAtx=8Fa-SjF=ZpdE8mQ@mail.gmail.com>
Date: Mon, 08 Dec 2014 16:44:24 -0600
In-Reply-To: <CALCETrU-o5mPr1jCaLXDuuF6J2N470zAtx=8Fa-SjF=ZpdE8mQ@mail.gmail.com>
	(Andy Lutomirski's message of "Mon, 8 Dec 2014 14:21:58 -0800")
Message-ID: <87ppbtn4mv.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18A+qFN1Jr1YBXUdFLCPpp5E/Li/uc7QY8=
X-SA-Exim-Connect-IP: 67.3.210.55
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 XMSubMetaSx_00 1+ Sexy Words
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  1.2 XMSubMetaSSx_00 1+ SortaSexy Words + 1 Sexy Word
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ******;Andy Lutomirski <luto@amacapital.net>
X-Spam-Relay-Country: 
X-Spam-Timing: total 283 ms - load_scoreonly_sql: 0.07 (0.0%),
	signal_user_changed: 3.8 (1.3%), b_tie_ro: 2.6 (0.9%), parse: 1.14 (0.4%),
	extract_message_metadata: 17 (6.0%), get_uri_detail_list: 1.79 (0.6%),
	tests_pri_-1000: 9 (3.1%), tests_pri_-950: 1.31 (0.5%), tests_pri_-900: 1.12
	(0.4%), tests_pri_-400: 23 (8.1%), check_bayes: 22 (7.6%), b_tokenize: 7
	(2.3%), b_tok_get_all: 8 (2.7%), b_comp_prob: 2.5 (0.9%), b_tok_touch_all:
	2.5 (0.9%), b_finish: 0.71 (0.3%), tests_pri_0: 219 (77.5%), tests_pri_500:
	4.4 (1.6%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [CFT][PATCH 6/7] userns: Add a knob to disable setgroups on a per user namespace basis
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> writes:

> On Mon, Dec 8, 2014 at 2:11 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>>
>> - Expose the knob to user space through a proc file /proc/<pid>/setgroups
>>
>>   A value of 0 means the setgroups system call is disabled in the
>
> "deny"
>
>>   current processes user namespace and can not be enabled in the
>>   future in this user namespace.
>>
>>   A value of 1 means the segtoups system call is enabled.
>>
>
> "allow"
>
>> - Descedent user namespaces inherit the value of setgroups from
>
> s/Descedent/Descendent/

Bah.  I updated everything but the changelog comment.

>> --- a/kernel/groups.c
>> +++ b/kernel/groups.c
>> @@ -222,6 +222,7 @@ bool may_setgroups(void)
>>          * the user namespace has been established.
>>          */
>>         return userns_gid_mappings_established(user_ns) &&
>> +               userns_setgroups_allowed(user_ns) &&
>>                 ns_capable(user_ns, CAP_SETGID);
>>  }
>
> Can you add a comment explaining the ordering?  For example:

I need to think on what I can say to make it clear.
Perhaps: /* Careful the order of these checks is important. */

> We need to check for a gid mapping before checking setgroups_allowed
> because an unprivileged user can create a userns with setgroups
> allowed, then disallow setgroups and add a mapping.  If we check in
> the opposite order, then we have a race: we could see that setgroups
> is allowed before the user clears the bit and then see that there is a
> gid mapping after the other thread is done.

Since these are independent atomic variables yes that ordering issue
seems to be the case.

For me it was the natural ordering of the checks so I didn't even bother
to think about what happens when you reorder them.

Eric
