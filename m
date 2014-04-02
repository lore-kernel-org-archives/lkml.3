Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758881AbaDBX2n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 19:28:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51134 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758819AbaDBX2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 19:28:41 -0400
Date: Wed, 2 Apr 2014 16:28:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Mateusz Guzik <mguzik@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Kay Sievers <kay@vrfy.org>
Subject: Re: [RFC PATCH] cmdline: Hide "debug" from /proc/cmdline
Message-Id: <20140402162839.d3c00e9845e89d0f092c2ce3@linux-foundation.org>
In-Reply-To: <alpine.LRH.2.00.1404030119270.23421@twin.jikos.cz>
References: <20140402144219.4cafbe37@gandalf.local.home>
	<20140402221212.GD16570@mguzik.redhat.com>
	<CA+55aFyZSr4G2a1X5+EeSgKGtZvzBfBg0D0L39g-DB9TLi+ZEw@mail.gmail.com>
	<alpine.LRH.2.00.1404030119270.23421@twin.jikos.cz>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Apr 2014 01:23:15 +0200 (CEST) Jiri Kosina <jkosina@suse.cz> wrote:

> On Wed, 2 Apr 2014, Linus Torvalds wrote:
> 
> > Steven, Borislav, one thing that strikes me might be a good idea is to 
> > limit the amount of non-kernel noise in dmesg. We already have the 
> > concept of rate-limiting various spammy internal kernel messages for 
> > when device drivers misbehave etc. Maybe we can just add rate-limiting 
> > to the interfaces that add messages to the kernel buffers, and work 
> > around this problem that way instead while waiting for Gregs fix to 
> > percolate? Or are the systemd debug messages going to so many other 
> > places too that that wouldn't really help?
> 
> I think that it's in principle a good idea, however ... the in-kernel 
> ratelimiting always happens per sourcecode location, but this will be 
> rather hard to achieve with interface such as /dev/kmsg.
> 
> If /dev/kmsg is going to be ratelimited as a whole, it might potentially 
> create a severely unfair situation between individual userspace programs 
> trying to do logging (although there is apparently only one userspace 
> service doing any logging through this interface whatsoever, right?).

Could be done per-fd: put a struct ratelimit_state into struct
devkmsg_user.
