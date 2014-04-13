Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900AbaDMTXb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 15:23:31 -0400
Received: from www84.your-server.de ([213.133.104.84]:33800 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755000AbaDMTXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 15:23:30 -0400
Message-ID: <1397416959.1555.30.camel@vger.seibold.net>
Subject: Missing USB XHCI and EHCI reset for kexec
From: Stefani Seibold <stefani@seibold.net>
To: linux-usb <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>,
        sarah.a.sharp@linux.intel.com
Date: Sun, 13 Apr 2014 21:22:39 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When executing a kexec kernel on a PowerPC board the new started kernel
will not find already enumerated USB devices due a missing reset on the
USB bus.

As a work around a

echo 1 >/sys/bus/pci/drivers/[ex]hci-pci/BUS-ADDRESS-OF-THE-HCD/reset

will solve this. But this is far from beauty.

My latest kernel without this issue was for EHCI kernel 2.6.39 and for
XHCI kernel 3.4, but i have no idea when exactly this behavior was
introduced.

For X86 all is fine.


