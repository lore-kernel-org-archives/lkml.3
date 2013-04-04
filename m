Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762626Ab3DDQFa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 12:05:30 -0400
Received: from mga14.intel.com ([143.182.124.37]:46402 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760671Ab3DDQF2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 12:05:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,410,1363158000"; 
   d="scan'208";a="222865078"
From: "Luck, Tony" <tony.luck@intel.com>
To: Daniel J Blueman <daniel@numascale-asia.com>,
        Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Steffen Persvold <sp@numascale.com>
Subject: RE: [PATCH] x86, amd, mce: Prevent potential cpu-online oops
Thread-Topic: [PATCH] x86, amd, mce: Prevent potential cpu-online oops
Thread-Index: AQHOMUzBBVtMkyw9vUeBxGdJaaJBMJjGOPnA
Date: Thu, 4 Apr 2013 16:04:53 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F1E09882E@ORSMSX108.amr.corp.intel.com>
References: <1365090720-12652-1-git-send-email-daniel@numascale-asia.com>
In-Reply-To: <1365090720-12652-1-git-send-email-daniel@numascale-asia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+		if (WARN_ON_ONCE(!nb))
+			goto out;
+

WARN_ON_ONCE() will drop a stack trace to the console - is that going to be useful?

If you want a message perhaps:

		if (!nb) {
			printk_once("something interesting about not having access to north bridge\n")
			goto out;
		}

-Tony
