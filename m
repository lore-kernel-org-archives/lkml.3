Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762AbaAIS6A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 13:58:00 -0500
Received: from mga09.intel.com ([134.134.136.24]:64776 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753799AbaAIS5x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 13:57:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,632,1384329600"; 
   d="scan'208";a="436480742"
From: "Allan, Bruce W" <bruce.w.allan@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Allan, Bruce W" <bruce.w.allan@intel.com>
Subject: bug in sscanf()?
Thread-Topic: bug in sscanf()?
Thread-Index: Ac8NbKAkgHr1INwXQ8WF2Iu0CYn2gw==
Date: Thu, 9 Jan 2014 18:57:29 +0000
Message-ID: <804857E1F29AAC47BF68C404FC60A1846542A6B2@ORSMSX105.amr.corp.intel.com>
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

The kernel version of sscanf() does not allow for scanning a string with multiple concatenated integers even when maximum field widths are specified to stop reading the string to delineate the individual integers.  For example, trying to read the (3) 32-bit hexadecimal integers deadbeef, 12345678 and deadc0de when provided as a concatenated string with:

	int num;
	u32 i, j, k;
	
	num = sscanf("deadbeef12345678deadc0de", "%8x%8x%8x", &i, &j, &k);

will return the number of input items successfully matched and assigned as 3, the 32-bit integers j and k will have the expected values, but i will be 0.

The libc version of sscanf(), however, will set the value of i to deadbeef.

Should this be expected with the kernel version or is it a bug?

Thanks,
Bruce.

