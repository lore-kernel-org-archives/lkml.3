Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758002Ab3ANV0S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 16:26:18 -0500
Received: from mout.gmx.net ([212.227.17.20]:51774 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756677Ab3ANV0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 16:26:16 -0500
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX18T34cuzaAT/0pjHwEWvQvIlMXNyMGkPEVrdTzPi9
	qH84Ri+Do6Z9Wd
Message-ID: <50F477F5.8070403@gmx.de>
Date: Mon, 14 Jan 2013 22:26:13 +0100
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130111 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: ibm-acpi-devel@lists.sourceforge.net
Subject: / is remounted when the power cable is plugged in/out
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At my ThinkPad T420 I get these syslog messages when I plug off the power cable of a system
booted from an external USB drive (root / is /dev/sdb3):


2013-01-14T22:20:46.028+01:00 n22 kernel: ata1.00: failed to get Identify Device Data, Emask 0x1
2013-01-14T22:20:46.029+01:00 n22 kernel: ata1.00: failed to get Identify Device Data, Emask 0x1
2013-01-14T22:20:46.029+01:00 n22 kernel: ata1.00: configured for UDMA/100
2013-01-14T22:20:46.029+01:00 n22 kernel: ata1: EH complete
2013-01-14T22:20:46.029+01:00 n22 kernel: sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA                     
2013-01-14T22:20:46.083+01:00 n22 kernel: thinkpad_acpi: unknown possible thermal alarm or keyboard event received                                     
2013-01-14T22:20:46.083+01:00 n22 kernel: thinkpad_acpi: unhandled HKEY event 0x6040                                                                   
2013-01-14T22:20:46.083+01:00 n22 kernel: thinkpad_acpi: please report the conditions when this event happened to ibm-acpi-devel@lists.sourceforge.net 
2013-01-14T22:20:46.085+01:00 n22 kernel: thinkpad_acpi: EC reports that Thermal Table has changed                                                     
2013-01-14T22:20:46.000+01:00 n22 logger: ACPI event : ibm/hotkey HKEY 00000080 00006040                                                               
2013-01-14T22:20:46.000+01:00 n22 logger: ACPI event : ibm/hotkey HKEY 00000080 00006030                                                               
2013-01-14T22:20:46.305+01:00 n22 kernel: EXT4-fs (sdb3): re-mounted. Opts: commit=600                                                                 


and when I plug in the power cable I get the similar events :


2013-01-14T22:20:51.476+01:00 n22 kernel: ata1.00: failed to get Identify Device Data, Emask 0x1
2013-01-14T22:20:51.477+01:00 n22 kernel: ata1.00: failed to get Identify Device Data, Emask 0x1
2013-01-14T22:20:51.477+01:00 n22 kernel: ata1.00: configured for UDMA/100
2013-01-14T22:20:51.477+01:00 n22 kernel: ata1: EH complete
2013-01-14T22:20:51.477+01:00 n22 kernel: sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
2013-01-14T22:20:51.514+01:00 n22 kernel: thinkpad_acpi: unknown possible thermal alarm or keyboard event received
2013-01-14T22:20:51.514+01:00 n22 kernel: thinkpad_acpi: unhandled HKEY event 0x6040
2013-01-14T22:20:51.514+01:00 n22 kernel: thinkpad_acpi: please report the conditions when this event happened to ibm-acpi-devel@lists.sourceforge.net
2013-01-14T22:20:51.516+01:00 n22 kernel: thinkpad_acpi: EC reports that Thermal Table has changed
2013-01-14T22:20:51.000+01:00 n22 logger: ACPI event : ibm/hotkey HKEY 00000080 00006040
2013-01-14T22:20:51.000+01:00 n22 logger: ACPI event : ibm/hotkey HKEY 00000080 00006030
2013-01-14T22:20:52.170+01:00 n22 kernel: EXT4-fs (sdb3): re-mounted. Opts: commit=0


b/c of the unknown event 0x6040 the ibm acpi list is Cc'ed, but what makes me really wondering is
why / is remounted.


-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
