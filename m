Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161151AbaDBXX1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 19:23:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52457 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161055AbaDBXXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 19:23:23 -0400
Date: Thu, 3 Apr 2014 01:23:15 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Mateusz Guzik <mguzik@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Kay Sievers <kay@vrfy.org>
Subject: Re: [RFC PATCH] cmdline: Hide "debug" from /proc/cmdline
In-Reply-To: <CA+55aFyZSr4G2a1X5+EeSgKGtZvzBfBg0D0L39g-DB9TLi+ZEw@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.1404030119270.23421@twin.jikos.cz>
References: <20140402144219.4cafbe37@gandalf.local.home> <20140402221212.GD16570@mguzik.redhat.com> <CA+55aFyZSr4G2a1X5+EeSgKGtZvzBfBg0D0L39g-DB9TLi+ZEw@mail.gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Apr 2014, Linus Torvalds wrote:

> Steven, Borislav, one thing that strikes me might be a good idea is to 
> limit the amount of non-kernel noise in dmesg. We already have the 
> concept of rate-limiting various spammy internal kernel messages for 
> when device drivers misbehave etc. Maybe we can just add rate-limiting 
> to the interfaces that add messages to the kernel buffers, and work 
> around this problem that way instead while waiting for Gregs fix to 
> percolate? Or are the systemd debug messages going to so many other 
> places too that that wouldn't really help?

I think that it's in principle a good idea, however ... the in-kernel 
ratelimiting always happens per sourcecode location, but this will be 
rather hard to achieve with interface such as /dev/kmsg.

If /dev/kmsg is going to be ratelimited as a whole, it might potentially 
create a severely unfair situation between individual userspace programs 
trying to do logging (although there is apparently only one userspace 
service doing any logging through this interface whatsoever, right?).

-- 
Jiri Kosina
SUSE Labs

