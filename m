Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719AbbAKCMD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 21:12:03 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:45136 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbbAKCL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 21:11:59 -0500
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
References: <20150109223300.GO22149@ZenIV.linux.org.uk>
	<20150109224252.GY4574@brightrain.aerifal.cx>
	<20150109225743.GP22149@ZenIV.linux.org.uk>
	<20150109231248.GZ4574@brightrain.aerifal.cx>
	<20150109233644.GR22149@ZenIV.linux.org.uk>
	<20150110030300.GU22149@ZenIV.linux.org.uk>
	<20150110034144.GC4574@brightrain.aerifal.cx>
	<20150110041457.GV22149@ZenIV.linux.org.uk>
	<20150110055713.GE4574@brightrain.aerifal.cx>
	<878uhaqnjo.fsf@x220.int.ebiederm.org>
	<20150111011559.GG4574@brightrain.aerifal.cx>
Date: Sat, 10 Jan 2015 20:09:10 -0600
In-Reply-To: <20150111011559.GG4574@brightrain.aerifal.cx> (Rich Felker's
	message of "Sat, 10 Jan 2015 20:15:59 -0500")
Message-ID: <87oaq6oypl.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/4xsTbU9LD4Jxve+3JApD5HAtQPDfnbs0=
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
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *****;Rich Felker <dalias@aerifal.cx>
X-Spam-Relay-Country: 
X-Spam-Timing: total 476 ms - load_scoreonly_sql: 0.10 (0.0%),
	signal_user_changed: 4.5 (0.9%), b_tie_ro: 2.9 (0.6%), parse: 1.37 (0.3%),
	extract_message_metadata: 18 (3.8%), get_uri_detail_list: 2.1 (0.4%),
	tests_pri_-1000: 7 (1.5%), tests_pri_-950: 1.36 (0.3%), tests_pri_-900: 1.13
	(0.2%), tests_pri_-400: 32 (6.8%), check_bayes: 31 (6.5%), b_tokenize: 13
	(2.8%), b_tok_get_all: 9 (1.9%), b_comp_prob: 3.6 (0.8%), b_tok_touch_all:
	2.7 (0.6%), b_finish: 0.71 (0.1%), tests_pri_0: 400 (84.1%), tests_pri_500: 6
	(1.2%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCHv10 man-pages 5/5] execveat.2: initial man page for execveat(2)
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rich Felker <dalias@aerifal.cx> writes:

> On Sat, Jan 10, 2015 at 04:27:23PM -0600, Eric W. Biederman wrote:
>> Rich Felker <dalias@aerifal.cx> writes:
>> 
>> > On Sat, Jan 10, 2015 at 04:14:57AM +0000, Al Viro wrote:
>> 
>> >> Except that if your interpreter does stat(2) (or access(2), or getxattr(2),
>> >> etc.) before bothering with open(2), you'll get screwed.
>> >
>> > Yes, but I think that would be very bad interpreter design.
>> > stat/getxattr/access/whatever followed by open is always a TOCTOU
>> > race. The correct sequence of actions is always open followed by
>> > fstat/fgetxattr/...
>> 
>> Sigh.  I think everyone who has looked at this has been blind.
>> 
>> If userspace is reasonable all we have to do is fix /proc/self/exe
>> for shell scripts to point at the actual script,
>> and then pass /proc/self/exe on the shell scripts command line.
>> 
>> At a practical level we have to worry about backwards compability and
>> chroot jails.  But the existence of a clean implementation with
>> /proc/self/exe serves a proof of concept that it would not be too
>> difficult.  When someone cares enough to implement it.
>
> Is /proc/self/exe a "magic symlink" that's bound to the inode, or just
> a regular symlink? In the latter case it defeats the whole purpose of
> using O_EXEC fds and fexecve rather than pathnames.

In implementation /proc/self/exe is a named rather than a numbered file
descriptor.  Essentially when loading an elf executable the file
descriptor is duped to the name /proc/self/exe.  The implementation
otherwise is the same as /proc/self/fd/N.

The downside of course is that I expect if we were actually to change
/proc/self/exe from to point at the script instead of the shell some
piece of software somewhere would come melting down.  I am totally not
ready to consider that kind of mine field today.

Eric

