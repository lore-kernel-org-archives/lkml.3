Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbbAJBe2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 20:34:28 -0500
Received: from 216-12-86-13.cv.mvl.ntelos.net ([216.12.86.13]:36389 "EHLO
	brightrain.aerifal.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939AbbAJBe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 20:34:26 -0500
Date: Fri, 9 Jan 2015 20:33:24 -0500
From: Rich Felker <dalias@aerifal.cx>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, David Drysdale <drysdale@google.com>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Meredydd Luff <meredydd@senatehouse.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>,
        X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>, sparclinux@vger.kernel.org
Subject: Re: [PATCHv10 man-pages 5/5] execveat.2: initial man page for
 execveat(2)
Message-ID: <20150110013324.GB4574@brightrain.aerifal.cx>
References: <20150109161302.GQ4574@brightrain.aerifal.cx>
 <CAHse=S88Jy5ZKM_VY5onfvxX7dTMngnxuHfuLeSuzvKvQNP19A@mail.gmail.com>
 <20150109204815.GR4574@brightrain.aerifal.cx>
 <20150109205626.GK22149@ZenIV.linux.org.uk>
 <20150109205926.GT4574@brightrain.aerifal.cx>
 <20150109210941.GL22149@ZenIV.linux.org.uk>
 <20150109212852.GU4574@brightrain.aerifal.cx>
 <87lhlbvbzs.fsf@x220.int.ebiederm.org>
 <20150109223843.GX4574@brightrain.aerifal.cx>
 <87mw5rtowa.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mw5rtowa.fsf@x220.int.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2015 at 07:17:41PM -0600, Eric W. Biederman wrote:
> Rich Felker <dalias@aerifal.cx> writes:
> 
> > I'm not proposing code because I'm a libc developer not a kernel
> > developer. I know what's needed for userspace to provide a conforming
> > fexecve to applications, not how to implement that on the kernel side,
> > although I'm trying to provide constructive ideas. The hostility is
> > really not necessary.
> 
> Conforming to what?
> 
> The open group fexecve says nothing about requiring a file descriptor
> passed to fexecve to have O_CLOEXEC.

It doesn't require it but it allows it, and in multithreaded programs
that might run child processes (or library code that might be used in
such situations), O_CLOEXEC is mandatory everywhere to avoid fd leaks.

> Further looking at open group specification of exec it seems to indicate
> the preferred way to handle this is for the kernel to return O_NOEXEC
> and then libc gets to figure out how to run the shell script.  Is that
> the kind of ``conforming'' implementation you are looking for?

This is a complex issue, and does not apply to native #! support
(which is a supported executable format and thus not ENOEXEC) but
rather standard POSIX shell scripts (which don't have a #! line at
all). In this case the behavior of fexecve is perhaps under-specified.
However, in cases where execve would succeed (without causing
ENOEXEC), I think it's at least undesirable, if not non-conforming,
for fexecve to fail.

Should we request clarification from the Austin Group?

Rich
