Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761444AbbA2KAE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:00:04 -0500
Received: from mga02.intel.com ([134.134.136.20]:20817 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755738AbbA2J77 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:59:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,485,1418112000"; 
   d="scan'208";a="519549051"
From: "Ong, Boon Leong" <boon.leong.ong@intel.com>
To: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "dvhart@infradead.org" <dvhart@infradead.org>,
        "andy.shevchenko@gmail.com" <andy.shevchenko@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2] x86: Add Isolated Memory Regions for Quark X1000
Thread-Topic: [PATCH 1/2] x86: Add Isolated Memory Regions for Quark X1000
Thread-Index: AQHQOylqnLZVjTv+WEq44p1GA6waZpzW3flg
Date: Thu, 29 Jan 2015 09:59:35 +0000
Message-ID: <AF233D1473C1364ABD51D28909A1B1B732714FE9@PGSMSX105.gar.corp.intel.com>
References: <1422470186-7860-1-git-send-email-pure.logic@nexus-software.ie>
 <1422470186-7860-2-git-send-email-pure.logic@nexus-software.ie>
In-Reply-To: <1422470186-7860-2-git-send-email-pure.logic@nexus-software.ie>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.20.206]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bryan, a minor fix on the config below... 

>diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug index
>61bd2ad..fcf5701 100644
>--- a/arch/x86/Kconfig.debug
>+++ b/arch/x86/Kconfig.debug
>@@ -313,6 +313,18 @@ config DEBUG_NMI_SELFTEST
>
> 	  If unsure, say N.
>
>+config DEBUG_IMR_SELFTEST
>+	bool "Isolated Memory Region self test"
>+	default n
>+	depends on INTEL_IMR
>+	---help---
>+	  This option enables automated sanity testing of the IMR code.
>+	  Some simple tests are run to verify IMR bounds checking, alignment
>+	  and overlapping. This option is really only useful if you are
>+	  debugging an IMR memory map or are modifying the IMR code and
>want to
>+	  test your changes.
>+
>+	  If unsure say N here.
Miss a newline here. 

> config X86_DEBUG_STATIC_CPU_HAS
> 	bool "Debug alternatives"
> 	depends on DEBUG_KERNEL
