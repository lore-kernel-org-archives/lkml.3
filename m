Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130AbaKQWMN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 17:12:13 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:40791 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbaKQWMK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 17:12:10 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <CALCETrXi1qHyu4_U7cbROB74n461nBZ9R7=0kfhR8-VFAwOF1w@mail.gmail.com>
References: <3ccec8a13019b5e8ce7b1d7889677b778b070dc8.1416041823.git.josh@joshtriplett.org> <0895c1f268bc0b01cc6c8ed4607d7c3953f49728.1416041823.git.josh@joshtriplett.org> <87d28osceg.fsf@x220.int.ebiederm.org> <20141115192924.GB19060@thin> <CALCETrUM=GqsOumTmDMF4B5GS1w=x56t41eE-2xW1bBOfUz02w@mail.gmail.com> <20141115202042.GA20900@thin> <20141116020511.GB5507@thunk.org> <6C690A2C-8EB1-421A-94C3-9803AFB95760@joshtriplett.org> <20141116034005.GC5507@thunk.org> <20141116045232.GB18880@thin> <20141117113734.396798e6@lxorguk.ukuu.org.uk> <CALCETrXi1qHyu4_U7cbROB74n461nBZ9R7=0kfhR8-VFAwOF1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8BIT
From: "Eric W.Biederman" <ebiederm@xmission.com>
Date: Mon, 17 Nov 2014 17:11:57 -0500
To: Andy Lutomirski <luto@amacapital.net>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: linux-man <linux-man@vger.kernel.org>, "Ted Ts'o" <tytso@mit.edu>,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>
Message-ID: <0b65fd07-48ea-483b-8fd5-fd84d0bff881@email.android.com>
X-XM-AID: U2FsdGVkX18lGTxyXUXQj3nypMZRIfntGQ5oVf50AsU=
X-SA-Exim-Connect-IP: 208.54.64.219
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.3 TooManyTo_001 Multiple "To" Header Recipients 2x (uncommon)
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4997]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Andy Lutomirski <luto@amacapital.net>,One Thousand Gnomes
	<gnomes@lxorguk.ukuu.org.uk>
X-Spam-Relay-Country: 
X-Spam-Timing: total 312 ms - load_scoreonly_sql: 0.04 (0.0%),
	signal_user_changed: 3.3 (1.1%), b_tie_ro: 2.4 (0.8%), parse: 0.73 (0.2%),
	extract_message_metadata: 14 (4.5%), get_uri_detail_list: 1.18 (0.4%),
	tests_pri_-1000: 7 (2.2%), tests_pri_-950: 1.22 (0.4%), tests_pri_-900: 1.11
	(0.4%), tests_pri_-400: 18 (5.9%), check_bayes: 17 (5.6%), b_tokenize: 4.9
	(1.6%), b_tok_get_all: 6 (2.0%), b_comp_prob: 1.96 (0.6%), b_tok_touch_all:
	2.2 (0.7%), b_finish: 0.70 (0.2%), tests_pri_0: 255 (81.7%), tests_pri_500: 8
	(2.6%), poll_dns_idle: 0.24 (0.1%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 2/2] groups: Allow unprivileged processes to use setgroups to drop groups
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On November 17, 2014 1:07:30 PM EST, Andy Lutomirski <luto@amacapital.net> wrote:
>On Nov 17, 2014 3:37 AM, "One Thousand Gnomes"
><gnomes@lxorguk.ukuu.org.uk> wrote:
>>
>> > optional), I can do that too.  The security model of "having a
>group
>> > gives you less privilege than not having it" seems crazy, but
>> > nonetheless I can see a couple of easy ways that we can avoid
>breaking
>>
>> It's an old pattern of use that makes complete sense in a traditional
>> Unix permission world because it's the only way to do "exclude
>{list}"
>> nicely. Our default IMHO shouldn't break this.
>>
>> > that pattern, no_new_privs being one of them.  I'd like to make
>sure
>> > that nobody sees any other real-world corner case that unprivileged
>> > setgroups would break.
>>
>> Barring the usual risk of people doing improper error checking I
>don't
>> see one immediately.
>>
>> For containers I think it actually makes sense that the sysctl can be
>> applied per container anyway.
>
>We'll probably need per container sysctls some day.

We already have a mess of per network namespace sysctls,
as well as few for other namespaces.

We have the infrastructure it is just a matter of using it for whatever purpose we need.

Eric

