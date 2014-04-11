Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070AbaDKGzT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 02:55:19 -0400
Received: from mail1.bemta14.messagelabs.com ([193.109.254.113]:16264 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754989AbaDKGzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 02:55:15 -0400
X-Greylist: delayed 386 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Apr 2014 02:55:15 EDT
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-6.tower-194.messagelabs.com!1397198926!14145756!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.11.1; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Fri, 11 Apr 2014 08:48:46 +0200
Date: Fri, 11 Apr 2014 08:48:40 +0200
From: Johannes Thumshirn <johannes.thumshirn@men.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: MCB fixes for 3.15-rc1
Message-ID: <20140411064829.GA11402@jtlinux>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [192.1.1.31]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Please pull this change for drivers/mcb.

Thanks
	Johannes

--

The following changes since commit 9e897e13bd46fa03485468609741974259a8c573:

  Merge branch 'for-linus' of git://git.open-osd.org/linux-open-osd (2014-04-10 14:33:02 -0700)

are available in the git repository at:


  git://github.com/morbidrsa/linux.git mcb

for you to fetch changes up to e383c2430770c4bb080b4915826f34b729b33bbc:

  drivers: mcb: fix memory leak in chameleon_parse_cells() error path (2014-04-11 08:37:37 +0200)

----------------------------------------------------------------
Christoph Jaeger (1):
      drivers: mcb: fix memory leak in chameleon_parse_cells() error path

 drivers/mcb/mcb-parse.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mcb/mcb-parse.c b/drivers/mcb/mcb-parse.c
index d1278b5..0049269 100644
--- a/drivers/mcb/mcb-parse.c
+++ b/drivers/mcb/mcb-parse.c
@@ -141,6 +141,7 @@ int chameleon_parse_cells(struct mcb_bus *bus, phys_addr_t mapbase,
 		default:
 			pr_err("Invalid chameleon descriptor type 0x%x\n",
 				dtype);
+			kfree(header);
 			return -EINVAL;
 		}
 		num_cells++;
