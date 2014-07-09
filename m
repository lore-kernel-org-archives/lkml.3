Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831AbaGIUgj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 16:36:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:61617 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056AbaGIUgh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 16:36:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,633,1400050800"; 
   d="scan'208";a="567551457"
From: "Luck, Tony" <tony.luck@intel.com>
To: Havard Skinnemoen <hskinnemoen@google.com>, Borislav Petkov <bp@alien8.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ewout van Bekkum" <ewout@google.com>
Subject: RE: [PATCH 3/6] x86-mce: Clear CMCI enable on all claimed CMCI
 banks before reboot.
Thread-Topic: [PATCH 3/6] x86-mce: Clear CMCI enable on all claimed CMCI
 banks before reboot.
Thread-Index: AQHPm5iryoE6uf3N0kCTe5ZvTQx8TJuYMSUQ
Date: Wed, 9 Jul 2014 20:36:35 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F32857499@ORSMSX114.amr.corp.intel.com>
References: <1404925766-32253-1-git-send-email-hskinnemoen@google.com>
 <1404925766-32253-4-git-send-email-hskinnemoen@google.com>
In-Reply-To: <1404925766-32253-4-git-send-email-hskinnemoen@google.com>
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

+	if (!xchg(&reboot_notifier_registered, true))
+		register_reboot_notifier(&cmci_reboot_notifier);

This is super-safe ... but isn't the xchg() overkill? I thought we serialized bringup
of other cpus.

Has this "do it once" caught on elsewhere in the kernel ... I suppose it is more concise than

	if (!reboot_notifier_registered) {
		reboot_notifier_registered = 1;
		register_reboot_notifier(&cmci_reboot_notifier);
	}

-Tony
