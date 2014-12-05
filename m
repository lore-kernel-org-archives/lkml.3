Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbaLEI2N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 03:28:13 -0500
Received: from eridanus.uberspace.de ([82.98.87.120]:41139 "EHLO
	eridanus.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140AbaLEI2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 03:28:12 -0500
Message-ID: <54816C93.2020009@rupran.de>
Date: Fri, 05 Dec 2014 09:28:03 +0100
From: Andreas Ruprecht <mail@rupran.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: jim.epost@gmail.com, sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, jiri@resnulli.us, sfeldma@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: rocker: Add select to CONFIG_BRIDGE in
 Kconfig
References: <CA+r1ZhhJQuwXbs+Et-ihsGP3QXDUWZ1nJ-5_hcjioFt5s8zMrA@mail.gmail.com>	<54809BA5.7030901@rupran.de> <20141204.202404.32587724475591669.davem@davemloft.net>
In-Reply-To: <20141204.202404.32587724475591669.davem@davemloft.net>
Content-Type: multipart/mixed;
 boundary="------------030300000307050208030905"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030300000307050208030905
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit


> On 05.12.2014 05:24, David Miller wrote:
> Do not use select, please.
> 
> You can only use select on leaf node Kconfig symbols, ie. those
> which do not have any dependencies whatsoever.
> 
> Select does not recursively walk down the dependency chain turning
> things on for you when you say "select X".
> 

Okay, sure, my bad for not looking that up properly.

If we change this into a "depends on", this should not be a problem,
right? If CONFIG_BRIDGE is selected as 'm', then CONFIG_ROCKER can only
be 'n' or 'm', if CONFIG_BRIDGE is set to 'y', it can be 'n', 'm' or 'y'.

This also means that the prompt associated with CONFIG_ROCKER will only
show up in menuconfig when CONFIG_BRIDGE has been enabled (either 'm' or
'y').

I've attached an updated patch.

--------------030300000307050208030905
Content-Type: text/x-patch;
 name="0001-net-ethernet-rocker-Add-dependency-to-CONFIG_BRIDGE-.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename*0="0001-net-ethernet-rocker-Add-dependency-to-CONFIG_BRIDGE-.pa";
 filename*1="tch"

=46rom 931a36cc5ec67ec23ba2373d42840d968ed78120 Mon Sep 17 00:00:00 2001
From: Andreas Ruprecht <rupran@einserver.de>
Date: Thu, 4 Dec 2014 18:28:09 +0100
Subject: [PATCH] net: ethernet: rocker: Add dependency to CONFIG_BRIDGE i=
n
 Kconfig

In a configuration with CONFIG_BRIDGE set to 'm' and CONFIG_ROCKER
set to 'y', undefined references occur at link time:

> drivers/built-in.o: In function `rocker_port_fdb_learn_work':
> /home/jim/linux/drivers/net/ethernet/rocker/rocker.c:3014: undefined
> reference to `br_fdb_external_learn_del'
> /home/jim/linux/drivers/net/ethernet/rocker/rocker.c:3016: undefined
> reference to `br_fdb_external_learn_add'

This patch fixes these by declaring CONFIG_ROCKER as being dependent
on CONFIG_BRIDGE.

Reported-by: Jim Davis <jim.epost@gmail.com>
Signed-off-by: Andreas Ruprecht <rupran@einserver.de>
---
 drivers/net/ethernet/rocker/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/rocker/Kconfig b/drivers/net/ethernet/r=
ocker/Kconfig
index 11a850eab628..b9952ef040e4 100644
--- a/drivers/net/ethernet/rocker/Kconfig
+++ b/drivers/net/ethernet/rocker/Kconfig
@@ -17,7 +17,7 @@ if NET_VENDOR_ROCKER

 config ROCKER
 	tristate "Rocker switch driver (EXPERIMENTAL)"
-	depends on PCI && NET_SWITCHDEV
+	depends on PCI && NET_SWITCHDEV && BRIDGE
 	---help---
 	  This driver supports Rocker switch device.

--
1.9.1


--------------030300000307050208030905--
