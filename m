Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331Ab3CNOKy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 10:10:54 -0400
Received: from cm-84.215.157.11.getinternet.no ([84.215.157.11]:56879 "EHLO
	server.arpanet.local" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756815Ab3CNOKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 10:10:51 -0400
From: =?UTF-8?q?Jon=20Arne=20J=C3=B8rgensen?= <jonarne@jonarne.no>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hverkuil@xs4all.nl, elezegarcia@gmail.com
Subject: [RFC V1 0/8] Add a driver for somagic smi2021 
Date: Thu, 14 Mar 2013 15:06:56 +0100
Message-Id: <1363270024-12127-1-git-send-email-jonarne@jonarne.no>
X-Mailer: git-send-email 1.8.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set will add a driver for the Somagic SMI2021 chip.

This chip is found inside different usb video-capture devices.
Most of them are branded as EasyCap, but there also seems to be
some other brands selling devices with this chip.

This driver is split into two modules, where one is called smi2021-bootloader,
and the other is just called smi2021.

The bootloader is responsible for the upload of a firmware that is needed by some
versions of the devices.

All Somagic devices that need firmware seems to identify themselves
with the usb product id 0x0007. There is no way for the kernel to know
what firmware to upload to the device without user interaction.

If there is only one firmware present on the computer, the kernel
will upload that firmware to any device that identifies as 0x0007.
If there are multiple Somagic firmwares present, the user will have to pass
a module parameter to the smi2021-bootloader module to tell what firmware to use.

