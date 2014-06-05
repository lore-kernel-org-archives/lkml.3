Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751380AbaFEIxl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 04:53:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56223 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbaFEIxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 04:53:39 -0400
MIME-Version: 1.0
Date: Thu, 5 Jun 2014 16:53:36 +0800
Message-ID: <CACVXFVMnM6w5ZLX=S8fJHeVoEqxH2JG3Wg=GPMeoVnOpAjsvAA@mail.gmail.com>
Subject: [Regression] commit 8a4aeec8d(libata/ahci: accommodate tag ordered controllers)
From: Ming Lei <ming.lei@canonical.com>
To: Dan Williams <dan.j.williams@intel.com>, Tejun Heo <tj@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan and Tejun,

Looks the commit 8a4aeec8d(libata/ahci: accommodate tag ordered
controllers) causes below sata failure[1] on APM AHCI controller.

And the error does disappear after reverting the commit.

Thanks,
--
Ming Lei

[1], failure log
[   72.001579] ata4.00: exception Emask 0x40 SAct 0xff00 SErr 0x800
action 0x6 frozen
[   72.009116] ata4: SError: { HostInt }
[   72.012763] ata4.00: failed command: READ FPDMA QUEUED
[   72.017878] ata4.00: cmd 60/08:40:e0:a4:88/00:00:04:00:00/40 tag 8
ncq 4096 in
[   72.017878]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x44 (timeout)
[   72.032498] ata4.00: status: { DRDY }
[   72.036139] ata4.00: failed command: READ FPDMA QUEUED
[   72.041252] ata4.00: cmd 60/18:48:b8:3e:10/00:00:09:00:00/40 tag 9
ncq 12288 in
[   72.041252]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x44 (timeout)
[   72.055956] ata4.00: status: { DRDY }
[   72.059598] ata4.00: failed command: READ FPDMA QUEUED
[   72.064713] ata4.00: cmd 60/08:50:00:be:07/01:00:01:00:00/40 tag 10
ncq 135168 in
[   72.064713]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x44 (timeout)
[   72.079589] ata4.00: status: { DRDY }
[   72.083233] ata4.00: failed command: READ FPDMA QUEUED
[   72.088345] ata4.00: cmd 60/08:58:00:07:09/00:00:06:00:00/40 tag 11
ncq 4096 in
[   72.088345]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x44 (timeout)
[   72.103049] ata4.00: status: { DRDY }
[   72.106691] ata4.00: failed command: READ FPDMA QUEUED
[   72.111805] ata4.00: cmd 60/08:60:00:4b:f9/00:00:0d:00:00/40 tag 12
ncq 4096 in
[   72.111805]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x44 (timeout)
[   72.126509] ata4.00: status: { DRDY }
[   72.130151] ata4.00: failed command: READ FPDMA QUEUED
[   72.135265] ata4.00: cmd 60/20:68:28:f5:3a/00:00:09:00:00/40 tag 13
ncq 16384 in
[   72.135265]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x44 (timeout)
