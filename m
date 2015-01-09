Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232AbbAIWQR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 17:16:17 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:57345 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbbAIWQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 17:16:14 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Rich Felker <dalias@aerifal.cx>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, David Drysdale <drysdale@google.com>,
        "Michael Kerrisk \(man-pages\)" <mtk.manpages@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Meredydd Luff <meredydd@senatehouse.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>,
        X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>, sparclinux@vger.kernel.org
References: <1416830039-21952-1-git-send-email-drysdale@google.com>
	<1416830039-21952-6-git-send-email-drysdale@google.com>
	<54AFF813.7050604@gmail.com>
	<20150109161302.GQ4574@brightrain.aerifal.cx>
	<CAHse=S88Jy5ZKM_VY5onfvxX7dTMngnxuHfuLeSuzvKvQNP19A@mail.gmail.com>
	<20150109204815.GR4574@brightrain.aerifal.cx>
	<20150109205626.GK22149@ZenIV.linux.org.uk>
	<20150109205926.GT4574@brightrain.aerifal.cx>
	<20150109210941.GL22149@ZenIV.linux.org.uk>
	<20150109212852.GU4574@brightrain.aerifal.cx>
Date: Fri, 09 Jan 2015 16:13:27 -0600
In-Reply-To: <20150109212852.GU4574@brightrain.aerifal.cx> (Rich Felker's
	message of "Fri, 9 Jan 2015 16:28:52 -0500")
Message-ID: <87lhlbvbzs.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+Fl0gmuCw5SZJjezp/765dZunbRUzktOk=
X-SA-Exim-Connect-IP: 97.121.85.189
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  0.7 XMSubLong Long Subject
	*  3.0 XMDrug1234561 Drug references
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_04 7+ unique symbols in subject
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *****;Rich Felker <dalias@aerifal.cx>
X-Spam-Relay-Country: 
X-Spam-Timing: total 312 ms - load_scoreonly_sql: 0.04 (0.0%),
	signal_user_changed: 3.4 (1.1%), b_tie_ro: 2.4 (0.8%), parse: 0.71 (0.2%),
	extract_message_metadata: 15 (4.7%), get_uri_detail_list: 1.42 (0.5%),
	tests_pri_-1000: 6 (2.0%), tests_pri_-950: 1.29 (0.4%), tests_pri_-900: 1.11
	(0.4%), tests_pri_-400: 26 (8.4%), check_bayes: 25 (8.0%), b_tokenize: 7
	(2.2%), b_tok_get_all: 9 (2.9%), b_comp_prob: 2.5 (0.8%), b_tok_touch_all:
	4.3 (1.4%), b_finish: 0.68 (0.2%), tests_pri_0: 250 (80.2%), tests_pri_500: 5
	(1.6%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCHv10 man-pages 5/5] execveat.2: initial man page for execveat(2)
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rich Felker <dalias@aerifal.cx> writes:

> On Fri, Jan 09, 2015 at 09:09:41PM +0000, Al Viro wrote:

> The "magic open-once magic symlink" approach is really the cleanest
> solution I can find. In the case where the interpreter does not open
> the script, nothing terribly bad happens; the magic symlink just
> sticks around until _exit or exec. In the case where the interpreter
> opens it more than once, you get a failure, but as far as I know
> existing interpreters don't do this, and it's arguably bad design. In
> any case it's a caught error.

And it doesn't work without introducing security vulnerabilities into
the kernel, because it breaks close-on-exec semantics.

All you have to do is pick a file descriptor, good canidates are 0 and
255 and make it a convention that that file descriptor is used for
fexecve.  At least when you want to support scripts.  Otherwise you can
set close-on-exec.

That results in no accumulation of file descriptors  because everyone
always uses the same file descriptor.

Regardless you don't have a patch and you aren't proposing code and the
code isn't actually broken so please go away.

Eric
