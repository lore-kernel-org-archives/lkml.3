Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976AbaDCRKz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 13:10:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38031 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300AbaDCRKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 13:10:52 -0400
Message-ID: <533D95C9.1020601@zytor.com>
Date: Thu, 03 Apr 2014 10:09:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
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
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
        Ingo Molnar <mingo@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Kay Sievers <kay@vrfy.org>
Subject: Re: [RFC PATCH] cmdline: Hide "debug" from /proc/cmdline
References: <20140402144219.4cafbe37@gandalf.local.home> <20140402221212.GD16570@mguzik.redhat.com> <CA+55aFyZSr4G2a1X5+EeSgKGtZvzBfBg0D0L39g-DB9TLi+ZEw@mail.gmail.com> <alpine.LRH.2.00.1404030119270.23421@twin.jikos.cz> <20140402162839.d3c00e9845e89d0f092c2ce3@linux-foundation.org> <CA+55aFw7NyryF3F3x05rLjt6rFwD5xUoZB06CV2mpwwRxcVHxg@mail.gmail.com> <alpine.LNX.2.00.1404030145490.32122@pobox.suse.cz> <CA+55aFzo85-sdC_eDVRWcCdsK2p1JxCjswYidq-QSi5RieGmBA@mail.gmail.com> <CA+55aFyphF8kd4OwWdar4p5M1=Sxc54sfk0RWFPpO6zrezZwJA@mail.gmail.com> <20140403104308.GP13491@8bytes.org> <20140403170541.GA19010@thunk.org>
In-Reply-To: <20140403170541.GA19010@thunk.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2014 10:05 AM, Theodore Ts'o wrote:
> 
> So there are so many other ways of solving this problem without trying
> to abuse the kernel logging facilities (which were never intended to
> be a general-purpose syslog replacement).  I suspect some systemd
> developer was being lazy....
> 

Having the kernel be the keeper of the logging IPC isn't at all
unreasonable.  However, kmsg in its current form isn't adequate.
Augmenting it into a proper logging IPC might be the right thing to do.
 (Hmm... new IPC... does this sound a bit like kdbus to anyone?)

The original motivation for /dev/kmsg was of course in the context of
klibc to maintain the current behavior of the items I was hoping to move
from kernel to user space.

	-hpa


