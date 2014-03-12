Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730AbaCLXtP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 19:49:15 -0400
Received: from www.linutronix.de ([62.245.132.108]:46574 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbaCLXtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 19:49:12 -0400
Date: Thu, 13 Mar 2014 00:49:07 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
cc: joeyli <jlee@suse.com>, Julian Wollrath <jwollrath@web.de>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RESEND] Fast TSC calibration fails with v3.14-rc1 and later
In-Reply-To: <1554867.utJVyPuT6A@vostro.rjw.lan>
Message-ID: <alpine.DEB.2.02.1403130045050.18573@ionos.tec.linutronix.de>
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
> I agree, and we need to fix that for 3.14.  Patch is appended.

You beat me by a few minutes. Was about to send out the same, just
with a more spicy changelog :)

> ---
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Subject: ACPI / init: Invoke early ACPI initialization later
> 
> Commit 73f7d1ca3263 (ACPI / init: Run acpi_early_init() before
> timekeeping_init()) optimistically moved the early ACPI initialization
> before timekeeping_init(), but that didn't work, because it broke fast
> TSC calibration for Julian Wollrath on Thinkpad x121e (and most likely
> for others too).  The reason is that acpi_early_init() enables the SCI
> and that interferes with the fast TSC calibration mechanism.
> 
> Thus follow the original idea to execute acpi_early_init() before
> efi_enter_virtual_mode() to help the EFI people for now and we can
> revisit the other problem that commit 73f7d1ca3263 attempted to
> address in the future (if really necessary).

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
 
