Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161057AbaDBWMw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 18:12:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51434 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030526AbaDBWMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 18:12:47 -0400
Date: Thu, 3 Apr 2014 00:12:13 +0200
From: Mateusz Guzik <mguzik@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Kay Sievers <kay@vrfy.org>
Subject: Re: [RFC PATCH] cmdline: Hide "debug" from /proc/cmdline
Message-ID: <20140402221212.GD16570@mguzik.redhat.com>
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

Well, parsing kernel cmdline by systemd is a bad idea, and hiding
"debug" is even worse. What will happen when the next keyword clashes?
And how should I check the kernel is booted with "debug"?

If there is a real need to pass arguments to systemd, how about a
dedicated option (initargs= or whatever, where it has to be last in
cmdline), then systemd would be spawned with these arguments and would
just go over its argv.

-- 
Mateusz Guzik
