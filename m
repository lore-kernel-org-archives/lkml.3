Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666AbaGIVEL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 17:04:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:6534 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167AbaGIVEJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 17:04:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,633,1400050800"; 
   d="scan'208";a="570797283"
From: "Luck, Tony" <tony.luck@intel.com>
To: Havard Skinnemoen <hskinnemoen@google.com>, Borislav Petkov <bp@alien8.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ewout van Bekkum" <ewout@google.com>
Subject: RE: [PATCH 6/6] x86-mce: ensure the MCP timer is not already set in
 the mce_timer_fn.
Thread-Topic: [PATCH 6/6] x86-mce: ensure the MCP timer is not already set
 in the mce_timer_fn.
Thread-Index: AQHPm5irgIXlqkYstkWOf8C65eGf0puYOvCQ
Date: Wed, 9 Jul 2014 21:04:06 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F328574D1@ORSMSX114.amr.corp.intel.com>
References: <1404925766-32253-1-git-send-email-hskinnemoen@google.com>
 <1404925766-32253-7-git-send-email-hskinnemoen@google.com>
In-Reply-To: <1404925766-32253-7-git-send-email-hskinnemoen@google.com>
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

+	/* Ensure a CMCI interrupt can't preempt this. */
+	local_irq_save(flags);
 	if (mce_available(__this_cpu_ptr(&cpu_info))) {
 		machine_check_poll(MCP_TIMESTAMP,
 				&__get_cpu_var(mce_poll_banks));

Does this remove the problem that you fixed in part4?  If a CMCI can
no longer interrupt a poll ... do we really need the locks you added?

-Tony
