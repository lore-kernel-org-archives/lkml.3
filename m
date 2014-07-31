Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826AbaGaWN7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 18:13:59 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:49392 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752522AbaGaWN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 18:13:57 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Lv Zheng <lv.zheng@intel.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Lv Zheng <zetalog@gmail.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 00/17] ACPICA: 20140724 Release
Date: Fri, 01 Aug 2014 00:32:32 +0200
Message-ID: <1460406.cfFWs4Kn6j@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <cover.1406689493.git.lv.zheng@intel.com>
References: <cover.1406689493.git.lv.zheng@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 30, 2014 12:20:20 PM Lv Zheng wrote:
> The 20140724 ACPICA kernel-resident subsystem updates are linuxized based
> on the pm/linux-next branch to form this patchset.
> 
> The patchset has passed the following build/boot tests.
> Build tests are performed as follows:
> 1. i386 + default + COFNIG_ACPI=y
> 2. i386 + allyes + CONFIG_ACPI=y
> 3. i386 + default + COFNIG_ACPI=n
> 4. i386 + allyes + CONFIG_ACPI=n
> 5. x86_64 + default + COFNIG_ACPI=y
> 6. x86_64 + allyes + CONFIG_ACPI=y
> 7. x86_64 + default + COFNIG_ACPI=n
> 8. x86_64 + allyes + CONFIG_ACPI=n
> Boot tests are performed as follows:
> 1. i386 + default + COFNIG_ACPI=y
> 2. x86_64 + default + COFNIG_ACPI=y
> Where:
> 1. i386: machine named as "Dell Inspiron Mini 1010"
> 2. x86_64: machine named as "HP Compaq 8200 Elite SFF PC"
> 3. default: kernel configuration with following items enabled:
>    All hardware drivers related to the machines of i386/x86_64
>    All drivers/acpi configurations
>    All platform drivers
> 
> The divergences checking result:
> Before applying:
>   861 lines
> After applying:
>   848 lines
> 
> Bob Moore (11):
>   ACPICA: Work around an ancient GCC bug.
>   ACPICA: Remove a redundant cast to acpi_size for ACPI_OFFSET() macro.
>   ACPICA: Disassembler: Add support for the ToUUID opererator (macro).
>   ACPICA: Update for comments/formatting. No functional changes.
>   ACPICA: Tables: Update for DMAR table changes.
>   ACPICA: acpihelp: Add UUID support, restructure some existing files.
>   ACPICA: Debug object: Add current value of Timer() to debug line
>     prefix.
>   ACPICA: ACPI 5.1: New notify value for System Affinity Update.
>   ACPICA: ACPI 5.1: Support for the _CCA predifined name.
>   ACPICA: ACPI 5.1: Update for PCCT table changes.
>   ACPICA: Update version to 20140724.
> 
> David E. Box (1):
>   ACPICA: ACPI 5.1: Support for the _DSD predefined name.
> 
> Graeme Gregory (1):
>   ACPICA/ARM: ACPI 5.1: Update for FADT changes.
> 
> Lv Zheng (1):
>   ACPICA: Utilities: Fix local printf issue.
> 
> Sascha Wildner (1):
>   ACPICA: Remove some extraneous printf arguments.
> 
> Tomasz Nowicki (2):
>   ACPICA/ARM: ACPI 5.1: Update for MADT changes.
>   ACPICA/ARM: ACPI 5.1: Update for GTDT table changes.
> 
>  drivers/acpi/acpica/Makefile   |    8 ++-
>  drivers/acpi/acpica/aclocal.h  |   18 ++++--
>  drivers/acpi/acpica/acpredef.h |   16 +++++-
>  drivers/acpi/acpica/acutils.h  |    9 +++
>  drivers/acpi/acpica/exdebug.c  |   11 +++-
>  drivers/acpi/acpica/exdump.c   |    6 +-
>  drivers/acpi/acpica/exfield.c  |   22 ++++----
>  drivers/acpi/acpica/utdecode.c |   32 +----------
>  drivers/acpi/acpica/utfileio.c |    3 +-
>  drivers/acpi/acpica/uthex.c    |  100 ++++++++++++++++++++++++++++++++++
>  drivers/acpi/acpica/utprint.c  |    9 ++-
>  drivers/acpi/acpica/utuuid.c   |   96 ++++++++++++++++++++++++++++++++
>  drivers/iommu/dmar.c           |   28 +++++-----
>  include/acpi/acconfig.h        |   18 ++++++
>  include/acpi/acnames.h         |    1 +
>  include/acpi/acpixf.h          |    2 +-
>  include/acpi/actbl.h           |   12 +++-
>  include/acpi/actbl1.h          |   44 ++++++++++++++-
>  include/acpi/actbl2.h          |   14 ++---
>  include/acpi/actbl3.h          |  118 ++++++++++++++++++++++++++++++++++------
>  include/acpi/actypes.h         |    5 +-
>  21 files changed, 468 insertions(+), 104 deletions(-)
>  create mode 100644 drivers/acpi/acpica/uthex.c
>  create mode 100644 drivers/acpi/acpica/utuuid.c

Whole series applied, thanks Lv!

Rafael

