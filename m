Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbbAJBUc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 20:20:32 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:57555 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbbAJBU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 20:20:29 -0500
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
References: <1416830039-21952-6-git-send-email-drysdale@google.com>
	<54AFF813.7050604@gmail.com>
	<20150109161302.GQ4574@brightrain.aerifal.cx>
	<CAHse=S88Jy5ZKM_VY5onfvxX7dTMngnxuHfuLeSuzvKvQNP19A@mail.gmail.com>
	<20150109204815.GR4574@brightrain.aerifal.cx>
	<20150109205626.GK22149@ZenIV.linux.org.uk>
	<20150109205926.GT4574@brightrain.aerifal.cx>
	<20150109210941.GL22149@ZenIV.linux.org.uk>
	<20150109212852.GU4574@brightrain.aerifal.cx>
	<87lhlbvbzs.fsf@x220.int.ebiederm.org>
	<20150109223843.GX4574@brightrain.aerifal.cx>
Date: Fri, 09 Jan 2015 19:17:41 -0600
In-Reply-To: <20150109223843.GX4574@brightrain.aerifal.cx> (Rich Felker's
	message of "Fri, 9 Jan 2015 17:38:43 -0500")
Message-ID: <87mw5rtowa.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+l1Cf9wr/73QZD0AkohmWS43mllKsD56E=
X-SA-Exim-Connect-IP: 97.121.85.189
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  3.0 XMDrug1234561 Drug references
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_04 7+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *****;Rich Felker <dalias@aerifal.cx>
X-Spam-Relay-Country: 
X-Spam-Timing: total 360 ms - load_scoreonly_sql: 0.06 (0.0%),
	signal_user_changed: 3.9 (1.1%), b_tie_ro: 2.7 (0.7%), parse: 1.00 (0.3%),
	extract_message_metadata: 12 (3.3%), get_uri_detail_list: 1.05 (0.3%),
	tests_pri_-1000: 6 (1.7%), tests_pri_-950: 1.32 (0.4%), tests_pri_-900: 1.14
	(0.3%), tests_pri_-400: 23 (6.5%), check_bayes: 22 (6.2%), b_tokenize: 6
	(1.8%), b_tok_get_all: 8 (2.1%), b_comp_prob: 1.83 (0.5%), b_tok_touch_all:
	3.7 (1.0%), b_finish: 0.83 (0.2%), tests_pri_0: 182 (50.6%), tests_pri_500:
	126 (34.9%), poll_dns_idle: 119 (33.1%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCHv10 man-pages 5/5] execveat.2: initial man page for execveat(2)
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rich Felker <dalias@aerifal.cx> writes:

> I'm not proposing code because I'm a libc developer not a kernel
> developer. I know what's needed for userspace to provide a conforming
> fexecve to applications, not how to implement that on the kernel side,
> although I'm trying to provide constructive ideas. The hostility is
> really not necessary.

Conforming to what?

The open group fexecve says nothing about requiring a file descriptor
passed to fexecve to have O_CLOEXEC.

Further looking at open group specification of exec it seems to indicate
the preferred way to handle this is for the kernel to return O_NOEXEC
and then libc gets to figure out how to run the shell script.  Is that
the kind of ``conforming'' implementation you are looking for?

Eric
