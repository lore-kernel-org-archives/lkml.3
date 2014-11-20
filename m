Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979AbaKTVK0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 16:10:26 -0500
Received: from mail-qg0-f43.google.com ([209.85.192.43]:51156 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757459AbaKTVKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 16:10:24 -0500
MIME-Version: 1.0
In-Reply-To: <20141120194422.GA6923@google.com>
References: <20141120194422.GA6923@google.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 20 Nov 2014 14:10:02 -0700
Message-ID: <CAErSpo4DfjCD_khfH67esMDxM0Ut3Sx_XVY5O10PkhxUW+NZ-w@mail.gmail.com>
Subject: Re: [GIT PULL] PCI fixes for v3.18
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, Lucas Stach <l.stach@pengutronix.de>,
        Duc Dang <dhdang@apm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc linux-pci, linux-kernel, Yinghai, Lucas, Duc]

On Thu, Nov 20, 2014 at 12:44 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> Hi Linus,
>
> These are fixes for an issue with 64-bit PCI bus addresses on 32-bit PAE
> kernels, an APM X-Gene problem (it depended on a generic change we removed
> before merging), a fix for my hotplug device configuration changes, and a
> devicetree documentation update.
>
> Bjorn
>
>
> The following changes since commit 32f638fc11db0526c706454d9ab4339d55ac89f3:
>
>   PCI: Don't oops on virtual buses in acpi_pci_get_bridge_handle() (2014-11-05 13:06:16 -0700)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git tags/pci-v3.18-fixes-3
>
> for you to fetch changes up to 7fc986d8a9727e5d40da3c2c1c343da6142e82a9:
>
>   PCI: Support 64-bit bridge windows if we have 64-bit dma_addr_t (2014-11-19 14:30:32 -0700)
>
> ----------------------------------------------------------------
> PCI updates for v3.18:
>
>   Resource management
>     - Support 64-bit bridge windows if we have 64-bit dma_addr_t (Yinghai Lu)
>
>   PCI device hotplug
>     - Apply _HPX Link Control settings to all devices with a link (Yinghai Lu)
>
>   Generic host bridge driver
>     - Add DT binding for "linux,pci-domain" property (Lucas Stach)
>
>   APM X-Gene
>     - Assign resources to bus before adding new devices (Duc Dang)
>
> ----------------------------------------------------------------
> Duc Dang (1):
>       PCI: xgene: Assign resources to bus before adding new devices
>
> Lucas Stach (1):
>       PCI: Add missing DT binding for "linux,pci-domain" property
>
> Yinghai Lu (2):
>       PCI: Apply _HPX Link Control settings to all devices with a link
>       PCI: Support 64-bit bridge windows if we have 64-bit dma_addr_t
>
>  Documentation/devicetree/bindings/pci/pci.txt | 11 ++++++++++
>  drivers/pci/access.c                          |  2 +-
>  drivers/pci/host/pci-xgene.c                  |  7 ++++++-
>  drivers/pci/pci.h                             |  2 ++
>  drivers/pci/probe.c                           | 30 +++++++++++++++------------
>  5 files changed, 37 insertions(+), 15 deletions(-)
