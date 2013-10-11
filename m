Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab3JKOne (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 10:43:34 -0400
Received: from mail-relay09.hrz.tu-darmstadt.de ([130.83.156.241]:39863 "EHLO
	lnx503.hrz.tu-darmstadt.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752208Ab3JKOnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 10:43:32 -0400
X-Greylist: delayed 425 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Oct 2013 10:43:32 EDT
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <21080.3305.184337.222292@hertz.ikp.physik.tu-darmstadt.de>
Date: Fri, 11 Oct 2013 16:36:25 +0200
To: linux-kernel@vger.kernel.org
Subject: Lots of "EDD information not available" messages
X-Mailer: VM 8.2.0b under 24.2.1 (x86_64-suse-linux-gnu)
From: bon@elektron.ikp.physik.tu-darmstadt.de
X-PMX-TU: seen v1.2 by 5.6.1.2065439, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2013.10.11.142415
X-PMX-RELAY: outgoing
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

running X86-64 on Intel motherboard DL87-RH with Opensuse-12.3 results in
lots of messages like

kernel: [  459.263752] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
kernel: [  459.263753] EDD information not available.
...

until I rename edd.ko. This happens still with "kernel of the day"
3.12.0-rc3-6.g9f1b1d6-desktop.

dmidecode list EDD:

Handle 0x0000, DMI type 0, 24 bytes
BIOS Information
...
                EDD is supported
...

so I guess this is the reason why probably sysfs tries to load
edd.ko. However 

edd_init(void)

sees ZERO devices and so denies to load.

        if (!edd_num_devices()) {
                printk(KERN_INFO "EDD information not available.\n");
                return -ENODEV;
        }

Probably the next action on sysfs tries to load edd.ko again. It this a
resonable explanation? What to do against it?

Thanks 

-- 
Uwe Bonnes                bon@elektron.ikp.physik.tu-darmstadt.de

Institut fuer Kernphysik  Schlossgartenstrasse 9  64289 Darmstadt
--------- Tel. 06151 162516 -------- Fax. 06151 164321 ----------
