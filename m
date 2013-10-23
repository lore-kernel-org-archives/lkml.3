Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964Ab3JWAtp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 20:49:45 -0400
Received: from mga03.intel.com ([143.182.124.21]:9483 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751199Ab3JWAto convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 20:49:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="311348301"
From: "Yang, Fei" <fei.yang@intel.com>
To: David Cohen <david.a.cohen@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Brown, Mark F" <mark.f.brown@intel.com>,
        Kuppuswamy Sathyanarayanan 
	<sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: RE: [PATCH] x86: intel-mid: add Merrifield platform support
Thread-Topic: [PATCH] x86: intel-mid: add Merrifield platform support
Thread-Index: AQHOz36NxoDiL71rT0aUHbkZoA8SBZoBcpaQ
Date: Wed, 23 Oct 2013 00:49:41 +0000
Message-ID: <02E7334B1630744CBDC55DA85862258348EDC9B0@ORSMSX102.amr.corp.intel.com>
References: <1382131130-10903-4-git-send-email-david.a.cohen@linux.intel.com>
 <1382484820-5912-1-git-send-email-david.a.cohen@linux.intel.com>
In-Reply-To: <1382484820-5912-1-git-send-email-david.a.cohen@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+				if (intel_mid_identify_cpu() ==
+						INTEL_MID_CPU_CHIP_TANGIER) {
+					if (!strncmp(pentry->name,
+							"r69001-ts-i2c", 13))
+						/* active low */
+						irq_attr.polarity = 1;
+					else if (!strncmp(pentry->name,
+							"synaptics_3202", 14))
+						/* active low */
+						irq_attr.polarity = 1;
+					else if (irq == 41)
+						/* fast_int_1 */
+						irq_attr.polarity = 1;

Do you really want to upstream these very hardware specific hacks? It's needed for
Saltbay, but might not be correct for other Merrifield based hardware, if any.

-Fei
