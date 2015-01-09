Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbbAIW5y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 17:57:54 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:33095 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378AbbAIW5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 17:57:50 -0500
Date: Fri, 9 Jan 2015 22:57:43 +0000
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
Message-ID: <20150109225743.GP22149@ZenIV.linux.org.uk>
References: <CAHse=S88Jy5ZKM_VY5onfvxX7dTMngnxuHfuLeSuzvKvQNP19A@mail.gmail.com>
 <20150109204815.GR4574@brightrain.aerifal.cx>
 <20150109205626.GK22149@ZenIV.linux.org.uk>
 <20150109205926.GT4574@brightrain.aerifal.cx>
 <20150109210941.GL22149@ZenIV.linux.org.uk>
 <20150109212852.GU4574@brightrain.aerifal.cx>
 <20150109215042.GM22149@ZenIV.linux.org.uk>
 <20150109221728.GW4574@brightrain.aerifal.cx>
 <20150109223300.GO22149@ZenIV.linux.org.uk>
 <20150109224252.GY4574@brightrain.aerifal.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150109224252.GY4574@brightrain.aerifal.cx>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2015 at 05:42:52PM -0500, Rich Felker wrote:

> Here's a very simple way it could work -- it could put the O_PATH fd
> on a previously-unused fd number, and put a special flag on the fd,
> like FD_CLOEXEC, but that causes the kernel to close it whenever it's
> opened. The pathname passed could then simply be /dev/fd/%d or
> /proc/self/fd/%d, and although this is presently dependent on /proc
> being mounted, virtual /dev/fd/* could someday be something completely
> independent of procfs. The kernel keeps all the freedom to choose how
> to pass the name to the interpreter. I'm not proposing any kernel
> API/ABI lock-in and I'm with you in opposing such lock-in.

Huh?  open() on procfs symlinks does *NOT* work the way - the symlink is
traversed and after that point there is no information whatsoever how we
got to that vfsmount/dentry pair.  I can imagine several kludges that would
work, but they are unspeakably ugly, and do_last() is already far too
convoluted as it is.
