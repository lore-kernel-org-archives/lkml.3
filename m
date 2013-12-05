Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701Ab3LEK4B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 05:56:01 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:57437 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475Ab3LEKz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 05:55:58 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v3 1/3] Documentation: arm: add UEFI support documentation
To: Matt Sealey <neko@bakuhatsu.net>, Leif Lindholm <leif.lindholm@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-efi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, matt.fleming@intel.com,
        roy.franz@linaro.org, msalter@redhat.com,
        Patch Tracking <patches@linaro.org>, linaro-uefi@linaro.org,
        Mark Rutland <mark.rutland@arm.com>, Rob Landley <rob@landley.net>,
        linux-doc@vger.kernel.org
In-Reply-To: <CAHCPf3t5dEzVWbYZ6DWcFCENNO2dbrx-YeZvKRk0MkEsJMTE3A@mail.gmail.com>
References: <1385656883-4420-1-git-send-email-leif.lindholm@linaro.org> < 1385656883-4420-2-git-send-email-leif.lindholm@linaro.org> < CAHCPf3t5dEzVWbYZ6DWcFCENNO2dbrx-YeZvKRk0MkEsJMTE3A@mail.gmail.com>
Date: Thu, 05 Dec 2013 10:55:50 +0000
Message-Id: <20131205105550.692FCC40710@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Dec 2013 13:51:22 -0600, Matt Sealey <neko@bakuhatsu.net> wrote:
> > +UEFI kernel support on ARM
> > +==========================
> > +UEFI kernel support on the ARM architectures (arm and arm64) is only available
> > +when boot is performed through the stub.
> > +
> > +The stub populates the FDT /chosen node with (and the kernel scans for) the
> > +following parameters:
> > +________________________________________________________________________________
> > +Name                      | Size   | Description
> > +================================================================================
> > +linux,uefi-system-table   | 64-bit | Physical address of the UEFI System Table.
> > +--------------------------------------------------------------------------------
> > +linux,uefi-mmap-start     | 64-bit | Physical address of the UEFI memory map,
> > +                          |        | populated by the UEFI GetMemoryMap() call.
> > +--------------------------------------------------------------------------------
> > +linux,uefi-mmap-size      | 32-bit | Size in bytes of the UEFI memory map
> > +                          |        | pointed to in previous entry.
> > +--------------------------------------------------------------------------------
> > +linux,uefi-mmap-desc-size | 32-bit | Size in bytes of each entry in the UEFI
> > +                          |        | memory map.
> > +--------------------------------------------------------------------------------
> > +linux,uefi-mmap-desc-ver  | 32-bit | Version of the mmap descriptor format.
> > +--------------------------------------------------------------------------------
> > +linux,uefi-stub-kern-ver  | string | Copy of linux_banner from build.
> > +--------------------------------------------------------------------------------
> 
> This flies in the face of actually using #address-cells and
> #size-cells to define how big addresses and sizes are. You're limited
> here by the root node definitions... that's the spec.
> 
> Here's where I think this whole thing falls down as being the weirdest
> possible implementation of this. It defies logic to put this
> information in the device tree /chosen node while also attempting to
> boot the kernel using an EFI stub; the stub is going to have this
> information because it is going to have the pointer to the system
> System Table (since it was called by StartImage()). Why not stash the
> System Table pointer somewhere safe in the stub?

Everything here is about getting from the stub to the kernel. We have a
boot interface for the kernel proper. It works, and this patch set works
with it. Also, this is effectively a kernel-internal interface between
the stub and the kernel so there aren't any ABI issues that we need to
deail with.

Go ahead and propose patches for a better interface, but in the mean
time I see no reason not to merge this series.

g.
