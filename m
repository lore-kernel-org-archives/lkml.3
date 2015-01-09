Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932544AbbAIQXA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 11:23:00 -0500
Received: from 216-12-86-13.cv.mvl.ntelos.net ([216.12.86.13]:36216 "EHLO
	brightrain.aerifal.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232AbbAIQWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 11:22:54 -0500
X-Greylist: delayed 520 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Jan 2015 11:22:52 EST
Date: Fri, 9 Jan 2015 11:13:03 -0500
From: Rich Felker <dalias@aerifal.cx>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: David Drysdale <drysdale@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Meredydd Luff <meredydd@senatehouse.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>,
        x86@kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org,
        sparclinux@vger.kernel.org
Subject: Re: [PATCHv10 man-pages 5/5] execveat.2: initial man page for
 execveat(2)
Message-ID: <20150109161302.GQ4574@brightrain.aerifal.cx>
References: <1416830039-21952-1-git-send-email-drysdale@google.com>
 <1416830039-21952-6-git-send-email-drysdale@google.com>
 <54AFF813.7050604@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54AFF813.7050604@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2015 at 04:47:31PM +0100, Michael Kerrisk (man-pages) wrote:
> On 11/24/2014 12:53 PM, David Drysdale wrote:
> > Signed-off-by: David Drysdale <drysdale@google.com>
> > ---
> >  man2/execveat.2 | 153 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 153 insertions(+)
> >  create mode 100644 man2/execveat.2
> 
> David,
> 
> Thanks for the very nicely prepared man page. I've done 
> a few very light edits, and will release the version below 
> with the next man-pages release.
> 
> I have one question. In the message accompanying
> commit 51f39a1f0cea1cacf8c787f652f26dfee9611874 you wrote:
> 
>   The filename fed to the executed program as argv[0] (or the name of the
>   script fed to a script interpreter) will be of the form "/dev/fd/<fd>"
>   (for an empty filename) or "/dev/fd/<fd>/<filename>", effectively
>   reflecting how the executable was found.  This does however mean that
>   execution of a script in a /proc-less environment won't work; also, script
>   execution via an O_CLOEXEC file descriptor fails (as the file will not be
>   accessible after exec).
> 
> How does one produce this situation where the execed program sees 
> argv[0] as a /dev/fd path? (i.e., what would the execveat()
> call look like?) I tried to produce this scenario, but could not.

I think this is wrong. argv[0] is an arbitrary string provided by the
caller and would never be derived from the fd passed. It's AT_EXECFN,
/proc/self/exe, and filenames shown elsewhere in /proc that may be
derived in odd ways.

I would also move the text about O_CLOEXEC to a BUGS or NOTES section
rather than the main description. The long-term intent should be that
script execution this way should work. IIRC this was discussed earlier
in the thread.

Rich
