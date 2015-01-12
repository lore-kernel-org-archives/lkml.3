Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028AbbALSIE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:08:04 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:52723 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001AbbALSIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:08:01 -0500
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [GIT PULL] USB fixes for v3.19-rc5
Date: Mon, 12 Jan 2015 12:07:20 -0600
Message-ID: <1421086040-28464-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 2.2.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Looks like this will be my last pull request for v3.19. Please consider merging
on top of your usb-linus branch.

Note that there will be a conflict when merging on that branch, the solution is
to use the version from my tree as that's more correct. Here's how the related
code should look like:

devm_usb_ge_phy_by_phandle():

[ ... ]

195         phy = __of_usb_find_phy(node);
196         if (IS_ERR(phy)) {
197                 devres_free(ptr);
198                 goto err1;
199         }
200 
201         if (!try_module_get(phy->dev->driver->owner)) {
202                 phy = ERR_PTR(-ENODEV);
203                 devres_free(ptr);
204                 goto err1;
205         }

[ ... ]

cheers

The following changes since commit 6785a1034461c2d2c205215f63a50a740896e55b:

  usb: gadget: udc: atmel: fix possible IN hang issue (2014-12-22 10:41:15 -0600)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git tags/fixes-for-v3.19-rc5

for you to fetch changes up to 5fb694f96e7c19e66b1c55124b98812e32e3efa5:

  usb: gadget: udc: atmel: fix possible oops when unloading module (2015-01-09 18:15:11 -0600)

----------------------------------------------------------------
usb: fixes for v3.19-rc5

Just three fixes this time. An oops fix in ep_write() from gadgetfs,
another oops for the Atmel UDC when unloading a gadget driver and
the fix for PHY deferred probing.

Signed-off-by: Felipe Balbi <balbi@ti.com>

----------------------------------------------------------------
Dan Carpenter (1):
      usb: gadget: gadgetfs: fix an oops in ep_write()

Songjun Wu (1):
      usb: gadget: udc: atmel: fix possible oops when unloading module

Thierry Reding (1):
      usb: phy: Restore deferred probing path

 drivers/usb/gadget/legacy/inode.c       |  1 +
 drivers/usb/gadget/udc/atmel_usba_udc.c | 12 +++++++++++-
 drivers/usb/phy/phy.c                   | 14 ++++++++++----
 3 files changed, 22 insertions(+), 5 deletions(-)
