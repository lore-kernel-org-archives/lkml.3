Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932815AbaDBXbl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 19:31:41 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:58823 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932480AbaDBXbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 19:31:39 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.00.1404030119270.23421@twin.jikos.cz>
References: <20140402144219.4cafbe37@gandalf.local.home>
	<20140402221212.GD16570@mguzik.redhat.com>
	<CA+55aFyZSr4G2a1X5+EeSgKGtZvzBfBg0D0L39g-DB9TLi+ZEw@mail.gmail.com>
	<alpine.LRH.2.00.1404030119270.23421@twin.jikos.cz>
Date: Wed, 2 Apr 2014 16:31:38 -0700
X-Google-Sender-Auth: PVh4LWe0w40TVYEnspjqBgwPYY0
Message-ID: <CA+55aFx6pcztotjqoFgu2aP3arKy1ft6q1Z1Cs4Kf409RWaXYw@mail.gmail.com>
Subject: Re: [RFC PATCH] cmdline: Hide "debug" from /proc/cmdline
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Mateusz Guzik <mguzik@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Kay Sievers <kay@vrfy.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 2, 2014 at 4:23 PM, Jiri Kosina <jkosina@suse.cz> wrote:
>
> I think that it's in principle a good idea, however ... the in-kernel
> ratelimiting always happens per sourcecode location, but this will be
> rather hard to achieve with interface such as /dev/kmsg.
>
> If /dev/kmsg is going to be ratelimited as a whole, it might potentially
> create a severely unfair situation between individual userspace programs
> trying to do logging (although there is apparently only one userspace
> service doing any logging through this interface whatsoever, right?).

So I think we could/should make the rate limiting of kmsg be tied to
perhaps 'struct cred' and then just use current_cred()->rs. Or perhaps
even make it per-task.

It wouldn't be hard to just embed one "struct ratelimit_state" into
the appropriate struct. They're not *that* huge.

              Linus
