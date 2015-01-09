Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758173AbbAIU4h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 15:56:37 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:60611 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbbAIU4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 15:56:35 -0500
Date: Fri, 9 Jan 2015 20:56:26 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Rich Felker <dalias@aerifal.cx>
Cc: David Drysdale <drysdale@google.com>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
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
Message-ID: <20150109205626.GK22149@ZenIV.linux.org.uk>
References: <1416830039-21952-1-git-send-email-drysdale@google.com>
 <1416830039-21952-6-git-send-email-drysdale@google.com>
 <54AFF813.7050604@gmail.com>
 <20150109161302.GQ4574@brightrain.aerifal.cx>
 <CAHse=S88Jy5ZKM_VY5onfvxX7dTMngnxuHfuLeSuzvKvQNP19A@mail.gmail.com>
 <20150109204815.GR4574@brightrain.aerifal.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150109204815.GR4574@brightrain.aerifal.cx>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2015 at 03:48:15PM -0500, Rich Felker wrote:
> I think this is a case that needs to be fixed, though it's hard. The
> normal correct usage for fexecve is to always pass an O_CLOEXEC file
> descriptor, and the caller can't really be expected to know whether
> the file is a script or not. We discussed workarounds before and one
> idea I proposed was having fexecve provide a "one open only" magic
> symlink in /proc/self/ to pass to the interpreter. It would behave
> like an O_PATH file descriptor magic symlink in /proc/self/fd, but
> would automatically cease to exist on the first open (at which point
> the interpreter would have a real O_RDONLY file descriptor for the
> underlying file).

For fsck sake, folks, if you have bloody /proc, you don't need that shite
at all!  Just do execve on /proc/self/fd/n, and be done with that.

The sole excuse for merging that thing in the first place had been
"would anybody think of children^Wsclerotic^Whardened environments
where they have no /proc at all".

Sheesh...
