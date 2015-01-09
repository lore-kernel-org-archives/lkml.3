Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163AbbAIVJs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 16:09:48 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:60693 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbbAIVJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 16:09:46 -0500
Date: Fri, 9 Jan 2015 21:09:41 +0000
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
Message-ID: <20150109210941.GL22149@ZenIV.linux.org.uk>
References: <1416830039-21952-1-git-send-email-drysdale@google.com>
 <1416830039-21952-6-git-send-email-drysdale@google.com>
 <54AFF813.7050604@gmail.com>
 <20150109161302.GQ4574@brightrain.aerifal.cx>
 <CAHse=S88Jy5ZKM_VY5onfvxX7dTMngnxuHfuLeSuzvKvQNP19A@mail.gmail.com>
 <20150109204815.GR4574@brightrain.aerifal.cx>
 <20150109205626.GK22149@ZenIV.linux.org.uk>
 <20150109205926.GT4574@brightrain.aerifal.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150109205926.GT4574@brightrain.aerifal.cx>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2015 at 03:59:26PM -0500, Rich Felker wrote:

> > For fsck sake, folks, if you have bloody /proc, you don't need that shite
> > at all!  Just do execve on /proc/self/fd/n, and be done with that.
> > 
> > The sole excuse for merging that thing in the first place had been
> > "would anybody think of children^Wsclerotic^Whardened environments
> > where they have no /proc at all".
> 
> That doesn't work. With O_CLOEXEC, /proc/self/fd/n is already gone at
> the time the interpreter runs, whether you're using fexecveat or
> execve with "/proc/self/fd/n" to implement POSIX fexecve(). That's the
> problem. This breaks the intended idiom for fexecve.

Just what will your magical symlink do in case when the file is opened,
unlinked and marked O_CLOEXEC?  When should actual freeing of disk blocks,
etc. happen?  And no, you can't assume that interpreter will open the
damn thing even once - there's nothing to oblige it to do so.

Al, more and more tempted to ask reverting the whole thing - this hardcoded
/dev/fd/... (in fs/exec.c, no less) is disgraceful enough, but threats of
even more revolting kludges in the name of "intended idiom for fexecve"...
