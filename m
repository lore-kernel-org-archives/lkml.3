Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884AbaCCH0E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 02:26:04 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:54785 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbaCCH0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 02:26:02 -0500
Date: Mon, 3 Mar 2014 15:25:51 +0800
From: Lee Jones <lee.jones@linaro.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH v2] timberdale: Use pci_enable_msix_exact() instead of
 pci_enable_msix()
Message-ID: <20140303072551.GC4674@lee--X1>
References: <1392804931-30671-3-git-send-email-agordeev@redhat.com>
 <20140219114424.GD10504@lee--X1>
 <20140221165606.GH17353@dhcp-26-207.brq.redhat.com>
 <20140221165809.GI17353@dhcp-26-207.brq.redhat.com>
 <20140224162902.GI15847@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140224162902.GI15847@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > As result of deprecation of MSI-X/MSI enablement functions
> > pci_enable_msix() and pci_enable_msi_block() all drivers
> > using these two interfaces need to be updated to use the
> > new pci_enable_msi_range()  or pci_enable_msi_exact()
> > and pci_enable_msix_range() or pci_enable_msix_exact()
> > interfaces.
> > 
> > Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> > Cc: Samuel Ortiz <sameo@linux.intel.com>
> > Cc: Lee Jones <lee.jones@linaro.org>
> > Cc: linux-pci@vger.kernel.org
> > ---
> >  drivers/mfd/timberdale.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> Applied, thanks.

I've reverted this patch, as it doesn't build othognally.

drivers/mfd/timberdale.c:718:2:
  error: implicit declaration of function ‘pci_enable_msix_exact’
     [-Werror=implicit-function-declaration]

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
