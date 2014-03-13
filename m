Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924AbaCMC5q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 22:57:46 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:43673 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbaCMC5p (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Wed, 12 Mar 2014 22:57:45 -0400
Subject: Re: [RESEND] Fast TSC calibration fails with v3.14-rc1 and later
From: joeyli <jlee@suse.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Julian Wollrath <jwollrath@web.de>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <alpine.DEB.2.02.1403130045050.18573@ionos.tec.linutronix.de>
References: <20140310110410.5b2218f6@ilfaris>
	 <alpine.DEB.2.02.1403121722030.18573@ionos.tec.linutronix.de>
	 <alpine.DEB.2.02.1403121729060.18573@ionos.tec.linutronix.de>
	 <1554867.utJVyPuT6A@vostro.rjw.lan>
	 <alpine.DEB.2.02.1403130045050.18573@ionos.tec.linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 Mar 2014 10:56:56 +0800
Message-ID: <1394679416.26565.220.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 四，2014-03-13 於 00:49 +0100，Thomas Gleixner 提到：
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
>  
> 

Acked-by: Lee, Chun-Yi <jlee@suse.com>

Thanks a lot!
Joey Lee

