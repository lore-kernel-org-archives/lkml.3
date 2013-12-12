Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915Ab3LLA17 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 19:27:59 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:48603 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076Ab3LLA16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 19:27:58 -0500
MIME-Version: 1.0
In-Reply-To: <CAMxnaaWgUPRb3L2aKpUu62F73GR2iXOfd6LUnTkU0O=Gq-E_sQ@mail.gmail.com>
References: <CAMxnaaWgUPRb3L2aKpUu62F73GR2iXOfd6LUnTkU0O=Gq-E_sQ@mail.gmail.com>
Date: Wed, 11 Dec 2013 16:21:09 -0800
X-Google-Sender-Auth: 0vWRtS5n4kT0s6YP_dVfRBqb3gA
Message-ID: <CAE9FiQUtqtBLx3_pdhs=CjgqViGrDL9xdCjLKgs66jA-apHdQA@mail.gmail.com>
Subject: Re: How to reserve pci bus numbers for hotplug?
From: Yinghai Lu <yinghai@kernel.org>
To: Andreas Noever <andreas.noever@gmail.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 3:37 PM, Andreas Noever
<andreas.noever@gmail.com> wrote:

> If I could get Linux to assign enough resources (bus numbers for now)
> then I could drop the acpi_osi parameter and make thunderbolt work
> after suspend... So, is there an easy way to fix this? (Quirks,
> reconfiguring bus number assignments from a platform driver, ...?)

please check if busn_alloc at

git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
for-pci-busn-alloc-3.14

could help.

  resources: Split out __allocate_resource()
  resources: Add resource_shrink_parents_top()
  resources: Add probe_resource()
  resources: Replace registered resource in tree.
  PCI: Add pci_bus_extend/shrink_top()
  PCI: Probe safe range that we can use for unassigned bridge.
  PCI: Add pci_bus_replace_busn_res()
  PCI: Allocate bus range instead of use max blindly
  PCI: Strict checking of valid range for bridge
  PCI: Kill pci_fixup_parent_subordinate_busnr()
  PCI: Seperate child bus scanning to two passes overall
  pcmcia: Remove workaround for fixing pci parent bus subordinate
  PCI, pciehp: Remove not needed bus number range checking
  PCI: More strict checking of valid range for bridge
  PCI: Don't shrink too much for hotplug bridge
  expand_bus_for_sriov
