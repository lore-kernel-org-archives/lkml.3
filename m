Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262AbaCLX6J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 19:58:09 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:57026 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751162AbaCLX6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 19:58:07 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: joeyli <jlee@suse.com>, Julian Wollrath <jwollrath@web.de>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RESEND] Fast TSC calibration fails with v3.14-rc1 and later
Date: Thu, 13 Mar 2014 01:13:27 +0100
Message-ID: <4475332.ToUgLzVgqU@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc6+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <alpine.DEB.2.02.1403130045050.18573@ionos.tec.linutronix.de>
References: <20140310110410.5b2218f6@ilfaris> <1554867.utJVyPuT6A@vostro.rjw.lan> <alpine.DEB.2.02.1403130045050.18573@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, March 13, 2014 12:49:07 AM Thomas Gleixner wrote:
> On Thu, 13 Mar 2014, Rafael J. Wysocki wrote:
> > I agree, and we need to fix that for 3.14.  Patch is appended.
> 
> You beat me by a few minutes. Was about to send out the same, just
> with a more spicy changelog :)
> 
> > ---
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > Subject: ACPI / init: Invoke early ACPI initialization later
> > 
> > Commit 73f7d1ca3263 (ACPI / init: Run acpi_early_init() before
> > timekeeping_init()) optimistically moved the early ACPI initialization
> > before timekeeping_init(), but that didn't work, because it broke fast
> > TSC calibration for Julian Wollrath on Thinkpad x121e (and most likely
> > for others too).  The reason is that acpi_early_init() enables the SCI
> > and that interferes with the fast TSC calibration mechanism.
> > 
> > Thus follow the original idea to execute acpi_early_init() before
> > efi_enter_virtual_mode() to help the EFI people for now and we can
> > revisit the other problem that commit 73f7d1ca3263 attempted to
> > address in the future (if really necessary).
> 
> Reviewed-by: Thomas Gleixner <tglx@linutronix.de>

Thanks!

I have a plan to push this to Linus for -rc7.

Rafael

