Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624Ab3HQB1B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 21:27:01 -0400
Received: from smtp01.smtpout.orange.fr ([80.12.242.123]:20593 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257Ab3HQB07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 21:26:59 -0400
From: Yann Cantin <yann.cantin@laposte.net>
To: linux-input@vger.kernel.org, linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        dmitry.torokhov@gmail.com, jkosina@suse.cz, rob@landley.net,
        gregkh@linuxfoundation.org
Subject: [PATCH 0/2] new USB eBeam input driver
Date: Fri, 16 Aug 2013 22:25:41 +0200
Message-Id: <1376684743-25047-1-git-send-email-yann.cantin@laposte.net>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

New USB input driver for eBeam devices.

Currently supported (tested) :
- Luidia eBeam classic projection and edge projection models
- Nec "interactive solution" NP01Wi1 & NP01Wi2 accessories.

>From basic usb point of view, all these devices are
indistinguishable : they have the same usb ids and (blank) hid
report descriptors. There's other re-branded hardware that need to be
test, but i bet on same ids.

Patch 1 to blacklist the devices for hid generic-usb.

Patch 2 is the actual driver.

Notable stuff :
- use div64_s64 for portable 64/64-bits divisions.
- 13 sysfs custom files : 9 values for the transformation matrix,
  4 for xy ranges and a calibration trigger.

The module run fine since 3.3.6 kernel, both x86_32 and 64, actually
run in production on a 3.8.13 and compile without errors on
today's linus tree.

Side note :
- This driver was first submit and discuss last year.

Thanks for your help.

