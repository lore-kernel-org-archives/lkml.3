Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990Ab3AWHw0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 02:52:26 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:49884 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753685Ab3AWHwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 02:52:24 -0500
Message-ID: <1358927532.2496.24.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [PATCH 1/2] efi: Make 'efi_enabled' a function to query EFI
 facilities
From: Matt Fleming <matt@console-pimps.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, Tim Gardner <rtg.canonical@gmail.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Olof Johansson <olof@lixom.net>,
        Tony Luck <tony.luck@intel.com>,
        Steve Langasek <steve.langasek@canonical.com>,
        Colin Ian King <colin.king@canonical.com>,
        David Airlie <airlied@linux.ie>,
        Corentin Chary <corentincj@iksaif.net>,
        Dave Jiang <dave.jiang@intel.com>, Peter Jones <pjones@redhat.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, stable@vger.kernel.org
Date: Wed, 23 Jan 2013 07:52:12 +0000
In-Reply-To: <1358914581.3151.6.camel@deadeye.wl.decadent.org.uk>
References: <1358800838-10459-1-git-send-email-matt@console-pimps.org>
	 <1358800838-10459-2-git-send-email-matt@console-pimps.org>
	 <50FDA81B.9090602@zytor.com>
	 <1358802778.2496.11.camel@mfleming-mobl1.ger.corp.intel.com>
	 <1358914581.3151.6.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-23 at 04:16 +0000, Ben Hutchings wrote:
> On Mon, 2013-01-21 at 21:12 +0000, Matt Fleming wrote:
> [...]
> > From 92e73f936e40a8c6562e47425d434a4e62d2b8e2 Mon Sep 17 00:00:00 2001
> > From: Matt Fleming <matt.fleming@intel.com>
> > Date: Wed, 14 Nov 2012 09:42:35 +0000
> > Subject: [PATCH] efi: Make 'efi_enabled' a function to query EFI facilities
> > 
> > Originally 'efi_enabled' indicated whether a kernel was booted from
> > EFI firmware. Over time its semantics have changed, and it now
> > indicates whether or not we are booted on an EFI machine with
> > bit-native firmware, e.g. 64-bit kernel with 64-bit firmware.
> > 
> > The immediate motivation for this patch is the bug report at,
> > 
> >     https://bugs.launchpad.net/ubuntu-cdimage/+bug/1040557
> > 
> > which details how running a platform driver on an EFI machine that is
> > designed to run under BIOS can cause the machine to become
> > bricked. Also, the following report,
> > 
> >     https://bugzilla.kernel.org/show_bug.cgi?id=47121
> > 
> > details how running said driver can also cause Machine Check
> > Exceptions. Drivers need a new means of detecting whether they're
> > running on an EFI machine, as sadly the expression,
> > 
> >     if (!efi_enabled)
> > 
> > hasn't been a sufficient condition for quite some time.
> [...]
> 
> This patch maps the old efi_enabled flag to efi_enabled(EFI_BOOT).  Your
> second patch adds a test for efi_enabled(EFI_BOOT) to the samsung-laptop
> driver.  So the samsung-laptop driver could be fixed by adding a check
> for the old flag; it doesn't depend on the addition of new flags at all.
> The changes elsewhere may well be important, but the cited motivation
> here just doesn't make sense.

If we instead check for the old flag then the samsung-laptop driver
would run if booting a 32-bit kernel with 64-bit EFI firmware, or vice
versa, because efi_enabled == 0 in that case.

It's not sufficient to just check the old flag, the samsung-laptop
driver really can't be allowed to run at all if booting from EFI, and
the old flag doesn't provide us with that guarantee.

-- 
Matt Fleming, Intel Open Source Technology Center

