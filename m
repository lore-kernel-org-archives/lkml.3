Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943Ab3H3VBZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 17:01:25 -0400
Received: from smtp09.smtpout.orange.fr ([80.12.242.131]:39775 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383Ab3H3VBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 17:01:14 -0400
From: Yann Cantin <yann.cantin@laposte.net>
To: linux-input@vger.kernel.org, linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        dmitry.torokhov@gmail.com, jkosina@suse.cz, rob@landley.net,
        gregkh@linuxfoundation.org
Subject: [PATCH v2 0/2] new USB eBeam input driver
Date: Fri, 30 Aug 2013 22:53:05 +0200
Message-Id: <1377895987-27715-1-git-send-email-yann.cantin@laposte.net>
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

Changes from v1 -> v2:
- fix sysfs/input creation race in ebeam_probe
- use get_unaligned_le16 macro in ebeam_read_data
- move usb_kill_urb after usb_autopm_get_interface in ebeam_close
- remove reset_resume(), use resume() in reset_resume entry

Thanks for your help.
