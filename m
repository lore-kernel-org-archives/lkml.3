Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079AbaHaTqG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 15:46:06 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:47128 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751498AbaHaTqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 15:46:02 -0400
X-Sasl-enc: gw7xf070mByrPEF7zbGv7jt4Ub1Zvh5RtiZtZG+QSh+T 1409514360
Date: Sun, 31 Aug 2014 16:45:48 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@alien8.de>, H Peter Anvin <hpa@zytor.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: early microcode: how to disable at runtime?
Message-ID: <20140831194548.GA12628@khazad-dum.debian.net>
References: <20140809231911.GA4843@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140809231911.GA4843@khazad-dum.debian.net>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, there is no way to disable early microcode update at runtime.  If
an early initramfs with microcode update data is available, it will always
be used.

This can be a very big deal when things go wrong: it is hard for the regular
user to recover from an initramfs image that crashes the system, and the
early initramfs has no "disable" trigger.

In the general case, booting from rescue media will be required to fix the
system.

Unfortunately, the BSP microcode update is handled before early_param() is
available, so a kernel command line parameter to disable early microcode
updates for the BSP isn't easily possible.

Other than duplicating much of the code in parse_early_param/parse_args to
search for a "noearlymcu" parameter, is there any other way we could add a
disable switch for the early microcode update system?

Otherwise, distros will have to generate a rescue initramfs image
automatically that has the entire early initramfs stripped, or somehow get
the bootloaders (and mkinitramfs/dracut) to deal (correctly) with two
initramfs images.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
