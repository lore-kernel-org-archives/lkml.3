Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879AbaCMAyp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 20:54:45 -0400
Received: from www.linutronix.de ([62.245.132.108]:46732 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963AbaCMAyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 20:54:44 -0400
Date: Thu, 13 Mar 2014 01:54:47 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
cc: joeyli <jlee@suse.com>, Julian Wollrath <jwollrath@web.de>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, John Stultz <john.stultz@linaro.org>,
        "Ted Ts'o" <tytso@mit.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RESEND] Fast TSC calibration fails with v3.14-rc1 and later
In-Reply-To: <1554867.utJVyPuT6A@vostro.rjw.lan>
Message-ID: <alpine.DEB.2.02.1403130049500.18573@ionos.tec.linutronix.de>
References: <20140310110410.5b2218f6@ilfaris> <alpine.DEB.2.02.1403121722030.18573@ionos.tec.linutronix.de> <alpine.DEB.2.02.1403121729060.18573@ionos.tec.linutronix.de> <1554867.utJVyPuT6A@vostro.rjw.lan>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2014, Rafael J. Wysocki wrote:
> Thus follow the original idea to execute acpi_early_init() before
> efi_enter_virtual_mode() to help the EFI people for now and we can
> revisit the other problem that commit 73f7d1ca3263 attempted to
> address in the future (if really necessary).

It's not necessary at all. In fact we really want to get rid of the
arch specific cmos stuff which is an historical leftover.

I talked to John Stultz earlier today and he agrees that there are
only a few trivial things to add to the RTC subsystem to make this
work.

>From the timekeeping POV there is absolutely no need to set the wall
clock time early. The kernel boot phase does not care about wall time
at all. We should have it done before we hit userspace, but not even
that is a hard requirement.

That TAD/EFI time mess is not going to happen before that is solved.

Thanks,

	tglx
