Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762134Ab3DDOl3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 10:41:29 -0400
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:40536
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761895Ab3DDOl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 10:41:28 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, ohering@suse.com,
        jbottomley@parallels.com, hch@infradead.org,
        linux-scsi@vger.kernel.org, kys@microsoft.com
Subject: scanning for LUNs 
Date: Thu,  4 Apr 2013 08:12:37 -0700
Message-Id: <1365088357-22624-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the code snippet for scanning LUNS (drivers/scsi/scsi_scan.c in function 
__scsi_scan_target()):

        /*
         * Scan LUN 0, if there is some response, scan further. Ideally, we
         * would not configure LUN 0 until all LUNs are scanned.
         */
        res = scsi_probe_and_add_lun(starget, 0, &bflags, NULL, rescan, NULL);
        if (res == SCSI_SCAN_LUN_PRESENT || res == SCSI_SCAN_TARGET_PRESENT) {
                if (scsi_report_lun_scan(starget, bflags, rescan) != 0)
 

So, if we don't get a response while scanning LUN0, we will not use scsi_report_lun_scan().
On Hyper-V, the scsi emulation on the host does not treat LUN0 as anything special and we 
could have situations where the only device under a scsi controller is at a location other than 0
or 1. In this case the standard LUN scanning code in Linux fails to detect this device. Is this
behaviour expected? Why is LUN0 treated differently here. Looking at the scsi spec, I am not sure
if this is what is specified. Any help/guidance will be greatly appreciated.
 
Regards,

K. Y

