Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030714AbaDCBif (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 21:38:35 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:34998 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030465AbaDCBia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 21:38:30 -0400
Date: Wed, 2 Apr 2014 21:38:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jiri Kosina <jkosina@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Mateusz Guzik <mguzik@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Kay Sievers <kay@vrfy.org>
Subject: Re: [RFC PATCH] cmdline: Hide "debug" from /proc/cmdline
Message-ID: <20140402213827.33d73f36@gandalf.local.home>
In-Reply-To: <CA+55aFzo85-sdC_eDVRWcCdsK2p1JxCjswYidq-QSi5RieGmBA@mail.gmail.com>
References: <20140402144219.4cafbe37@gandalf.local.home>
	<20140402221212.GD16570@mguzik.redhat.com>
	<CA+55aFyZSr4G2a1X5+EeSgKGtZvzBfBg0D0L39g-DB9TLi+ZEw@mail.gmail.com>
	<alpine.LRH.2.00.1404030119270.23421@twin.jikos.cz>
	<20140402162839.d3c00e9845e89d0f092c2ce3@linux-foundation.org>
	<CA+55aFw7NyryF3F3x05rLjt6rFwD5xUoZB06CV2mpwwRxcVHxg@mail.gmail.com>
	<alpine.LNX.2.00.1404030145490.32122@pobox.suse.cz>
	<CA+55aFzo85-sdC_eDVRWcCdsK2p1JxCjswYidq-QSi5RieGmBA@mail.gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Apr 2014 16:52:59 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, Apr 2, 2014 at 4:47 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> >
> > Which doesn't really protect you from tasks that do open()/write()/close()
> > cycle for /dev/kmsg write every 2ms though.
> 
> I don't think we should try to protect against wilful bad behavior
> unless that is shown to be necessary. Yeah, if it turns out that
> systemd really does that just to mess with us, we'd need to extend it,
> but in the absence of proof to the contrary, maybe this simple
> attached patch works?

I wonder if we should also add a "ignore_devkmsg" that basically
turns writing into /dev/kmsg into /dev/null. That way, a simple "debug"
and "ignore_devkmsg" wont blow away the printk ring buffer from data you
want to look at on boot up.

-- Steve
