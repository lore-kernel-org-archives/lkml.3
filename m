Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbaDCT2v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 15:28:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39459 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752828AbaDCT2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 15:28:50 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20140403171854.GA23737@thunk.org>
References: <CA+55aFyZSr4G2a1X5+EeSgKGtZvzBfBg0D0L39g-DB9TLi+ZEw@mail.gmail.com> <alpine.LRH.2.00.1404030119270.23421@twin.jikos.cz> <20140402162839.d3c00e9845e89d0f092c2ce3@linux-foundation.org> <CA+55aFw7NyryF3F3x05rLjt6rFwD5xUoZB06CV2mpwwRxcVHxg@mail.gmail.com> <alpine.LNX.2.00.1404030145490.32122@pobox.suse.cz> <CA+55aFzo85-sdC_eDVRWcCdsK2p1JxCjswYidq-QSi5RieGmBA@mail.gmail.com> <CA+55aFyphF8kd4OwWdar4p5M1=Sxc54sfk0RWFPpO6zrezZwJA@mail.gmail.com> <20140403104308.GP13491@8bytes.org> <20140403170541.GA19010@thunk.org> <533D95C9.1020601@zytor.com> <20140403171854.GA23737@thunk.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [RFC PATCH] cmdline: Hide "debug" from /proc/cmdline
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 03 Apr 2014 12:19:12 -0700
To: "Theodore Ts'o" <tytso@mit.edu>
CC: Joerg Roedel <joro@8bytes.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mateusz Guzik <mguzik@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
        Ingo Molnar <mingo@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Kay Sievers <kay@vrfy.org>
Message-ID: <7048a27a-dcec-44e5-a51a-fe0a1f5d8542@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They will be in memory one way or another, and during boot memory is usually plentiful to the kernel.  Also, of the kernel knows it is log data it can be dropped if needed.

On April 3, 2014 10:18:55 AM PDT, Theodore Ts'o <tytso@mit.edu> wrote:
>On Thu, Apr 03, 2014 at 10:09:29AM -0700, H. Peter Anvin wrote:
>> 
>> Having the kernel be the keeper of the logging IPC isn't at all
>> unreasonable.  However, kmsg in its current form isn't adequate.
>> Augmenting it into a proper logging IPC might be the right thing to
>do.
>>  (Hmm... new IPC... does this sound a bit like kdbus to anyone?)
>
>I'm not sure it makes sense for the kernel to be stashing log entries
>until there is a good place to save them.  So if systemd wants to send
>hundreds of thousands of messages before the file system is remounted
>read-only, we don't really want to storing them in non-swappable
>kernel memory.  In a userspace process, you can do things like do
>compression, and in the worst case, the oom killer can kill the
>logging daemon if the systemd verbosity has been turned up too high,
>and it's taking too long to get /var/log mounted and writeable.
>
>That's why I wrote logsave(8) --- because IMHO, this is a userspace
>problem, and not something that we should even be trying to solve in
>kernel space.
>
>						- Ted

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
