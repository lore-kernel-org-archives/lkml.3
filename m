Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810AbaGIUrb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 16:47:31 -0400
Received: from mga03.intel.com ([143.182.124.21]:52006 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724AbaGIUra convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 16:47:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,633,1400050800"; 
   d="scan'208";a="455122518"
From: "Luck, Tony" <tony.luck@intel.com>
To: Havard Skinnemoen <hskinnemoen@google.com>, Borislav Petkov <bp@alien8.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ewout van Bekkum" <ewout@google.com>
Subject: RE: [PATCH 4/6] x86-mce: Add spinlocks to prevent duplicated MCP
 and CMCI reports.
Thread-Topic: [PATCH 4/6] x86-mce: Add spinlocks to prevent duplicated MCP
 and CMCI reports.
Thread-Index: AQHPm5irKQRI444FeUKUaXDupa/8IJuYNj4Q
Date: Wed, 9 Jul 2014 20:47:23 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F328574AE@ORSMSX114.amr.corp.intel.com>
References: <1404925766-32253-1-git-send-email-hskinnemoen@google.com>
 <1404925766-32253-5-git-send-email-hskinnemoen@google.com>
In-Reply-To: <1404925766-32253-5-git-send-email-hskinnemoen@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

		if (!(flags & MCP_UC) &&
-		    (m.status & (mca_cfg.ser ? MCI_STATUS_S : MCI_STATUS_UC)))
+		    (m.status & (mca_cfg.ser ? MCI_STATUS_S : MCI_STATUS_UC))) {
+			spin_unlock_irqrestore(&mce_banks[i].poll_spinlock,
+					       irq_flags);
 			continue;
+		}

Perhaps move this test for UC up to before you grab the lock?

-Tony
