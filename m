Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737Ab3IPQa2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 12:30:28 -0400
Received: from science.horizon.com ([71.41.210.146]:65194 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751700Ab3IPQa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 12:30:27 -0400
Date: 16 Sep 2013 12:30:25 -0400
Message-ID: <20130916163025.15457.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: keescook@chromium.org, viro@ZenIV.linux.org.uk
Subject: Re: [PATCH 0/2] vsprintf: ignore %n again
Cc: akpm@linux-foundation.org, dan.carpenter@oracle.com, JBeulich@suse.com,
        joe@perches.com, kosaki.motohiro@gmail.com,
        linux-kernel@vger.kernel.org, linux@horizon.com,
        penguin-kernel@i-love.sakura.ne.jp
In-Reply-To: <20130916155504.GC13318@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is completely pointless.  *ANY* untrusted format string kernel-side
> is pretty much it.  Blocking %n is not "defense in depth", it's security
> theater.  Again, if attacker can feed an arbitrary format string to
> vsnprintf(), it's over - you've lost.  It's not just about information
> leaks vs. ability to store a value of attacker's choosing at the address
> of attacker's choosing as it was in userland.  Kernel-side an ability to
> trigger read from an arbitrary address is much nastier than information
> leak risk; consider iomem, for starters.

You've got to be kidding.  Yes, sometimes a read can have effects, but
such addresses are rare, not present in the main kernel memory mapping,
and you'd have to find a pointer to such an address (or a preceding
address with no nul bytes in between) on the stack at a known offset when
designing the printf string.  That's tricky, and not always possible.
Even for hardware devices, read side effects have gone out of style,
other than forcing PCI posted writes through.

And just because a hardware read has side effects doesn't mean it's
exploitable.  Being able to drop characters from a serial port is only
a DoS.

On the other hand, the ability to write an arbitrary, attacker-controlled
small integer to any address findable on the stack is very powerful and
easy to exploit.

Those two risks aren't remotely equivalent.
