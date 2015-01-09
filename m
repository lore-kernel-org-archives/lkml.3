Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890AbbAIUtJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 15:49:09 -0500
Received: from 216-12-86-13.cv.mvl.ntelos.net ([216.12.86.13]:36226 "EHLO
	brightrain.aerifal.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbbAIUtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 15:49:05 -0500
Date: Fri, 9 Jan 2015 15:48:15 -0500
From: Rich Felker <dalias@aerifal.cx>
To: David Drysdale <drysdale@google.com>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
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
Message-ID: <20150109204815.GR4574@brightrain.aerifal.cx>
References: <1416830039-21952-1-git-send-email-drysdale@google.com>
 <1416830039-21952-6-git-send-email-drysdale@google.com>
 <54AFF813.7050604@gmail.com>
 <20150109161302.GQ4574@brightrain.aerifal.cx>
 <CAHse=S88Jy5ZKM_VY5onfvxX7dTMngnxuHfuLeSuzvKvQNP19A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHse=S88Jy5ZKM_VY5onfvxX7dTMngnxuHfuLeSuzvKvQNP19A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2015 at 05:46:28PM +0000, David Drysdale wrote:
> > It's AT_EXECFN,
> > /proc/self/exe, and filenames shown elsewhere in /proc that may be
> > derived in odd ways.
> >
> > I would also move the text about O_CLOEXEC to a BUGS or NOTES section
> > rather than the main description. The long-term intent should be that
> > script execution this way should work. IIRC this was discussed earlier
> > in the thread.
> 
> I may be misremembering, but I thought we hoped to be able to fix
> execveat of a script without /proc in future, but didn't expect to fix
> execveat of a script via an O_CLOEXEC fd (because in the latter
> case the fd gets closed before the script interpreter runs, so even
> if the interpreter (or a special filesystem) does clever things for names
> starting with "/dev/fd/..." the file descriptor is already gone).

I think this is a case that needs to be fixed, though it's hard. The
normal correct usage for fexecve is to always pass an O_CLOEXEC file
descriptor, and the caller can't really be expected to know whether
the file is a script or not. We discussed workarounds before and one
idea I proposed was having fexecve provide a "one open only" magic
symlink in /proc/self/ to pass to the interpreter. It would behave
like an O_PATH file descriptor magic symlink in /proc/self/fd, but
would automatically cease to exist on the first open (at which point
the interpreter would have a real O_RDONLY file descriptor for the
underlying file).

Rich
