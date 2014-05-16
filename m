Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208AbaEPLtw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 07:49:52 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:53785 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754246AbaEPLtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 07:49:50 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Lv Zheng <lv.zheng@intel.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Lv Zheng <zetalog@gmail.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v3 0/4] ACPICA: Cleanups for <acpi/platform/acenv.h> and <acpi/platform/aclinux.h>.
Date: Fri, 16 May 2014 14:06:39 +0200
Message-ID: <2469705.A2qBHcTP2j@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <cover.1399880022.git.lv.zheng@intel.com>
References: <cover.1396930406.git.lv.zheng@intel.com> <cover.1399880022.git.lv.zheng@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 12, 2014 03:44:37 PM Lv Zheng wrote:
> This patch series cleans up <acpi/platform/acenv.h> and
> <acpi/platform/aclinux.h>.  it also fixes some mis-ordered inclusions for
> Linux resident ACPICA.
> 
> There is no real issue in the Linux kernel, but this can help to cleanup
> the code so that (benefits):
> 1. Redundant environment definitions can be removed from <asm/acpi.h> and
>    <acpi/platform/aclinux.h>.
> 2. Lift a burden off the ACPICA release automation - copying default ACPICA
>    environment setting to all <asm/acpi.h> file each time a new environment
>    is introduced just in order to avoid build errors.
> 3. The wrong <acpi/actypes.h> inclusion can be removed from
>    <acpi/platform/aclinux.h>.
> 4. Using ACPICA defined types in <asm/acpi.h> is possible.
> 5. Using "static inline" to define ACPICA OSL functions is still possible
>    and won't cause build errors any longer.
> 6. All non back ported prototypes are collected in a single file.
> 
> The patch set has passed the following build/boot tests.
> Build tests are performed as follows:
> 1. i386 + default + COFNIG_ACPI=y
> 2. i386 + default + COFNIG_ACPI=n
> 3. x86_64 + default + COFNIG_ACPI=y
> 4. x86_64 + default + COFNIG_ACPI=n
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
>    All ACPI drivers
>    4 DRM drivers that implement ACPI opregion
>    All buses with ACPI bindings
>    All cpufreq configurations
>    All xen configurations
>    All ACPI table drivers
> 
> Lv Zheng (4):
>   ACPICA: Linux headers: Remove ACPI_PREEMPTION_POINT() due to no
>     usages.
>   ACPICA: Linux headers: Add <acpi/platform/aclinuxex.h> to remove
>     mis-ordered inclusion of <acpi/actypes.h> from
>     <acpi/platform/aclinux.h>.
>   ACPICA: Linux headers: Add <asm/acenv.h> to remove mis-ordered
>     inclusion of <asm/acpi.h> from <acpi/platform/aclinux.h>.
>   ACPICA: Cleanup redudant definitions that already have defaults in
>     <acpi/platform/acenv.h>.
> 
>  arch/ia64/include/asm/acenv.h     |   56 ++++++++++++
>  arch/ia64/include/asm/acpi.h      |   50 -----------
>  arch/x86/include/asm/acenv.h      |   49 +++++++++++
>  arch/x86/include/asm/acpi.h       |   45 ----------
>  include/acpi/acpi.h               |    4 +-
>  include/acpi/platform/acenvex.h   |   63 ++++++++++++++
>  include/acpi/platform/aclinux.h   |  171 ++++++++-----------------------------
>  include/acpi/platform/aclinuxex.h |  116 +++++++++++++++++++++++++
>  8 files changed, 322 insertions(+), 232 deletions(-)
>  create mode 100644 arch/ia64/include/asm/acenv.h
>  create mode 100644 arch/x86/include/asm/acenv.h
>  create mode 100644 include/acpi/platform/acenvex.h
>  create mode 100644 include/acpi/platform/aclinuxex.h

All four applied to bleeding-edge, thanks Lv!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
