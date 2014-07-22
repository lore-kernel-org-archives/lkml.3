Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751033AbaGVAWk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 20:22:40 -0400
Received: from mga03.intel.com ([143.182.124.21]:2590 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776AbaGVAWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 20:22:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,705,1400050800"; 
   d="scan'208,223";a="459735166"
Message-ID: <1405988531.2455.14.camel@rzhang1-toshiba>
Subject: Re: 3.16-rcX crashes on resume from Suspend-To-RAM
From: Zhang Rui <rui.zhang@intel.com>
To: markus@gutschke.com
Cc: linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Date: Tue, 22 Jul 2014 08:22:11 +0800
In-Reply-To: <CALGCz1qzmK_0Mq8JNFYUnGtDGWSqYoHfqv0MKbqG1RySQ4bt6g@mail.gmail.com>
References: <CALGCz1qs2A7BCbcK3vzYRxJeOESVKc7c9kcSpP0NrQFLr1UpUg@mail.gmail.com>
	 <CALGCz1oYYkKp1frPF4vExiwqW=euYY8An+Yum4U-qsBc5NyjFg@mail.gmail.com>
	 <1405587482.28592.64.camel@rzhang1-toshiba>
	 <CALGCz1qzmK_0Mq8JNFYUnGtDGWSqYoHfqv0MKbqG1RySQ4bt6g@mail.gmail.com>
Content-Type: multipart/mixed; boundary="=-O/QD/2qJHjzvB9n5yreF"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-O/QD/2qJHjzvB9n5yreF
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Thu, 2014-07-17 at 10:27 -0700, Markus Gutschke wrote:
> Please note the crash in "dmesg" right after booting. This looks relevant:
> 
I think the crash log also exists in 3.15 kernel, can you please verify
this?

> https://medusa.gutschke.com/markus/acpi/after-dmesg.txt
> https://medusa.gutschke.com/markus/acpi/acpidump.txt
> https://medusa.gutschke.com/markus/acpi/before-platform-devices-firmware-node.txt
> https://medusa.gutschke.com/markus/acpi/before-platform-devices.txt
> https://medusa.gutschke.com/markus/acpi/before-pnp-devices-firmware-node.txt
> https://medusa.gutschke.com/markus/acpi/before-pnp-devices.txt
> https://medusa.gutschke.com/markus/acpi/after-platform-devices-firmware-node.txt
> https://medusa.gutschke.com/markus/acpi/after-platform-devices.txt
> https://medusa.gutschke.com/markus/acpi/after-pnp-devices-firmware-node.txt
> https://medusa.gutschke.com/markus/acpi/after-pnp-devices.txt

are you building the kernel with last commit
eec15edbb0e14485998635ea7c62e30911b465f0?

If yes, please rebuild your 3.16 kernel with last commit
b04c58b1ed26317bfb4b33d3a2d16377fc6acd0f, and re-attach the after-*
logs.

And please also apply the debug patch attached on top of commit
b04c58b1ed26317bfb4b33d3a2d16377fc6acd0f, and see if the problem still
exists.

thanks,
rui

--=-O/QD/2qJHjzvB9n5yreF
Content-Disposition: attachment; filename="0001-debug-patch.patch"
Content-Type: text/x-patch; name="0001-debug-patch.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From 6e0b48c3075f9b1fcedd97c2f2454a585671dcd2 Mon Sep 17 00:00:00 2001
From: Zhang Rui <rui.zhang@intel.com>
Date: Tue, 22 Jul 2014 08:11:25 +0800
Subject: [PATCH] debug patch

---
 drivers/acpi/acpi_pnp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/acpi/acpi_pnp.c b/drivers/acpi/acpi_pnp.c
index 4ddb0dc..1c306b4 100644
--- a/drivers/acpi/acpi_pnp.c
+++ b/drivers/acpi/acpi_pnp.c
@@ -317,6 +317,9 @@ static const struct acpi_device_id acpi_pnp_device_ids[] = {
 	/* snd-opl3sa2-pnpbios */
 	{"YMH0021"},
 	{"NMX2210"},		/* Gateway Solo 2500 */
+	{"PNP0800"},
+	{"PNP0200"},
+	{"PNP0c04"},
 	{""},
 };
 
-- 
1.8.3.2


--=-O/QD/2qJHjzvB9n5yreF--

