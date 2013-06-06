Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594Ab3FFVFR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 17:05:17 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:47408 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294Ab3FFVFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 17:05:15 -0400
MIME-Version: 1.0
In-Reply-To: <1370542251-27387-1-git-send-email-betty.dall@hp.com>
References: <1370542251-27387-1-git-send-email-betty.dall@hp.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 6 Jun 2013 15:04:54 -0600
Message-ID: <CAErSpo7e5EN3bCFzFZvVe5pZ5tsDW+7CbLqhuPr_oNPy5ShWKg@mail.gmail.com>
Subject: Re: [PATCH v3 0/6] PCI/ACPI: Fix firmware first error recovery with
 root port in reset
To: Betty Dall <betty.dall@hp.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Chen Gong <gong.chen@linux.intel.com>,
        "Pearson, Greg" <greg.pearson@hp.com>,
        Huang Ying <ying.huang@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 6, 2013 at 12:10 PM, Betty Dall <betty.dall@hp.com> wrote:
> This patch set fixes a bug on platforms that use firmware first AER.
> Firmware can leave the root port in Secondary Bus Reset (SBR) and
> communicate this to the OS through the "reset" bit in the flags field
> of the HEST table and associated CPER records. Firmware wants to do this
> so that the error is contained and the hardware is in a known state.
>
> Without these patches, the root port stays in SBR and the device drivers
> cannot recover. These patches recognize when the firmware first root port
> is in SBR and bring the root port out of SBR so the devices under the root
> port can recover.
>
> The changes have been tested on systems with firmware first that set the
> "reset" bit by injecting various hardware errors. The errors successfully
> recover.
>
> Changes since v1:
> Fixed a typo in the comment of patch 2.
> Removed incorrect setting of reset bit in patch 3.
>
> Changes since v2:
> The v2 patch 1/3 was re-written by Bjorn Helgaas and is now patches 1/6
> through 3/6.
> The v2 patch 2/3 is now 5/6 and changed to directly use the AER_FATAL define
> and introduced patch 4/6 to move the defines to a public header file.
> The v2 patch 3/3 is now 6/6 and uses the same default reset link function for
> both Downstream Ports and Root Ports.
>
> Signed-off-by: Betty Dall <betty.dall@hp.com>
> ---
> Betty Dall (6):
>   PCI/AER: Don't parse HEST table for non-PCIe devices
>   PCI/AER: Factor out HEST device type matching
>   PCI/AER: Set dev->__aer_firmware_first only for matching devices
>   PCI/ACPI: Move AER severity defines to aer.h
>   ACPI/APEI: Force fatal AER severity when bus has been reset
>   PCI/AER: Provide reset_link for firmware first root port
> ---
>  drivers/acpi/apei/ghes.c           |   10 +++++++
>  drivers/pci/pcie/aer/aerdrv.h      |    4 ---
>  drivers/pci/pcie/aer/aerdrv_acpi.c |   47 ++++++++++++++++++-----------------
>  drivers/pci/pcie/aer/aerdrv_core.c |   17 +++++++------
>  include/linux/aer.h                |   16 +++++++----
>  5 files changed, 53 insertions(+), 41 deletions(-)

I put these on http://git.kernel.org/cgit/linux/kernel/git/helgaas/pci.git/log/?h=pci/betty-aer-v3

I'll merge them into -next for v3.11 soon.  Thanks, Betty!
