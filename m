Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932810AbaLDRn0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 12:43:26 -0500
Received: from eridanus.uberspace.de ([82.98.87.120]:52910 "EHLO
	eridanus.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932751AbaLDRnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 12:43:23 -0500
Message-ID: <54809BA5.7030901@rupran.de>
Date: Thu, 04 Dec 2014 18:36:37 +0100
From: Andreas Ruprecht <mail@rupran.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jim Davis <jim.epost@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, jiri@resnulli.us,
        sfeldma@gmail.com, netdev <netdev@vger.kernel.org>
Subject: [PATCH] net: ethernet: rocker: Add select to CONFIG_BRIDGE in Kconfig
References: <CA+r1ZhhJQuwXbs+Et-ihsGP3QXDUWZ1nJ-5_hcjioFt5s8zMrA@mail.gmail.com>
In-Reply-To: <CA+r1ZhhJQuwXbs+Et-ihsGP3QXDUWZ1nJ-5_hcjioFt5s8zMrA@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------060500090600040505030303"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060500090600040505030303
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit

On 04.12.2014 17:34, Jim Davis wrote:
> Building with the attached random configuration file,
> 
> drivers/built-in.o: In function `rocker_port_fdb_learn_work':
> /home/jim/linux/drivers/net/ethernet/rocker/rocker.c:3014: undefined
> reference to `br_fdb_external_learn_del'
> /home/jim/linux/drivers/net/ethernet/rocker/rocker.c:3016: undefined
> reference to `br_fdb_external_learn_add'
> 

Hi,

the problem here is that CONFIG_BRIDGE is set to 'm' (leading to
inclusion of the two functions above in the kernel module) while
CONFIG_ROCKER is set to 'y', requiring the functions at link time.

Is the attached patch sufficient to fix this?

Regards,

Andreas

--------------060500090600040505030303
Content-Type: text/x-patch;
 name="0001-net-ethernet-rocker-Add-select-to-CONFIG_BRIDGE-in-K.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename*0="0001-net-ethernet-rocker-Add-select-to-CONFIG_BRIDGE-in-K.pa";
 filename*1="tch"

=46rom 0529c3cbe381338dc3337e07a71e15b3d22a3255 Mon Sep 17 00:00:00 2001
From: Andreas Ruprecht <rupran@einserver.de>
Date: Thu, 4 Dec 2014 18:28:09 +0100
Subject: [PATCH] net: ethernet: rocker: Add select to CONFIG_BRIDGE in Kc=
onfig

In a configuration with CONFIG_BRIDGE set to 'm' and CONFIG_ROCKER
set to 'y', undefined references occur at link time:

> drivers/built-in.o: In function `rocker_port_fdb_learn_work':
> /home/jim/linux/drivers/net/ethernet/rocker/rocker.c:3014: undefined
> reference to `br_fdb_external_learn_del'
> /home/jim/linux/drivers/net/ethernet/rocker/rocker.c:3016: undefined
> reference to `br_fdb_external_learn_add'

This patch fixes these by selecting CONFIG_BRIDGE from CONFIG_ROCKER.

Reported-by: Jim Davis <jim.epost@gmail.com>
Signed-off-by: Andreas Ruprecht <rupran@einserver.de>
---
 drivers/net/ethernet/rocker/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/rocker/Kconfig b/drivers/net/ethernet/r=
ocker/Kconfig
index 11a850eab628..ade10ec4c78d 100644
--- a/drivers/net/ethernet/rocker/Kconfig
+++ b/drivers/net/ethernet/rocker/Kconfig
@@ -18,6 +18,7 @@ if NET_VENDOR_ROCKER
 config ROCKER
 	tristate "Rocker switch driver (EXPERIMENTAL)"
 	depends on PCI && NET_SWITCHDEV
+	select BRIDGE
 	---help---
 	  This driver supports Rocker switch device.
=20
--=20
1.9.1


--------------060500090600040505030303--
