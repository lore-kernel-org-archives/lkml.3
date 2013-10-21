Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab3JUD6r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 23:58:47 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:55162 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521Ab3JUD6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 23:58:45 -0400
From: Benson Leung <bleung@chromium.org>
To: matthew.garrett@nebula.com, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org, adurbin@chromium.org,
        dlaurie@chromium.org, olofj@chromium.org, enselic@gmail.com
Cc: bleung@chromium.org
Subject: [PATCH 0/6] Platform: x86: chromeos_laptop - Deferring and Haswell
Date: Sun, 20 Oct 2013 20:58:23 -0700
Message-Id: <1382327909-6140-1-git-send-email-bleung@chromium.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch series refactors the dmi check system and
returns -EPROBE_DEFER when an expected i2c adapter is not present
at probe time.

This will allow the touchpad, touchscreen, and light sensors on
Pixel to load even if the i915 DDC and PANEL buses are instantiated
after chromeos_laptop.

The deferred probing patches were sent previously, and have been cleaned up
slightly since.

Also one patch to clean up the placement of __initdata for the dmi_table.

Finally, add support for the Haswell generation Chromebook systems' 
peripherals over the new native i2c-designware-pci busses.

The last three patches depend on this patch series :
https://lkml.org/lkml/2013/10/20/136

[PATCH 1/6] Platform: x86: chromeos_laptop - Restructure device associations
[PATCH 2/6] Platform: x86: chromeos_laptop - Use deferred probing
[PATCH 3/6] Platform: x86: chromeos_laptop - fix incorrect placement of __initdata tag
[PATCH 4/6] Platform: x86: chromeos_laptop - Add names of Haswell ULT i2c busses
[PATCH 5/6] Platform: x86: chromeos_laptop - Add HP Chromebook 14
[PATCH 6/6] Platform: x86: chromeos_laptop - Add Acer C720

Regards,
Benson
