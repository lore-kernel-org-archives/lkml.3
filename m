Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594Ab3AMS5O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 13:57:14 -0500
Received: from smtp.multi.fi ([85.134.37.151]:43734 "EHLO smtp.multi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754020Ab3AMS5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 13:57:13 -0500
X-Greylist: delayed 1127 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 Jan 2013 13:57:12 EST
Message-ID: <50F2FF1B.3020708@mageia.org>
Date: Sun, 13 Jan 2013 20:38:19 +0200
From: Thomas Backlund <tmb@mageia.org>
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: if_bridge.h: include in6.h for struct in6_addr use
Content-Type: multipart/mixed;
 boundary="------------080708000708030904060806"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080708000708030904060806
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

patch both inline and attached as thunderbird tends to mess up ...
-----

if_bridge.h uses struct in6_addr ip6; but does not include the in6.h header.

Found by trying to build libvirt and connman against 3.8-rc3 headers.

Reported-by: Colin Guthrie <colin@mageia.org>
Reported-by: Christiaan Welvaart <cjw@daneel.dyndns.org>
Signed-off-by: Thomas Backlund <tmb@mageia.org>

--

diff -Nurp linux-3.8-rc3/include/uapi/linux/if_bridge.h 
linux-3.8-rc3.fix/include/uapi/linux/if_bridge.h
--- linux-3.8-rc3/include/uapi/linux/if_bridge.h        2013-01-13 
20:09:54.257271755 +0200
+++ linux-3.8-rc3.fix/include/uapi/linux/if_bridge.h    2013-01-13 
20:15:04.153676151 +0200
@@ -14,6 +14,7 @@
  #define _UAPI_LINUX_IF_BRIDGE_H

  #include <linux/types.h>
+#include <linux/in6.h>

  #define SYSFS_BRIDGE_ATTR      "bridge"
  #define SYSFS_BRIDGE_FDB       "brforward"


-----
Thomas


--------------080708000708030904060806
Content-Type: text/plain; charset=windows-1252;
 name="if_bridge.h-include-in6.h-for-struct-in6_addr-use.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="if_bridge.h-include-in6.h-for-struct-in6_addr-use.patch"


if_bridge.h uses struct in6_addr ip6; but does not include the in6.h header.

Found by trying to build libvirt and connman against 3.8-rc3 headers.

Reported-by: Colin Guthrie <colin@mageia.org>
Reported-by: Christiaan Welvaart <cjw@daneel.dyndns.org>
Signed-off-by: Thomas Backlund <tmb@mageia.org>

--

diff -Nurp linux-3.8-rc3/include/uapi/linux/if_bridge.h linux-3.8-rc3.fix/include/uapi/linux/if_bridge.h
--- linux-3.8-rc3/include/uapi/linux/if_bridge.h	2013-01-13 20:09:54.257271755 +0200
+++ linux-3.8-rc3.fix/include/uapi/linux/if_bridge.h	2013-01-13 20:15:04.153676151 +0200
@@ -14,6 +14,7 @@
 #define _UAPI_LINUX_IF_BRIDGE_H
 
 #include <linux/types.h>
+#include <linux/in6.h>
 
 #define SYSFS_BRIDGE_ATTR	"bridge"
 #define SYSFS_BRIDGE_FDB	"brforward"

--------------080708000708030904060806--
