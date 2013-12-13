Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab3LMTWx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 14:22:53 -0500
Received: from mail-ea0-f170.google.com ([209.85.215.170]:45629 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605Ab3LMTWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 14:22:52 -0500
From: Levente Kurusa <levex@linux.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4] treewide: add missing put_device calls
Date: Fri, 13 Dec 2013 20:22:33 +0100
Message-Id: <1386962557-8899-1-git-send-email-levex@linux.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is just the beginning of patchset-set that aims to fix possible
problems caused by not calling put_device() if device_register() fails.

The root cause for the need to call put_device() is that the underlying
kobject still has a reference count of 1. Thus, device.release() will not
be called and the device will just sit there waiting for a put_device().
Adding the put_device() also removes the need for the call to kfree() as most
release functions already call kfree() on the container of the device.

While these have not been experienced, they are potential issues and thus
they need to be fixed. Also, they are a few more files that have the same
kind of issue, those will be fixed if these are accepted.

(Sorry for the noise, I messed up my SMTP server so it didn't reach LKML)

The patchset consists of the following patches:

net: phy: call put_device on device_register() failure
eisa: call put_device if device_register fails
backlight: lcd: call put_device if device_register fails
w1: call put_device if device_register fails


diffstat as follows:

 drivers/eisa/eisa-bus.c       |    4 +++-
 drivers/net/phy/mdio_bus.c    |    1 +
 drivers/video/backlight/lcd.c |    2 +-
 drivers/w1/w1_int.c           |    5 ++---
 4 files changed, 7 insertions(+), 5 deletions(-)

--
Regards,
Levente Kurusa
