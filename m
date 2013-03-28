Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab3C1CBn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 22:01:43 -0400
Received: from queueout02-winn.ispmail.ntl.com ([81.103.221.56]:26047 "EHLO
	queueout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754282Ab3C1CBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 22:01:42 -0400
Date: Thu, 28 Mar 2013 01:01:48 +0000
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: linux-kernel@vger.kernel.org
Subject: smartd broken in 3.9.0-rc4
Message-ID: <20130328010148.GB25406@milliways>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Cloudmark-Analysis: v=1.1 cv=AUhbpHVS+xhHrj9wLCYAQoYnFLYUZdbP8UM0GmH2jwk= c=1 sm=0 a=wom5GMh1gUkA:10 a=uObrxnre4hsA:10 a=8nJEP1OIZ-IA:10 a=-9fLHVDCAAAA:8 a=rO2lHrpLJJmYZB5c7ncA:9 a=wPNLvfGTeEIA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

 just tested my first 3.9 kernel today.  During boot, smartd (from
smartmontools-6.0) fails to start.  Works fine in 3.8.4.

 In 3.8.4 I get messages like this :

Mar 27 22:02:02 ac4tv smartd[3981]: smartd 6.0 2012-10-10 r3643
[x86_64-linux-3.8.4] (local build) 
Mar 27 22:02:02 ac4tv smartd[3981]: Copyright (C) 2002-12, Bruce
Allen, Christian Franke, www.smartmontools.org 
Mar 27 22:02:02 ac4tv smartd[3981]: Opened configuration file
/etc/smartd.conf 
Mar 27 22:02:02 ac4tv smartd[3981]: Configuration file
/etc/smartd.conf parsed. 
Mar 27 22:02:02 ac4tv smartd[3981]: Device: /dev/sda, opened 
Mar 27 22:02:02 ac4tv smartd[3981]: Device: /dev/sda, WDC
WD5000AAKX-001CA0, S/N:WD-WMAYU6818967, WWN:5-0014ee-0ad9caed4,
FW:15.01H15, 500 GB 
Mar 27 22:02:02 ac4tv smartd[3981]: Device: /dev/sda, found in
smartd database: Western Digital Caviar Blue Serial ATA 
Mar 27 22:02:02 ac4tv smartd[3981]: Device: /dev/sda, enabled SMART
Automatic Offline Testing. 
Mar 27 22:02:02 ac4tv smartd[3981]: Device: /dev/sda, is SMART
capable. Adding to "monitor" list. 
Mar 27 22:02:02 ac4tv smartd[3981]: Monitoring 1 ATA and 0 SCSI
devices 

 but in 3.9.0-rc4 all I get is
Mar 28 00:39:32 ac4tv smartd[2487]: Copyright (C) 2002-12, Bruce
Allen, Christian Franke, www.smartmontools.org 
Mar 28 00:39:32 ac4tv smartd[2487]: Opened configuration file
/etc/smartd.conf 
Mar 28 00:39:32 ac4tv smartd[2487]: Configuration file
/etc/smartd.conf parsed. 
Mar 28 00:39:32 ac4tv smartd[2487]: Device: /dev/sda, opened 
Mar 28 00:39:32 ac4tv smartd[2487]: Device: /dev/sda, WDC
WD5000AAKX-001CA0, S/N:WD-WMAYU6818967, WWN:5-0014ee-0ad9caed4,
FW:15.01H15, 500 GB 
Mar 28 00:39:32 ac4tv smartd[2487]: Device: /dev/sda, found in
smartd database: Western Digital Caviar Blue Serial ATA 
Mar 28 00:39:32 ac4tv smartd[2487]: Device: /dev/sda, could not
enable SMART capability 
Mar 28 00:39:32 ac4tv smartd[2487]: Unable to register ATA device
/dev/sda at line 1 of file /etc/smartd.conf 
Mar 28 00:39:32 ac4tv smartd[2487]: Unable to register device
/dev/sda (no Directive -d removable). Exiting. 

 Using strace, in the failing version I get
2643  ioctl(3, HDIO_DRIVE_CMD, 0x7fff53288a60) = -1 EIO (Input/output error)

instead of the normal
3981  ioctl(3, HDIO_DRIVE_CMD, 0x7fff04437340) = 0
3981  ioctl(3, HDIO_DRIVE_TASK, 0x7fff04437350) = 0
3981  ioctl(3, HDIO_DRIVE_CMD, 0x7fff04437330) = 0
3981  ioctl(3, HDIO_DRIVE_CMD, 0x7fff04437330) = 0
3981  ioctl(3, HDIO_DRIVE_TASK, 0x7fff04437340) = 0

 Looks like I'll be bisecting.

ken
-- 
das eine Mal als Tragödie, das andere Mal als Farce
