Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbaDCPRk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 11:17:40 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:61968 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbaDCPRe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 11:17:34 -0400
MIME-Version: 1.0
In-Reply-To: <yw1x7g76k62z.fsf@unicorn.mansr.com>
References: <20140402144219.4cafbe37@gandalf.local.home>
	<20140402221212.GD16570@mguzik.redhat.com>
	<CA+55aFyZSr4G2a1X5+EeSgKGtZvzBfBg0D0L39g-DB9TLi+ZEw@mail.gmail.com>
	<alpine.LRH.2.00.1404030119270.23421@twin.jikos.cz>
	<yw1x7g76k62z.fsf@unicorn.mansr.com>
Date: Thu, 3 Apr 2014 08:17:33 -0700
Message-ID: <CA+bK7J57f8mHC0=UWrFG1MyyURb2hU6p2K1RTsHoWRNUz9LWLw@mail.gmail.com>
Subject: Re: [RFC PATCH] cmdline: Hide "debug" from /proc/cmdline
From: Tim Bird <tbird20d@gmail.com>
To: =?ISO-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Cc: Jiri Kosina <jkosina@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mateusz Guzik <mguzik@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Kay Sievers <kay@vrfy.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 3, 2014 at 4:25 AM, Måns Rullgård <mans@mansr.com> wrote:
> Jiri Kosina <jkosina@suse.cz> writes:
>
>> On Wed, 2 Apr 2014, Linus Torvalds wrote:
>>
>>> Steven, Borislav, one thing that strikes me might be a good idea is to
>>> limit the amount of non-kernel noise in dmesg. We already have the
>>> concept of rate-limiting various spammy internal kernel messages for
>>> when device drivers misbehave etc. Maybe we can just add rate-limiting
>>> to the interfaces that add messages to the kernel buffers, and work
>>> around this problem that way instead while waiting for Gregs fix to
>>> percolate? Or are the systemd debug messages going to so many other
>>> places too that that wouldn't really help?
>>
>> I think that it's in principle a good idea, however ... the in-kernel
>> ratelimiting always happens per sourcecode location, but this will be
>> rather hard to achieve with interface such as /dev/kmsg.
>>
>> If /dev/kmsg is going to be ratelimited as a whole, it might potentially
>> create a severely unfair situation between individual userspace programs
>> trying to do logging (although there is apparently only one userspace
>> service doing any logging through this interface whatsoever, right?).
>
> The point is that /dev/kmsg is *not* intended as a syslog replacement.

Agreed in general for many systems.  I'll just point out that for ultra-tiny
(i.e. embedded) systems, it's nice to only have one logging implementation
in the system.

I had no idea systemd was so verbose and was abusing the kernel
log buffers so badly.  I'm not a big fan of the rate-limiting, as this just
seems to encourage this kind of abuse.

 -- Tim Bird
