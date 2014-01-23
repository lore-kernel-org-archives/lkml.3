Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332AbaAWJjZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 04:39:25 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40885 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbaAWJjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 04:39:22 -0500
Date: Thu, 23 Jan 2014 10:39:21 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Cong Ding <dinggnu@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@kernel.org>, Kees Cook <keescook@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mathias Krause <minipli@googlemail.com>,
        Michael Davidson <md@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: Re: [GIT PULL] x86/kaslr for v3.14
Message-ID: <20140123093921.GA1998@amd.pavel.ucw.cz>
References: <201401201647.s0KGlZdh004167@tazenda.hos.anvin.org>
 <CA+55aFyxisSNKstMuanfrkhu5=2bxcu2cxZxMg38Zw0HAoXppg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyxisSNKstMuanfrkhu5=2bxcu2cxZxMg38Zw0HAoXppg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2014-01-20 14:54:12, Linus Torvalds wrote:
> So I pulled this, but one question:
> 
> On Mon, Jan 20, 2014 at 8:47 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> > +config RANDOMIZE_BASE
> > +       bool "Randomize the address of the kernel image"
> > +       depends on RELOCATABLE
> > +       depends on !HIBERNATION
> 
> How fundamental is that "!HIBERNATION" issue? Right now that
> anti-dependency on hibernation support will mean that no distro kernel
> will actually use the kernel address space randomization. Which
> long-term is a problem.

Hibernation does some interesting tricks, and it did depend on image
layout staying same.

Rafael did some great work on x86-64 to enable resuming different
kernel version, so this should no longer be a problem (on
x86-64). Just test it, failure will not be subtle.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
