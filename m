Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632AbaDDS55 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 14:57:57 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:54083 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754249AbaDDS5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 14:57:55 -0400
MIME-Version: 1.0
In-Reply-To: <20140404115139.3ea3d53126094f41bc0579a0@linux-foundation.org>
References: <20140402144219.4cafbe37@gandalf.local.home>
	<20140402221212.GD16570@mguzik.redhat.com>
	<CA+55aFyZSr4G2a1X5+EeSgKGtZvzBfBg0D0L39g-DB9TLi+ZEw@mail.gmail.com>
	<alpine.LRH.2.00.1404030119270.23421@twin.jikos.cz>
	<20140402162839.d3c00e9845e89d0f092c2ce3@linux-foundation.org>
	<CA+55aFw7NyryF3F3x05rLjt6rFwD5xUoZB06CV2mpwwRxcVHxg@mail.gmail.com>
	<alpine.LNX.2.00.1404030145490.32122@pobox.suse.cz>
	<CA+55aFzo85-sdC_eDVRWcCdsK2p1JxCjswYidq-QSi5RieGmBA@mail.gmail.com>
	<CA+55aFyphF8kd4OwWdar4p5M1=Sxc54sfk0RWFPpO6zrezZwJA@mail.gmail.com>
	<20140403104308.GP13491@8bytes.org>
	<20140403170541.GA19010@thunk.org>
	<533EF832.1030902@mit.edu>
	<CA+55aFz=rnGo_DvtYa4aonm_JUyWe5cynLcsCYDfr+jMZ91+Sg@mail.gmail.com>
	<20140404115139.3ea3d53126094f41bc0579a0@linux-foundation.org>
Date: Fri, 4 Apr 2014 11:57:53 -0700
X-Google-Sender-Auth: N0-j-KPTCdkNAR0HMRlkv4s2F_4
Message-ID: <CA+55aFwz8xxW9zHFnjWBGUwAiwU0GpLS=j1Qj8ZN_cg3vDWjaQ@mail.gmail.com>
Subject: Re: [RFC PATCH] cmdline: Hide "debug" from /proc/cmdline
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>, "Theodore Ts'o" <tytso@mit.edu>,
        Joerg Roedel <joro@8bytes.org>, Jiri Kosina <jkosina@suse.cz>,
        Mateusz Guzik <mguzik@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Kay Sievers <kay@vrfy.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 4, 2014 at 11:51 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> Is there anything here that we really need to fix?  What goes wrong if
> we leave kmsg as-is and systemd gets fixed?

Since I haven't even heard a "my bad" from the systemd people, I'd be
inclined to say that a bit of protection for future issues would be a
good idea.

But I'm not going to force the issue if people think it's solvable.
That said, the fact that we rate limit even our own sources does tend
to argue that "once bitten, twice shy" is the right approach. It
didn't take a lot of spammy device drivers overwriting out message
logs to make us go "let's rate limit device output".

             Linus
