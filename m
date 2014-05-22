Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930AbaEVNgf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 09:36:35 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:42417 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbaEVNgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 09:36:33 -0400
Message-ID: <537DFD58.5040809@laine.org>
Date: Thu, 22 May 2014 16:36:24 +0300
From: Laine Stump <laine@laine.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>, bhelgaas@google.com,
        linux-pci@vger.kernel.org
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, konrad.wilk@oracle.com,
        kim.phillips@linaro.org, gregkh@linuxfoundation.org, agraf@suse.de,
        stuart.yoder@freescale.com, libvir-list@redhat.com,
        iommu@lists.linux-foundation.org, tech@virtualopensystems.com,
        kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
Subject: Re: [libvirt] [PATCH v3] PCI: Introduce new device binding path using
 pci_dev.driver_override
References: <20140520145136.28232.90707.stgit@bling.home>
In-Reply-To: <20140520145136.28232.90707.stgit@bling.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2014 05:53 PM, Alex Williamson wrote:
> The driver_override field allows us to specify the driver for a device
> rather than relying on the driver to provide a positive match of the
> device.  This shortcuts the existing process of looking up the vendor
> and device ID, adding them to the driver new_id, binding the device,
> then removing the ID, but it also provides a couple advantages.
>
> First, the above existing process allows the driver to bind to any
> device matching the new_id for the window where it's enabled.  This is
> often not desired, such as the case of trying to bind a single device
> to a meta driver like pci-stub or vfio-pci.  Using driver_override we
> can do this deterministically using:
>
> echo pci-stub > /sys/bus/pci/devices/0000:03:00.0/driver_override
> echo 0000:03:00.0 > /sys/bus/pci/devices/0000:03:00.0/driver/unbind
> echo 0000:03:00.0 > /sys/bus/pci/drivers_probe

I'm not qualified to review the mechanics of the patch, but as a
potential consumer of this new interface (in libvirt), I want to say
that it is *immensely* improved over the racy, error prone method that
the kernel currently has available. The first day that I looked at the
libvirt code that uses the "new_id" method to bind drivers to devices, I
wished that there would instead be an interface more or less identical
to what Alex has described here - simple, deterministic, and with
minimal side effect outside of the exact device and driver pair we want
to bind.

