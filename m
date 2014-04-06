Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431AbaDFUtg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 16:49:36 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:46790 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbaDFUtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 16:49:33 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwz8xxW9zHFnjWBGUwAiwU0GpLS=j1Qj8ZN_cg3vDWjaQ@mail.gmail.com>
References: <20140402144219.4cafbe37@gandalf.local.home> <20140402221212.GD16570@mguzik.redhat.com>
 <CA+55aFyZSr4G2a1X5+EeSgKGtZvzBfBg0D0L39g-DB9TLi+ZEw@mail.gmail.com>
 <alpine.LRH.2.00.1404030119270.23421@twin.jikos.cz> <20140402162839.d3c00e9845e89d0f092c2ce3@linux-foundation.org>
 <CA+55aFw7NyryF3F3x05rLjt6rFwD5xUoZB06CV2mpwwRxcVHxg@mail.gmail.com>
 <alpine.LNX.2.00.1404030145490.32122@pobox.suse.cz> <CA+55aFzo85-sdC_eDVRWcCdsK2p1JxCjswYidq-QSi5RieGmBA@mail.gmail.com>
 <CA+55aFyphF8kd4OwWdar4p5M1=Sxc54sfk0RWFPpO6zrezZwJA@mail.gmail.com>
 <20140403104308.GP13491@8bytes.org> <20140403170541.GA19010@thunk.org>
 <533EF832.1030902@mit.edu> <CA+55aFz=rnGo_DvtYa4aonm_JUyWe5cynLcsCYDfr+jMZ91+Sg@mail.gmail.com>
 <20140404115139.3ea3d53126094f41bc0579a0@linux-foundation.org> <CA+55aFwz8xxW9zHFnjWBGUwAiwU0GpLS=j1Qj8ZN_cg3vDWjaQ@mail.gmail.com>
From: David Timothy Strauss <david@davidstrauss.net>
Date: Sun, 6 Apr 2014 13:49:11 -0700
Message-ID: <CAKz8sYX9YjCNNSGZSjoEiBTgPoCC0c3_5CfDPZyV66ZGpYcpUA@mail.gmail.com>
Subject: Re: [RFC PATCH] cmdline: Hide "debug" from /proc/cmdline
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>, "Theodore Ts'o" <tytso@mit.edu>,
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

On Fri, Apr 4, 2014 at 11:57 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> Since I haven't even heard a "my bad" from the systemd people, I'd be
> inclined to say that a bit of protection for future issues would be a
> good idea.

Just coming back to this thread now, I'll say something. I'm a systemd
maintainer, and I'm sorry systemd's assertion bug, combined with
aliasing the debug option with the kernel's, broke a bunch of
workflows (including boot) and caused a bunch of unnecessary pain.

As a few other people have already said, this assertion should now be
fixed. The question is now about the debug option, and I've given my
+1 to Greg's patch for that. I think it's justified to put a condom on
systemd's debug mode given how badly the assertion bug cascaded into
affecting non-systemd work.

Long-term, it would be nice to find a way to satisfy both the "admin
who's just trying to find what's broken case" without harming the
kernel developer case. Maybe distros could ship a "debug everything"
boot option that independently enables it for the kernel, systemd, and
possibly other tools. But, that's out of scope for LKML. I'll look
into that as part of Fedora's Server Working Group assuming we
namespace to systemd.debug. We're already shipping a "recovery" boot
option.
