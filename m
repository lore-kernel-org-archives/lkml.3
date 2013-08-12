Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049Ab3HLITb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 04:19:31 -0400
Received: from mga03.intel.com ([143.182.124.21]:24379 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751819Ab3HLITT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 04:19:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,860,1367996400"; 
   d="scan'208";a="344986184"
From: "Berg, Johannes" <johannes.berg@intel.com>
To: Djalal Harouni <tixxdz@opendz.org>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] iwlwifi: mvm: make debugfs write() operations write up
 to count bytes
Thread-Topic: [PATCH] iwlwifi: mvm: make debugfs write() operations write up
 to count bytes
Thread-Index: AQHOlvSPjBpjRMPsiEO/Jfxgsh6L2JmROu5g
Date: Mon, 12 Aug 2013 08:19:12 +0000
Message-ID: <1DC40B07CD6EC041A66726C271A73AE61AA5E38C@IRSMSX102.ger.corp.intel.com>
References: <1376267972-5636-1-git-send-email-tixxdz@opendz.org>
In-Reply-To: <1376267972-5636-1-git-send-email-tixxdz@opendz.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [163.33.239.181]
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Some debugfs write() operations of the MVM Firmware will ignore the count
> argument, and will copy more bytes than what was specified.
> Fix this by getting the right count of bytes.
> 
> This will also honor restrictions put on the number of bytes to write.

That makes some sense.

> To be consitant this patch also switches the initializer from 'char buf[x] = {}' to
> the explicit memset() as it is done in other places of the same file.

I'd rather this (a) be done in a separate patch, and (b) the other way around, switch everything to C99.

> Cc: stable@vger.kernel.org

That doesn't really make sense for the debugfs interface.

> +	memset(buf, 0, sizeof(buf));
> +	if (count > sizeof(buf) - 1)
> +		count = sizeof(buf) - 1;

Why -1? And why not use min()/min_t()?

johannes
-- 

Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen, Deutschland
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Christian Lamprechter, Hannes Schwaderer, Douglas Lusk
Registergericht: Muenchen HRB 47456
Ust.-IdNr./VAT Registration No.: DE129385895
Citibank Frankfurt a.M. (BLZ 502 109 00) 600119052

