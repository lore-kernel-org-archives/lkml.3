Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932815AbaAaStY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 13:49:24 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:55275 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932680AbaAaStV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 13:49:21 -0500
Date: Fri, 31 Jan 2014 11:49:18 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Quirk Intel PCH root ports for ACS-like features
Message-ID: <20140131184918.GA8834@google.com>
References: <20140120215502.29567.11291.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140120215502.29567.11291.stgit@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 03:01:40PM -0700, Alex Williamson wrote:
> As described in 2/2 many Intel root ports lack PCIe ACS capabilities
> which results in excessively large IOMMU groups.  Many of these root
> ports do provide isolation capabilities, we just need to use device
> specific mechanisms to enable and verify.  Long term, I hope we can
> round out this list (particularly to include X79 root ports) and
> more importantly, encourage proper PCIe ACS support in future
> products.  I'm really hoping we can get this in during the 3.14 cycle.

v3.13 was released Jan 19, so this came during the v3.14 merge window.  I
like to have things in -next for a while before asking Linus to pull them,
and I try to keep it to regression fixes after the merge window, i.e.,
things that used to work, but don't work any more.  But that's all standard
procedure that you already know, and maybe you can make a case for
accelerating this.

Bjorn

> Thanks,
> 
> Alex
> 
> ---
> 
> Alex Williamson (2):
>       pci: Add device specific PCI ACS enable
>       pci/quirks: Enable quirks for PCIe ACS on Intel PCH root ports
> 
> 
>  drivers/pci/pci.c    |   26 +++++-
>  drivers/pci/quirks.c |  201 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/pci.h  |    2 
>  3 files changed, 223 insertions(+), 6 deletions(-)
