Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514AbaDDWs4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 18:48:56 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:52421 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199AbaDDWsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 18:48:54 -0400
MIME-Version: 1.0
In-Reply-To: <CAADnVQ+TZzmSpXcL7YTNGauWs4dYmNyS=sNYCYGAJbim04w9hA@mail.gmail.com>
References: <CA+55aFw7NyryF3F3x05rLjt6rFwD5xUoZB06CV2mpwwRxcVHxg@mail.gmail.com>
	<alpine.LNX.2.00.1404030145490.32122@pobox.suse.cz>
	<CA+55aFzo85-sdC_eDVRWcCdsK2p1JxCjswYidq-QSi5RieGmBA@mail.gmail.com>
	<CA+55aFyphF8kd4OwWdar4p5M1=Sxc54sfk0RWFPpO6zrezZwJA@mail.gmail.com>
	<20140403104308.GP13491@8bytes.org>
	<20140403170541.GA19010@thunk.org>
	<533EF832.1030902@mit.edu>
	<CA+55aFz=rnGo_DvtYa4aonm_JUyWe5cynLcsCYDfr+jMZ91+Sg@mail.gmail.com>
	<20140404115139.3ea3d53126094f41bc0579a0@linux-foundation.org>
	<20140404154426.6f099f7d@gandalf.local.home>
	<20140404201750.GA10275@thunk.org>
	<CAADnVQ+TZzmSpXcL7YTNGauWs4dYmNyS=sNYCYGAJbim04w9hA@mail.gmail.com>
Date: Fri, 4 Apr 2014 15:48:53 -0700
X-Google-Sender-Auth: D-Q1T-d7LI4gQp6g8kQw-zQMYGo
Message-ID: <CA+55aFzM9Q9Lnxa+SjqfB6XzHJv-sHHqQBYzR6pCcMA6Jbxz5A@mail.gmail.com>
Subject: Re: [RFC PATCH] cmdline: Hide "debug" from /proc/cmdline
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>, Joerg Roedel <joro@8bytes.org>,
        Jiri Kosina <jkosina@suse.cz>, Mateusz Guzik <mguzik@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Kay Sievers <kay@vrfy.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 4, 2014 at 3:45 PM, Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> can there be two bulletproof buffers: one for in kernel printk
> and another ratelimited one for writes into /dev/kmsg.
> On the read from /dev/kmsg they're combined by time.

Or, you know, people could just stop spamming /dev/kmsg.

Let's not overdesign this. No sane use will be impacted by rate
limiting, and insane uses aren't something we should design for. Even
the systemd spam was a *bug*, for chrissake.

             Linus
