Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab3DNVZg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 17:25:36 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:34393 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850Ab3DNVZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 17:25:34 -0400
Message-ID: <516B1ED3.9040900@suse.cz>
Date: Sun, 14 Apr 2013 23:25:39 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: matthew.garrett@nebula.com
CC: matt.fleming@intel.com, cbouatmailru@gmail.com, ccross@android.com,
        keescook@chromium.org, Tony Luck <tony.luck@intel.com>,
        linux-efi@vger.kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Cannot add new efi boot entry
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

after update to 3.8, every update of the kernel ends up in an unbootable
machine. It is due to the following commit:
commit 68d929862e29a8b52a7f2f2f86a0600423b093cd
Author: Matthew Garrett <matthew.garrett@nebula.com>
Date:   Sat Mar 2 19:40:17 2013 -0500

    efi: be more paranoid about available space when creating variables

efibootmgr which tries to add an entry and silently fails when writing
to /sys/firmware/efi/vars/new_var with -ENOSPC.

There are many entries in there:
# efibootmgr
BootCurrent: 000D
Timeout: 0 seconds
BootOrder:
0018,0000,0001,0002,0003,0007,0008,0009,000A,000B,000C,000D,000E,000F,0010,0011,0012
Boot0000  Setup
Boot0001  Boot Menu
Boot0002  Diagnostic Splash Screen
Boot0003  Lenovo Diagnostics
Boot0004  Startup Interrupt Menu
Boot0005  ME Configuration Menu
Boot0006  Rescue and Recovery
Boot0007* USB CD
Boot0008* USB FDD
Boot0009* ATAPI CD0
Boot000A* ATA HDD0
Boot000B* ATA HDD1
Boot000C* ATA HDD2
Boot000D* USB HDD
Boot000E* PCI LAN
Boot000F* ATAPI CD1
Boot0010  Other CD
Boot0011* ATA HDD3
Boot0012  Other HDD
Boot0013* IDER BOOT CDROM
Boot0014* IDER BOOT Floppy
Boot0015* ATA HDD
Boot0016* ATAPI CD:
Boot0017* PCI LAN
Boot0018* Linux


Remaining size is about 20k, added entry size is hundreds bytes, store
size is 64k.

Obviously lowering the limitation from 1/2 to 1/4 fixes the problem for
me because it always worked on my setup to store a new entry...

Any ideas how to overcome that? It would be better to blacklist bad
machines rather than whitelist good ones, right?

thanks,
-- 
js
suse labs
