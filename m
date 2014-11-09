Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbaKIMTc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 07:19:32 -0500
Received: from mx4-phx2.redhat.com ([209.132.183.25]:36748 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbaKIMTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 07:19:31 -0500
Date: Sun, 9 Nov 2014 07:18:53 -0500 (EST)
From: Rodrigo Freire <rfreire@redhat.com>
To: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>,
        Felix Fietkau <nbd@openwrt.org>, dwmw2@infradead.org,
        Herton Krzesinski <hkrzesin@redhat.com>,
        Brian Norris <computersforpeace@gmail.com>
Message-ID: <2086372266.7454667.1415535533979.JavaMail.zimbra@redhat.com>
In-Reply-To: <20141105202303.GN23619@ld-irv-0074>
References: <371358190.34795877.1410204429882.JavaMail.zimbra@redhat.com> <1444809468.34812041.1410206680931.JavaMail.zimbra@redhat.com> <20140909170231.GA14429@logfs.org> <1807144344.40128259.1410985683342.JavaMail.zimbra@redhat.com> <20141105202303.GN23619@ld-irv-0074>
Subject: [PATCH v3 0/3] mtd: block2mtd: wait for device enumeration, add
 name support
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.11]
X-Mailer: Zimbra 8.0.6_GA_5922 (ZimbraWebClient - FF24 (Linux)/8.0.6_GA_5922)
Thread-Topic: block2mtd: wait for device enumeration, add name support
Thread-Index: PMeTZNEFdw+DidHIeFmVdhF00sSfjA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felix Fietkau <nbd@openwrt.org>

mtd: block2mtd: wait for device enumeration, add name support

Currently, a block MTD device is not presented timely on boot time, in
order to start mounting the filesystems, causing the system to not boot
or panic because of lack of rootfs. This patch ensures that block2mtd
is presented at the right time, so the filesystems can be mounted on boot
time.
This issue was seen on BCM2835 (Raspberry Pi) systems when mounting JFFS2
block2mtd filesystems.
This patchset also adds a MTD device name and a timeout option to the driver
and deprecates PAGE_MASK when calculating the device size.
Original patchset:
https://dev.openwrt.org/browser/trunk/target/linux/generic/patches-3.12/440-block2mtd_init.patch?rev=40444
https://dev.openwrt.org/browser/trunk/target/linux/generic/patches-3.12/441-block2mtd_probe.patch?rev=40444

V3: Split the changes on 3 different patches, fixes a compile warning
V2: Uses kstrdup, removed PAGE_MASK.

 drivers/mtd/devices/block2mtd.c |   57 ++++++++++++++++++++++++++++----------
 1 files changed, 42 insertions(+), 15 deletions(-)
 drivers/mtd/devices/block2mtd.c |   32 +++++++++++++++++++++++---------
 1 files changed, 23 insertions(+), 9 deletions(-)
 drivers/mtd/devices/block2mtd.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)
---
1.7.1
