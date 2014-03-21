Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966084AbaCUBNq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 21:13:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36654 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964903AbaCUAEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:04:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nicholas <arealityfarbetween@googlemail.com>,
        Michele Baldessari <michele@acksyn.org>,
        Guilherme Amadio <guilherme.amadio@gmail.com>,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 3.13 079/149] libata: add ATA_HORKAGE_BROKEN_FPDMA_AA quirk for Seagate Momentus SpinPoint M8 (2BA30001)
Date: Thu, 20 Mar 2014 17:04:02 -0700
Message-Id: <20140321000439.705530689@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michele Baldessari <michele@acksyn.org>

commit b28a613e9138e4b3a64649bd60b13436f4b4b49b upstream.

Via commit 87809942d3fa "libata: add ATA_HORKAGE_BROKEN_FPDMA_AA quirk
for Seagate Momentus SpinPoint M8" we added a quirk for disks named
"ST1000LM024 HN-M101MBB" with firmware revision "2AR10001".

As reported on https://bugzilla.redhat.com/show_bug.cgi?id=1073901,
we need to also add firmware revision 2BA30001 as it is broken as well.

Reported-by: Nicholas <arealityfarbetween@googlemail.com>
Signed-off-by: Michele Baldessari <michele@acksyn.org>
Tested-by: Guilherme Amadio <guilherme.amadio@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/libata-core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4175,6 +4175,7 @@ static const struct ata_blacklist_entry
 
 	/* Seagate Momentus SpinPoint M8 seem to have FPMDA_AA issues */
 	{ "ST1000LM024 HN-M101MBB", "2AR10001",	ATA_HORKAGE_BROKEN_FPDMA_AA },
+	{ "ST1000LM024 HN-M101MBB", "2BA30001",	ATA_HORKAGE_BROKEN_FPDMA_AA },
 
 	/* Blacklist entries taken from Silicon Image 3124/3132
 	   Windows driver .inf file - also several Linux problem reports */


