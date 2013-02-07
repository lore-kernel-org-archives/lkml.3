Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759287Ab3BGSTa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 13:19:30 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37653 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757017Ab3BGST2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 13:19:28 -0500
Date: Thu, 7 Feb 2013 18:13:15 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Kim Phillips <kim.phillips@freescale.com>
Cc: "Woodhouse, David" <david.woodhouse@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        David Rientjes <rientjes@google.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robherring2@gmail.com>
Subject: Re: [RFC] arm: use built-in byte swap function
Message-ID: <20130207181315.GM17833@n2100.arm.linux.org.uk>
References: <20130129181046.GC25415@pd.tnic> <1359541333.3529.186.camel@shinybook.infradead.org> <20130130200900.9d7cf7908caeaef4ecee1d61@freescale.com> <20130131092801.GV23505@n2100.arm.linux.org.uk> <20130131145947.f62474a0600848df86548b96@freescale.com> <20130201011712.GF23505@n2100.arm.linux.org.uk> <1359703995.23531.6.camel@shinybook.infradead.org> <20130205210436.670c62e26d2121330e87af35@freescale.com> <1360141322.6066.4.camel@shinybook.infradead.org> <20130206191905.ac8eb6743e69425f30888704@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130206191905.ac8eb6743e69425f30888704@freescale.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2013 at 07:19:05PM -0600, Kim Phillips wrote:
> either that, or link with libgcc - why does arch/arm64 do this and
> arch/arm not?  It's not obvious from git log.

We want to be in control of what code the kernel runs, and that means
not using libgcc.  libgcc can do all sorts of stuff because it makes
assumptions about the environment which it is executing in (glibc).

For example, it assumes there may be a GOT, and that it can issue SWI
calls...

However, the biggest reason not to use libgcc is that we want to control
what gets used in the kernel - for example, no floating point, and no
use of 64 x 64bit division.

So all round, using libgcc in AArch32 would bring us a number of issues
that we don't get with the current approach.

AArch64 uses it because it's maintained entirely separately and the
decision has been made by other people - and some of these concerns do
not exist on a 64-bit architecture.
