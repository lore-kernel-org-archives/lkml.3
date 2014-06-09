Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869AbaFINpk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 09:45:40 -0400
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:16792 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbaFINph convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 09:45:37 -0400
X-LoopCount0: from 10.175.216.249
X-IronPort-AV: E=Sophos;i="4.98,1002,1392184800"; 
   d="scan'208";a="527851053"
From: <B_B_Singh@DELL.com>
To: <linux-kernel@vger.kernel.org>
CC: <teg@jklm.no>, <ming.lei@canonical.com>, <gregkh@linuxfoundation.org>,
        <Abhay_Salunke@DELL.com>, <sr@denx.de>, <arnd@arndb.de>,
        <kay@vrfy.org>, <Matt_Domsch@DELL.com>, <Srinivas_G_Gowda@DELL.com>,
        <Stuart_Hayes@DELL.com>
Date: Mon, 9 Jun 2014 19:14:32 +0530
Subject: [PATCH] firmware loader: allow disabling of udev as firmware loader
Thread-Topic: [PATCH] firmware loader: allow disabling of udev as firmware
 loader
Thread-Index: Ac+D6FocQX04qcrrR1yx4oO51S9UJQ==
Message-ID: <8B2F6FFD0BD1E448853114367400A37306FCD2E026@BLRX7MCDC203.AMER.DELL.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-version: 3.5.29.3
x-tituslabs-classifications-30: TLPropertyRoot=Dell;Classification=No
 Restrictions;Sublabels=;
x-tituslabs-classificationhash-30: k5/vssDqmf2mveDUEIruN3BjVP65ZqH04gsMFBH6pfi4W+WKM+uCEEAq/wAhN7MLIsxOs0SQ792izp9Sj7yysu2hXoR/71hq7jgJ+/S3rHVOCP3CzCG2qk4BpB0db0gqjzk8aQkFFE5yL5eDvB//4fpTXwlx3RtSkaln7dybmokRbfA2GpuRYcAnc1+xpPzWUA8oSH6vsqo1R8rLn2Wmc6XLs5Drival7APvFJeFIeikQgMjmr85BUoOY2LntSPrxhKggE1FrgRX1RmWIhSw7Q==
x-titusconfig: 1.4AMER
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi All,

The existing BIOS-DUP's will not work on latest kernel, which has CONFIG_FW_LOADER_USER_HELPER=n  configured in Kernel config by default which is not expected by the dell_rbu.

We have made a changes in BIOS-Dell Update Package so that BIOS-DUP will pick the payload from the /lib/firmware/ path & update the BIOS even when CONFIG_FW_LOADER_USER_HELPER=n is configured .

We have tested this patch http://www.spinics.net/lists/kernel/msg1755247.html with latest BIOS Dell Update Package (which has new implementation for the BIOS update i.e, copying the BIOS payload in /lib/firmware path & dell_rbu picks the payload from the same path)  & with  stable upstream      kernel-3.14.5 & we don't see any negative effects/errors for dell_rbu.

All the Test results are positive.

Regards
Balaji Singh

