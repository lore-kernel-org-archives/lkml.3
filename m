Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751583Ab3JZKGe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 06:06:34 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:42435 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab3JZKGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 06:06:33 -0400
Date: Sat, 26 Oct 2013 12:06:30 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [GIT PULLv2] For x86/mce ... enhanced error logs
Message-ID: <20131026100630.GA14949@gmail.com>
References: <5266bc543597964da@agluck-desk.sc.intel.com>
 <52680aa01445165d7@agluck-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52680aa01445165d7@agluck-desk.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Luck, Tony <tony.luck@intel.com> wrote:

> Replacement for yesterday's pull request - fixes a build bug when CONFIG_SMP=n
> found by Fengguang's zero-day auto-build robot army.  If you pulled (and pushed)
> that one before finding this in your mailbox - then I can send the one-line
> patch to be applied on top of yesterday's version.
> 
> -Tony
> 
> The following changes since commit 31d141e3a666269a3b6fcccddb0351caf7454240:
> 
>   Linux 3.12-rc6 (2013-10-19 12:28:15 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git tags/please-pull-eMCA-fix
> 
> for you to fetch changes up to 0f6d98727f0eea8cdeea4a3eacff266cad7dc764:
> 
>   UEFI, CPER: Move cper.c to a more proper place (2013-10-23 10:11:08 -0700)
> 
> ----------------------------------------------------------------
> There is a enhanced error logging mechanism for Xeon processors.
> Full description is here:
> http://www.intel.com/content/www/us/en/architecture-and-technology/enhanced-mca-logging-xeon-paper.html
> This patch series provides a module (and support code) to
> check for an extended error log and print extra details about
> the error on the console.
> 
> ----------------------------------------------------------------
> Chen, Gong (10):
>       ACPI, APEI, CPER: Fix status check during error printing
>       ACPI, CPER: Update cper info
>       bitops: Introduce a more generic BITMASK macro
>       ACPI, x86: Extended error log driver for x86 platform
>       DMI: Parse memory device (type 17) in SMBIOS
>       ACPI, APEI, CPER: Add UEFI 2.4 support for memory error
>       ACPI, APEI, CPER: Enhance memory reporting capability
>       ACPI, APEI, CPER: Cleanup CPER memory error output format
>       EDAC, GHES: Update ghes error record info
>       UEFI, CPER: Move cper.c to a more proper place
> 
>  arch/ia64/kernel/setup.c              |   1 +
>  arch/x86/include/asm/mce.h            |   1 +
>  arch/x86/kernel/cpu/mcheck/mce-apei.c |   3 +-
>  arch/x86/kernel/setup.c               |   1 +
>  drivers/acpi/Kconfig                  |  20 +++
>  drivers/acpi/Makefile                 |   2 +
>  drivers/acpi/acpi_extlog.c            | 327 ++++++++++++++++++++++++++++++++++
>  drivers/acpi/apei/Kconfig             |   1 +
>  drivers/acpi/apei/Makefile            |   2 +-
>  drivers/acpi/apei/apei-internal.h     |  12 +-
>  drivers/acpi/apei/ghes.c              |  58 +++---
>  drivers/acpi/bus.c                    |   3 +-
>  drivers/edac/amd64_edac.c             |  46 ++---
>  drivers/edac/amd64_edac.h             |   8 -
>  drivers/edac/ghes_edac.c              |  16 +-
>  drivers/edac/sb_edac.c                |   2 +-
>  drivers/firmware/dmi_scan.c           |  60 +++++++
>  drivers/video/sis/init.c              |   5 +-
>  include/acpi/actbl1.h                 |  14 +-
>  include/acpi/ghes.h                   |   2 +-
>  include/linux/acpi.h                  |   1 +
>  include/linux/bitops.h                |   8 +
>  include/linux/cper.h                  |  13 +-
>  include/linux/dmi.h                   |   5 +
>  include/linux/edac.h                  |   2 +-
>  lib/Kconfig                           |   4 +
>  lib/Makefile                          |   1 +
>  {drivers/acpi/apei => lib}/cper.c     | 132 +++++++-------
>  28 files changed, 600 insertions(+), 150 deletions(-)
>  create mode 100644 drivers/acpi/acpi_extlog.c
>  rename {drivers/acpi/apei => lib}/cper.c (76%)

Pulled, thanks Tony!

	Ingo
