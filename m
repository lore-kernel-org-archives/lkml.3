Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520AbaJRWpA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 18:45:00 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:55818 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbaJRWo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 18:44:58 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Maxim Patlasov <mpatlasov@parallels.com>,
        Anand Avati <avati@gluster.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael j Theall <mtheall@us.ibm.com>,
        fuse-devel <fuse-devel@lists.sourceforge.net>,
        linux-fsdevel@vger.kernel.org
References: <20140930191933.GC5011@tucsk.piliscsaba.szeredi.hu>
	<CA+55aFyD2Q6tJzRUbNyNFRdbSN09SAN9CqC5BTmCtOu4W9PKGw@mail.gmail.com>
	<542BE551.1010705@parallels.com>
	<CAJfpegs4Up_feUbqEGxfhq+rZneTmy0qcZy-k3so7VjufQY7-w@mail.gmail.com>
	<543F9E75.2090509@parallels.com>
	<CAJfpegvS+rmFqGgvHq183Z-MxLAwcgEB57LQxAwy3QAe5CaVwg@mail.gmail.com>
	<CA+55aFw68DMazGSu=YaOVVEWp=_LrD+2abah+5Tq3kpmH-r+Hg@mail.gmail.com>
	<20141017085509.GE5011@tucsk.piliscsaba.szeredi.hu>
	<CA+55aFyALiUbRVcxGGG79N-97pa997v9En64O9jLLBvBAO6vrA@mail.gmail.com>
	<CA+55aFyU2NgXYZSnNBwMR_ZyFuKzHna2NBBhwd6iev0uaEdqKA@mail.gmail.com>
	<20141018182241.GE7996@ZenIV.linux.org.uk>
Date: Sat, 18 Oct 2014 15:44:13 -0700
In-Reply-To: <20141018182241.GE7996@ZenIV.linux.org.uk> (Al Viro's message of
	"Sat, 18 Oct 2014 19:22:41 +0100")
Message-ID: <87a94t577m.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18c0VWRxZK3yUCy0i80wr21kKJzkfw5VkE=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.0 T_TVD_FUZZY_SECURITIES BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Al Viro <viro@ZenIV.linux.org.uk>
X-Spam-Relay-Country: 
X-Spam-Timing: total 1604 ms - load_scoreonly_sql: 0.05 (0.0%),
	signal_user_changed: 5 (0.3%), b_tie_ro: 3.5 (0.2%), parse: 1.29 (0.1%),
	extract_message_metadata: 16 (1.0%), get_uri_detail_list: 3.4 (0.2%),
	tests_pri_-1000: 4.8 (0.3%), tests_pri_-950: 1.00 (0.1%), tests_pri_-900:
	0.85 (0.1%), tests_pri_-400: 24 (1.5%), check_bayes: 23 (1.4%), b_tokenize: 5
	(0.3%), b_tok_get_all: 9 (0.5%), b_comp_prob: 3.5 (0.2%), b_tok_touch_all:
	2.8 (0.2%), b_finish: 0.80 (0.1%), tests_pri_0: 179 (11.2%), tests_pri_500:
	1368 (85.3%), poll_dns_idle: 1359 (84.7%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 0/5] fuse: handle release synchronously (v4)
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

> On Sat, Oct 18, 2014 at 08:40:05AM -0700, Linus Torvalds wrote:
>> On Sat, Oct 18, 2014 at 8:35 AM, Linus Torvalds
>> <torvalds@linux-foundation.org> wrote:
>> >
>> > Look around for AIO. Look around for the loop driver. Look around for
>> > a number of things that do "fget()" and that you completely ignored.
>> 
>> .. actually, there are more instances of "get_file()" than of
>> "fget()", the aio one just happened to be the latter form. Lots and
>> lots of ways to get ahold of a file descriptor that keeps it open past
>> the "last close".
>
> FWIW, procfs patch touches a very annoying issue: ->show_fdinfo() being
> blocking.  I would really like to get rid of that particular get_file()
> and even more so - of get_files_struct() in there.
>
> I certainly agree that anyone who expects that close() means the end of IO
> is completely misguided.  Mappings don't disappear on close(), neither does
> a descriptor returned by dup(), or one that child got over fork(),
> or something sent over in SCM_RIGHTS datagram, or, as you suggested, made
> backing store for /dev/loop, etc.
>
> What's more, in the example given upthread, somebody might've spotted that
> file in /proc/<pid>/fd/* and *opened* it.  At which point umount would
> have to fail with EBUSY.  And the same lsof(8) might've done just that.
>
> It's not a matter of correctness or security, especially since somebody who
> could do that, could've stopped your process, PTRACE_POKEd a fairly short
> series of syscalls that would connect to AF_UNIX socket, send the file
> over to them and clean after itself, then single-stepped through all of that,
> restored the original state and resumed your process.  
>
> It is a QoI matter, though.  And get_files_struct() in there is a lot more
> annoying than get_file()/fput().  Suppose you catch the process during
> exit().  All of a sudden, read from /proc/<pid>/fdinfo/<n> ends up doing
> shitloads of filp_close().  It would be nice to avoid that.
>
> Folks, how much pain would it be to make ->show_fdinfo() non-blocking?

I took a quick look and there are a couple of instances in tun,
eventpoll, and fanotify/inotify that take a spinlock while traversing
the data that needs to be printed.

So it would take a good hard stare at those pieces of code to understand
the locking, and potentially rewrite those routines.

The only one I am particularly familiar with tun did not look
fundamentally hard to change but it also isn't something I would
casually do either, as it would be easy to introduce nasty races by
accident.

Eric
