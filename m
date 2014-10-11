Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050AbaJKQdt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 12:33:49 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:44151 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbaJKQds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 12:33:48 -0400
From: Mikael Pettersson <mikpelinux@gmail.com>
X-Google-Original-From: "Mikael Pettersson" <mikpe@cascade>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <21561.23527.405747.338285@gargle.gargle.HOWL>
Date: Sat, 11 Oct 2014 18:33:43 +0200
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, Rabin Vincent <rabin@rab.in>
Subject: Re: [PATCH] arm: Blacklist gcc 4.8.[012] and 4.9.0 with CONFIG_FRAME_POINTER
In-Reply-To: <54380F86.10005@hurleysoftware.com>
References: <1412958374-16090-1-git-send-email-peter@hurleysoftware.com>
	<20141010163613.GO5182@n2100.arm.linux.org.uk>
	<54380F86.10005@hurleysoftware.com>
X-Mailer: VM 8.1.2 under 24.3.1 (x86_64-redhat-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Hurley writes:
 > On 10/10/2014 12:36 PM, Russell King - ARM Linux wrote:
 > > On Fri, Oct 10, 2014 at 12:26:14PM -0400, Peter Hurley wrote:
 > >> gcc versions 4.8.[012] and 4.9.0 generates code that prematurely
 > >> adjusts the stack pointer such that still-to-be-referenced locals
 > >> are below the stack pointer, which allows them to be overwritten
 > >> by interrupts.
 > > 
 > > I would much rather do this in asm-offsets.c, along side the other ARM
 > > specific buggy compiler test(s).  I'm presently putting together such
 > > a patch.
 > > 
 > > The information in the thread on linux-omap says only GCC 4.8.1 and
 > > GCC 4.8.2.  Where do you get the other versions from?
 > 
 > The gcc PR linked in the commit message; see the "Known to fail" field.

The 4.8.0 release is broken, but the 4.9.0 one is not.  It's unfortunate,
but "4.9.0" may refer to "the 4.9.0 release" or to "some point after trunk
forked 4.8 branch up to and including the 4.9.0 release point".  In this
case, it's the latter -- this can be inferred from the fact that the
fix went into trunk in October 2013 while 4.9.0 was branched and released
during the first half of 2014.
