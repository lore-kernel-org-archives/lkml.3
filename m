Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933439AbaDBWen (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 18:34:43 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:58097 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933158AbaDBWem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 18:34:42 -0400
X-Sasl-enc: O9kWR84LRvqsWjUKqtVmr0FaaoAa/lCZRioUEE+ojKRU 1396478080
Date: Wed, 2 Apr 2014 15:37:02 -0700
From: Greg KH <greg@kroah.com>
To: Mateusz Guzik <mguzik@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Kay Sievers <kay@vrfy.org>
Subject: Re: [RFC PATCH] cmdline: Hide "debug" from /proc/cmdline
Message-ID: <20140402223702.GA32068@kroah.com>
References: <20140402144219.4cafbe37@gandalf.local.home>
 <20140402221212.GD16570@mguzik.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140402221212.GD16570@mguzik.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2014 at 12:12:13AM +0200, Mateusz Guzik wrote:
> On Wed, Apr 02, 2014 at 02:42:19PM -0400, Steven Rostedt wrote:
> > It has come to our attention that a system running a specific user
> > space init program will not boot if you add "debug" to the kernel
> > command line. What happens is that the user space tool parses the
> > kernel command line, and if it sees "debug" it will spit out so much
> > information that the system fails to boot. This basically renders the
> > "debug" option for the kernel useless.
> > 
> > This bug has been reported to the developers of said tool
> > here:
> > 
> >   https://bugs.freedesktop.org/show_bug.cgi?id=76935
> > 
> > The response is:
> > 
> > "Generic terms are generic, not the first user owns them."
> > 
> > That is, the "debug" statement on the *kernel* command line is not
> > owned by the kernel just because it was the first user of it, and
> > they refuse to fix their bug.
> > 
> > Well, my response is, we OWN the kernel command line, and as such, we
> > can keep the users from seeing stuff on it if we so choose. And with
> > that, I propose this patch, which hides "debug" from /proc/cmdline,
> > such that we don't have to worry about tools parsing for it and causing
> > hardship for those trying to debug the kernel.
> > 
> 
> Well, parsing kernel cmdline by systemd is a bad idea, and hiding
> "debug" is even worse. What will happen when the next keyword clashes?
> And how should I check the kernel is booted with "debug"?
> 
> If there is a real need to pass arguments to systemd, how about a
> dedicated option (initargs= or whatever, where it has to be last in
> cmdline), then systemd would be spawned with these arguments and would
> just go over its argv.

Right now it looks like systemd relies on everything with a "systemd."
namespace on the command line, with the exception of "quiet" and
"debug".  I've just submitted a patch to systemd to fix up "debug", and
odds are, "quiet" should be switched as well, but unless anyone runs
into a problem with it, I'll leave that alone for now.

thanks,

greg k-h
