Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933680AbaDCAtc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 20:49:32 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:28921 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933655AbaDCAta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 20:49:30 -0400
Date: Wed, 2 Apr 2014 20:49:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Mateusz Guzik <mguzik@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Kay Sievers <kay@vrfy.org>
Subject: Re: [RFC PATCH] cmdline: Hide "debug" from /proc/cmdline
Message-ID: <20140402204927.22dedef3@gandalf.local.home>
In-Reply-To: <20140402221212.GD16570@mguzik.redhat.com>
References: <20140402144219.4cafbe37@gandalf.local.home>
	<20140402221212.GD16570@mguzik.redhat.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Apr 2014 00:12:13 +0200
Mateusz Guzik <mguzik@redhat.com> wrote:

 
> Well, parsing kernel cmdline by systemd is a bad idea, and hiding
> "debug" is even worse. What will happen when the next keyword clashes?
> And how should I check the kernel is booted with "debug"?

No, I think you got it backwards. Hiding "debug" is a bad idea, having
systemd abuse the hell out of it is even worse.


> 
> If there is a real need to pass arguments to systemd, how about a
> dedicated option (initargs= or whatever, where it has to be last in
> cmdline), then systemd would be spawned with these arguments and would
> just go over its argv.
> 

No, the correct solution was to have systemd use its own flag. Say
"systemd.debug", which I believe from froward reading my emails, Greg
has already sent a patch to do so.

That solution was even suggested in the BZ and was turned down with the
quote I had in my change log. That we don't own the generic terms, even
though it's our f*cking command line, not theirs!

-- Steve
