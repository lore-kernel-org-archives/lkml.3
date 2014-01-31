Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008AbaAaJ3L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 04:29:11 -0500
Received: from vserver.eikelenboom.it ([84.200.39.61]:58546 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbaAaJ3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 04:29:06 -0500
From: Sander Eikelenboom <linux@eikelenboom.it>
To: Bjorn Helgaas <bhelgaas@google.com>, Tony Luck <tony.luck@intel.com>,
        Dave Airlie <airlied@redhat.com>,
        Eiichiro Oiwa <eiichiro.oiwa.nm@hitachi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sander Eikelenboom <linux@eikelenboom.it>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel @ vger . kernel . org" <linux-kernel@vger.kernel.org>,
        "linux-pci @ vger . kernel . org" <linux-pci@vger.kernel.org>,
        linux-ia64@vger.kernel.org
Subject: [PATCH v2] Setting the IORESOURCE_ROM_SHADOW flag on a VGA card other than the primary prevents it from reading it's own rom. It will get the content of the shadowrom at C000 instead, which is of the primary VGA card and the driver of the secondary card will bail out.
Date: Fri, 31 Jan 2014 10:28:22 +0100
Message-Id: <1391160503-11122-1-git-send-email-linux@eikelenboom.it>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20140130000831.GJ16825@google.com>
References: <20140130000831.GJ16825@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn / Tony,

I fixed up ia64 as well and brought it inline again with the x86 code,
but i don't have a ia64 machine, so that part is untested.
Perhaps Tony is able to review/test it ?

Sander



Setting the IORESOURCE_ROM_SHADOW flag on a VGA card other than the primary
prevents it from reading it's own rom. It will get the content of the shadowrom
at C000 instead, which is of the primary VGA card and the driver of the
secondary card will bail out.

Fix this by checking if the arch code or vga-arbitration has already
determined the vga_default_device, if so only apply the fix to this
primary video device and let the comment reflect this.

v2:
    - Fix pci_fixup_video both in x86 and ia64


Sander Eikelenboom (1):
  Setting the IORESOURCE_ROM_SHADOW flag on a VGA card other than the
    primary     prevents it from reading it's own rom. It will get the
    content of the shadowrom     at C000 instead, which is of the
    primary VGA card and the driver of the     secondary card will bail
    out.

 arch/ia64/pci/fixup.c |   24 +++++++++++++-----------
 arch/x86/pci/fixup.c  |   18 ++++++++++--------
 2 files changed, 23 insertions(+), 19 deletions(-)

-- 
1.7.10.4

