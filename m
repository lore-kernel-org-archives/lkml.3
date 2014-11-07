Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422AbaKGJos (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 04:44:48 -0500
Received: from mga09.intel.com ([134.134.136.24]:10898 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229AbaKGJop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 04:44:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="485350861"
Message-ID: <1415353480.958.301.camel@sauron.fi.intel.com>
Subject: Re: [RESEND PATCH V2] mtd: block2mtd: Present block2mtd timely on
 boot time
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Rodrigo Freire <rfreire@redhat.com>
Cc: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
        linux-mtd@lists.infradead.org, Felix Fietkau <nbd@openwrt.org>,
        dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        Herton Krzesinski <hkrzesin@redhat.com>
Date: Fri, 07 Nov 2014 11:44:40 +0200
In-Reply-To: <2124950018.4236135.1414848795831.JavaMail.zimbra@redhat.com>
References: <2124950018.4236135.1414848795831.JavaMail.zimbra@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-11-01 at 09:33 -0400, Rodrigo Freire wrote:
> From: Felix Fietkau <nbd@openwrt.org> 
> 
> mtd: block2mtd: Ensure that block2mtd is presented timely on boot time
> 
> Currently, a block MTD device is not presented to the system on time, in 
> order to start mounting the filesystems. This patch ensures that block2mtd 
> is presented at the right time, so filesystems can be mounted on boot time. 
> This issue is seen on BCM2835 (Raspberry Pi) systems when mounting JFFS2 
> over block2mtd devices as the root filesystem.
> This patchset also adds a MTD device name and a timeout option to the driver. 
> Original patchset: 
> https://dev.openwrt.org/browser/trunk/target/linux/generic/patches-3.12/440-block2mtd_init.patch?rev=40444 
> https://dev.openwrt.org/browser/trunk/target/linux/generic/patches-3.12/441-block2mtd_probe.patch?rev=40444 

I  think you can mount jffs2 using /dev/mtdX, you do not need the block
driver.

