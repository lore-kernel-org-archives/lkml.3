Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959AbaDCLZq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 07:25:46 -0400
Received: from unicorn.mansr.com ([81.2.72.234]:51846 "EHLO unicorn.mansr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890AbaDCLZm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 07:25:42 -0400
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Mateusz Guzik <mguzik@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Kay Sievers <kay@vrfy.org>
Subject: Re: [RFC PATCH] cmdline: Hide "debug" from /proc/cmdline
References: <20140402144219.4cafbe37@gandalf.local.home>
	<20140402221212.GD16570@mguzik.redhat.com>
	<CA+55aFyZSr4G2a1X5+EeSgKGtZvzBfBg0D0L39g-DB9TLi+ZEw@mail.gmail.com>
	<alpine.LRH.2.00.1404030119270.23421@twin.jikos.cz>
Date: Thu, 03 Apr 2014 12:25:40 +0100
In-Reply-To: <alpine.LRH.2.00.1404030119270.23421@twin.jikos.cz> (Jiri
	Kosina's message of "Thu, 3 Apr 2014 01:23:15 +0200 (CEST)")
Message-ID: <yw1x7g76k62z.fsf@unicorn.mansr.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina <jkosina@suse.cz> writes:

> On Wed, 2 Apr 2014, Linus Torvalds wrote:
>
>> Steven, Borislav, one thing that strikes me might be a good idea is to 
>> limit the amount of non-kernel noise in dmesg. We already have the 
>> concept of rate-limiting various spammy internal kernel messages for 
>> when device drivers misbehave etc. Maybe we can just add rate-limiting 
>> to the interfaces that add messages to the kernel buffers, and work 
>> around this problem that way instead while waiting for Gregs fix to 
>> percolate? Or are the systemd debug messages going to so many other 
>> places too that that wouldn't really help?
>
> I think that it's in principle a good idea, however ... the in-kernel 
> ratelimiting always happens per sourcecode location, but this will be 
> rather hard to achieve with interface such as /dev/kmsg.
>
> If /dev/kmsg is going to be ratelimited as a whole, it might potentially 
> create a severely unfair situation between individual userspace programs 
> trying to do logging (although there is apparently only one userspace 
> service doing any logging through this interface whatsoever, right?).

The point is that /dev/kmsg is *not* intended as a syslog replacement.

-- 
Måns Rullgård
mans@mansr.com
