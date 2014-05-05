Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933236AbaEEX3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 19:29:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:49520 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756771AbaEEX3R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 19:29:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,992,1389772800"; 
   d="scan'208";a="535139701"
From: "Luck, Tony" <tony.luck@intel.com>
To: Mathieu Souchaud <mattieu.souchaud@free.fr>, "bp@alien8.de" <bp@alien8.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: RE: [PATCH v2] x86/mce: Improve mcheck_init_device() error handling
Thread-Topic: [PATCH v2] x86/mce: Improve mcheck_init_device() error handling
Thread-Index: AQHPZxNH4Zd4vAzK/kmz6SmGz4FilJsyoyww
Date: Mon, 5 May 2014 23:29:14 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F327F8E9B@ORSMSX114.amr.corp.intel.com>
References: <1399151031-19905-1-git-send-email-mattieu.souchaud@free.fr>
In-Reply-To: <1399151031-19905-1-git-send-email-mattieu.souchaud@free.fr>
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

+err_device_create:
+	/*
+	 * mce_device_remove behave properly if mce_device_create was not
+	 * called on that device.
+	 */
+	for_each_possible_cpu(i)
+		mce_device_remove(i);

grammar comment "s/behave/behaves/"

Though perhaps this is better:

	/*
	 * We didn't keep track of which devices were created above, but
	 * even if we had, the set of online cpus might have changed.
	 * Play safe and remove for every possible cpu since mce_device_remove()
	 * will do the right thing.
	 */

-Tony
