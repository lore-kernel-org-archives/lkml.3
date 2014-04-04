Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbaDDSVo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 14:21:44 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:60822 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722AbaDDSVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 14:21:42 -0400
Message-ID: <533EF832.1030902@mit.edu>
Date: Fri, 04 Apr 2014 11:21:38 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, Joerg Roedel <joro@8bytes.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mateusz Guzik <mguzik@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Kay Sievers <kay@vrfy.org>
Subject: Re: [RFC PATCH] cmdline: Hide "debug" from /proc/cmdline
References: <20140402144219.4cafbe37@gandalf.local.home> <20140402221212.GD16570@mguzik.redhat.com> <CA+55aFyZSr4G2a1X5+EeSgKGtZvzBfBg0D0L39g-DB9TLi+ZEw@mail.gmail.com> <alpine.LRH.2.00.1404030119270.23421@twin.jikos.cz> <20140402162839.d3c00e9845e89d0f092c2ce3@linux-foundation.org> <CA+55aFw7NyryF3F3x05rLjt6rFwD5xUoZB06CV2mpwwRxcVHxg@mail.gmail.com> <alpine.LNX.2.00.1404030145490.32122@pobox.suse.cz> <CA+55aFzo85-sdC_eDVRWcCdsK2p1JxCjswYidq-QSi5RieGmBA@mail.gmail.com> <CA+55aFyphF8kd4OwWdar4p5M1=Sxc54sfk0RWFPpO6zrezZwJA@mail.gmail.com> <20140403104308.GP13491@8bytes.org> <20140403170541.GA19010@thunk.org>
In-Reply-To: <20140403170541.GA19010@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2014 10:05 AM, Theodore Ts'o wrote:
> On Thu, Apr 03, 2014 at 12:43:08PM +0200, Joerg Roedel wrote:
>>
>> How about just ignoring writes to /dev/kmsg altogether by default
>> (unless explicitly enabled in Kconfig or on the kernel cmdline)? Maybe I
>> am missing something but what are the legitimate use-cases for generally
>> allowing user-space to write into the kernel-log?
> 
> I'll give you one example which where /dev/kmesg is useful --- if you
> are running automated kernel tests, echoing "running test shared/127"
> .... several minutes later .... "running test shared/128", is very
> useful since if the kernel starts spewing warnings, or even
> oops/panics/livelocks, you know what test was running at the time of
> the failure.

I'm using /dev/kmsg in virtme so that I can easily capture, with
timestamps, the ten or so log lines that it produces.  It would be sad
if I had to worry about small ratelimits here.

/dev/kmsg is genuinely useful for the case where an initramfs wants to
log something (preferably only a little bit) and doesn't want to invent
a whole protocol for passing logging data through to the final logging
system.

The other thing I've used /dev/kmsg for is to shove a "I'm starting
something now" message in.  This is only really necessary because the
current kernel log timestamps are unusable crap.  (We could fix that,
hint hint.)

--Andy
