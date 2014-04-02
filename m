Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932991AbaDBTJJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 15:09:09 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58287 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932696AbaDBTJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 15:09:06 -0400
Date: Wed, 2 Apr 2014 21:08:51 +0200
From: Borislav Petkov <bp@alien8.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Kay Sievers <kay@vrfy.org>
Subject: Re: [RFC PATCH] cmdline: Hide "debug" from /proc/cmdline
Message-ID: <20140402190851.GD21167@pd.tnic>
References: <20140402144219.4cafbe37@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140402144219.4cafbe37@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2014 at 02:42:19PM -0400, Steven Rostedt wrote:
> It has come to our attention that a system running a specific user
> space init program will not boot if you add "debug" to the kernel
> command line. What happens is that the user space tool parses the
> kernel command line, and if it sees "debug" it will spit out so much
> information that the system fails to boot. This basically renders the
> "debug" option for the kernel useless.
> 
> This bug has been reported to the developers of said tool
> here:
> 
>   https://bugs.freedesktop.org/show_bug.cgi?id=76935
> 
> The response is:
> 
> "Generic terms are generic, not the first user owns them."
> 
> That is, the "debug" statement on the *kernel* command line is not
> owned by the kernel just because it was the first user of it, and
> they refuse to fix their bug.
> 
> Well, my response is, we OWN the kernel command line, and as such, we
> can keep the users from seeing stuff on it if we so choose. And with
> that, I propose this patch, which hides "debug" from /proc/cmdline,
> such that we don't have to worry about tools parsing for it and causing
> hardship for those trying to debug the kernel.
> 
> Reported-by: Borislav Petkov <bp@alien8.de>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Well, maybe the minor nit that it leaves two spaces in /proc/cmdline now:

"root=/dev/sda1  ignore_loglevel log_buf_len=10M earlyprintk=ttyS0,115200 console=ttyS0,115200 console=tty0"

Also, you need to add

Suggested-by: PeterZ.

Other than that:

Vehemently-and-totally-acked-by: Borislav Petkov <bp@suse.de>

It is about time this idiotic shit stopped.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
