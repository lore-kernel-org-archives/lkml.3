Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab3CaWvA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 18:51:00 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:48971 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755857Ab3CaWu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 18:50:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Dave Jones <davej@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>, linux-usb@vger.kernel.org,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Lan Tianyu <tianyu.lan@intel.com>
Subject: [PATCH 1/2] USB / PM: Don't try to hide PM QoS flags from usb_port_device_release()
Date: Mon, 01 Apr 2013 00:57:21 +0200
Message-ID: <1651223.ep7oZJM5CX@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1876128.a4gSDF7byc@vostro.rjw.lan>
References: <512F8980.4040809@oracle.com> <2829731.BFs3ri3Eud@vostro.rjw.lan> <1876128.a4gSDF7byc@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Remove the call to dev_pm_qos_hide_flags(), added by commit 6e30d7cb
"usb: Add driver/usb/core/(port.c,hub.h) files", from
usb_port_device_release(), because (1) it is completely unnecessary
(the flags have been removed already by the PM core during the
unregistration of the device object) and (2) it triggers a NULL
pointer dereference in sysfs_find_dirent() (dev->kobj->sd is NULL at
this point).

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/usb/core/port.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux-pm/drivers/usb/core/port.c
===================================================================
--- linux-pm.orig/drivers/usb/core/port.c
+++ linux-pm/drivers/usb/core/port.c
@@ -67,7 +67,6 @@ static void usb_port_device_release(stru
 {
 	struct usb_port *port_dev = to_usb_port(dev);
 
-	dev_pm_qos_hide_flags(dev);
 	kfree(port_dev);
 }
 

