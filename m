Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346AbaIEVYd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 17:24:33 -0400
Received: from www.linutronix.de ([62.245.132.108]:34631 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbaIEVYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 17:24:31 -0400
Date: Fri, 5 Sep 2014 23:24:25 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Paolo Bonzini <pbonzini@redhat.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gleb Natapov <gleb@kernel.org>, KVM list <kvm@vger.kernel.org>
Subject: Re: [GIT PULL] KVM changes for 3.17-rc4
In-Reply-To: <540A267E.1070002@redhat.com>
Message-ID: <alpine.DEB.2.10.1409052314330.5472@nanos>
References: <1409912186-22968-1-git-send-email-pbonzini@redhat.com> <CA+55aFxum+O9j4ohV=BwJR_+q+hMAZ2QLp0SpgZzYFWs9F=EUg@mail.gmail.com> <alpine.DEB.2.10.1409052254450.5472@nanos> <540A267E.1070002@redhat.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Sep 2014, Paolo Bonzini wrote:

> Il 05/09/2014 22:58, Thomas Gleixner ha scritto:
> > Nothing new there. Forgot to push out, or perhaps to use "-f" to
> > overwrite the previous tag of the same name?
> 
> It's there now.  Probably a --dry-run too much (I have
> push=+refs/tags/for-linus:refs/tags/for-linus in the remote configuration).
> 
> > And even if there would be something, please do not pull the top most
> > commit b11ba8c62be3eb (KVM: x86: fix kvmclock breakage from timers
> > branch merge).
> > 
> > That one is blantanly wrong and just hacks badly around a brown
> > paperbag bug in the core timekeeping code, which I introduced in the
> > last overhaul.
> 
> It's not wrong, it's just different.  The commit message says clearly

Right, it's different. Because you paper at the receiving end over a
core bug and that's wrong to begin with.

> that besides acting as a workaround, I find the patched code easier to
> understand, and I clearly stated the same in the tag message.

Well, we might have different opinions about easier to understand. I
did go a great length to distangle the monotonic boot time on which
you are interested from xtime, because the latter does not make any
sense outside of the core timekeeping code. Aside of that I optimized
the whole thing to avoid conversions, loops and hoops. So you just add
another multiply and add to make it more understandable. Sigh.

Thanks,

	tglx






