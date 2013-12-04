Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137Ab3LDWyf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 17:54:35 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:54451 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756111Ab3LDWyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 17:54:33 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Aaron Lu <aaron.lu@intel.com>
Cc: Zhang Rui <rui.zhang@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lan Tianyu <tianyu.lan@intel.com>,
        Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 0/4] Convert ACPI fan driver to platform driver
Date: Thu, 05 Dec 2013 00:07:31 +0100
Message-ID: <1654759.afJtadVnDQ@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1386059312-2990-1-git-send-email-aaron.lu@intel.com>
References: <1386059312-2990-1-git-send-email-aaron.lu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 03, 2013 04:28:28 PM Aaron Lu wrote:
> This patchset converts ACPI fan driver to platform driver. Patch 1-3 are
> cleanups for existing fan driver and patch 4 does the convertion.
> 
> Tested on harris beach.
> Apply on top of Rafael's linux-next branch.
> 
> Aaron Lu (4):
>   ACPI / fan: remove unused macro for debug
>   ACPI / fan: remove no need check for device pointer
>   ACPI / fan: use acpi_device_xxx_power instead of acpi_bus equivelant
>   ACPI / fan: convert to platform driver
> 
>  drivers/acpi/acpi_platform.c |  3 ++
>  drivers/acpi/device_pm.c     |  1 +
>  drivers/acpi/fan.c           | 88 ++++++++++++++++----------------------------
>  drivers/acpi/internal.h      |  2 -
>  include/acpi/acpi_bus.h      |  1 +
>  5 files changed, 36 insertions(+), 59 deletions(-)

Unfortunately, we need to postpone these conversions, because Matthew Garrett
has problems with adding more entries to acpi_platform_device_ids[].  He seems
to be concerned that that list will grow indefinitely and will become difficult
to maintain eventually.

For this reason, he would prefer it if we did the following:
- Figure out the list of ACPI device IDs we need to create PNP devices for
  via ACPI PNP.
- Make ACPI PNP create PNP devices for these IDs only and make the ACPI core create
  platform devices for all "unassigned" ACPI device objects by default.
- Do the conversions at that point.

I'm slightly worried that we'll encounter ordering issues while doing that, but
this is the only way forward I can see without going straight against the
Matthew's objections, which I'd prefer to avoid.

Thanks,
Rafael

