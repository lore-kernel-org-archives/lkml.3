Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757914AbaAFXtS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:49:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47798 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932469AbaAFWjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:39:39 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nicholas <arealityfarbetween@googlemail.com>,
        Michele Baldessari <michele@acksyn.org>,
        Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 3.12 098/144] libata: add ATA_HORKAGE_BROKEN_FPDMA_AA quirk for Seagate Momentus SpinPoint M8
Date: Mon,  6 Jan 2014 14:37:39 -0800
Message-Id: <20140106223748.168739562@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223745.326293132@linuxfoundation.org>
References: <20140106223745.326293132@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michele Baldessari <michele@acksyn.org>

commit 87809942d3fa60bafb7a58d0bdb1c79e90a6821d upstream.

We've received multiple reports in Fedora via (BZ 907193)
that the Seagate Momentus SpinPoint M8 errors out when enabling AA:
[    2.555905] ata2.00: failed to enable AA (error_mask=0x1)
[    2.568482] ata2.00: failed to enable AA (error_mask=0x1)

Add the ATA_HORKAGE_BROKEN_FPDMA_AA for this specific harddisk.

Reported-by: Nicholas <arealityfarbetween@googlemail.com>
Signed-off-by: Michele Baldessari <michele@acksyn.org>
Tested-by: Nicholas <arealityfarbetween@googlemail.com>
Acked-by: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/libata-core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4156,6 +4156,9 @@ static const struct ata_blacklist_entry
 	{ "ST3320[68]13AS",	"SD1[5-9]",	ATA_HORKAGE_NONCQ |
 						ATA_HORKAGE_FIRMWARE_WARN },
 
+	/* Seagate Momentus SpinPoint M8 seem to have FPMDA_AA issues */
+	{ "ST1000LM024 HN-M101MBB", "2AR10001",	ATA_HORKAGE_BROKEN_FPDMA_AA },
+
 	/* Blacklist entries taken from Silicon Image 3124/3132
 	   Windows driver .inf file - also several Linux problem reports */
 	{ "HTS541060G9SA00",    "MB3OC60D",     ATA_HORKAGE_NONCQ, },


