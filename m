Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab3AUWtL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 17:49:11 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51712 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab3AUWtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 17:49:09 -0500
Date: Mon, 21 Jan 2013 22:49:00 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: John Stultz <john.stultz@linaro.org>
Cc: Matt Sealey <matt@genesi-usa.com>, Arnd Bergmann <arnd@arndb.de>,
        Linux ARM Kernel ML <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: One of these things (CONFIG_HZ) is not like the others..
Message-ID: <20130121224900.GB23505@n2100.arm.linux.org.uk>
References: <CAKGA1bkiowcO7OPSfPmaB6eRj_3FNr+4ONnaQHEZkpxB2XfduQ@mail.gmail.com> <201301212041.17951.arnd@arndb.de> <50FDAC5F.4040605@linaro.org> <CAKGA1b=D5CNikijoOAk5xP6TC-nB_gEGtS05ncrPR68sQTMrxw@mail.gmail.com> <50FDC2DD.7090406@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50FDC2DD.7090406@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 02:36:13PM -0800, John Stultz wrote:
> Well, Russell brought up a case that doesn't handle this. If a system  
> *can't* do HZ=100, but can do HZ=200.
>
> Though there are hacks, of course, that might get around this (skip  
> every other interrupt at 200HZ).

Note: in the early days of EBSA110 support, yes, we did that, so that
we could have HZ=100 everywhere.  _However_ it sufficiently peturbed
NTP that it basically was unable to slew the clock in any sane manner.
I never got to the bottom of why that was, and when USER_HZ was
decoupled from the kernel HZ, it allowed the problem to be fixed, and
the kernel code to become a _lot_ cleaner.
