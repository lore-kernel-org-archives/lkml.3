Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236AbbAIVXG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 16:23:06 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:48793 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758192AbbAIVXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 16:23:01 -0500
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
Date: Fri, 09 Jan 2015 15:20:04 -0600
In-Reply-To: <20150109205926.GT4574@brightrain.aerifal.cx> (Rich Felker's
	message of "Fri, 9 Jan 2015 15:59:26 -0500")
Message-ID: <877fwvy7ln.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18HEtwMQCgo9aY5ftksieFCztab198XAWc=
X-SA-Exim-Connect-IP: 97.121.85.189
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  0.7 XMSubLong Long Subject
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  3.0 XMDrug1234561 Drug references
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.0 T_TooManySym_04 7+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *****;Rich Felker <dalias@aerifal.cx>
X-Spam-Relay-Country: 
X-Spam-Timing: total 265 ms - load_scoreonly_sql: 0.06 (0.0%),
	signal_user_changed: 3.1 (1.2%), b_tie_ro: 2.2 (0.8%), parse: 0.75 (0.3%),
	extract_message_metadata: 15 (5.7%), get_uri_detail_list: 1.10 (0.4%),
	tests_pri_-1000: 6 (2.1%), tests_pri_-950: 1.07 (0.4%), tests_pri_-900: 0.90
	(0.3%), tests_pri_-400: 28 (10.7%), check_bayes: 27 (10.2%), b_tokenize: 11
	(4.2%), b_tok_get_all: 8 (3.0%), b_comp_prob: 3.1 (1.2%), b_tok_touch_all:
	2.4 (0.9%), b_finish: 0.67 (0.3%), tests_pri_0: 202 (76.0%), tests_pri_500: 6
	(2.2%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCHv10 man-pages 5/5] execveat.2: initial man page for execveat(2)
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rich Felker <dalias@aerifal.cx> writes:

> On Fri, Jan 09, 2015 at 08:56:26PM +0000, Al Viro wrote:
>> On Fri, Jan 09, 2015 at 03:48:15PM -0500, Rich Felker wrote:
>> > I think this is a case that needs to be fixed, though it's hard. The
>> > normal correct usage for fexecve is to always pass an O_CLOEXEC file
>> > descriptor, and the caller can't really be expected to know whether
>> > the file is a script or not. We discussed workarounds before and one
>> > idea I proposed was having fexecve provide a "one open only" magic
>> > symlink in /proc/self/ to pass to the interpreter. It would behave
>> > like an O_PATH file descriptor magic symlink in /proc/self/fd, but
>> > would automatically cease to exist on the first open (at which point
>> > the interpreter would have a real O_RDONLY file descriptor for the
>> > underlying file).
>> 
>> For fsck sake, folks, if you have bloody /proc, you don't need that shite
>> at all!  Just do execve on /proc/self/fd/n, and be done with that.
>> 
>> The sole excuse for merging that thing in the first place had been
>> "would anybody think of children^Wsclerotic^Whardened environments
>> where they have no /proc at all".
>
> That doesn't work. With O_CLOEXEC, /proc/self/fd/n is already gone at
> the time the interpreter runs, whether you're using fexecveat or
> execve with "/proc/self/fd/n" to implement POSIX fexecve(). That's the
> problem. This breaks the intended idiom for fexecve.

O_CLOEXEC with a #! intepreter can not work.  If the file descriptor is
closed a #! interpreter can not open it.   So I don't know why or how
you want that to work but it is nonsense.

This certainly does not break the intended usage for execveat.

Eric

