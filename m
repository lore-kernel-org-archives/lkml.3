Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751328AbaCXVTs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 17:19:48 -0400
Received: from mail-bn1blp0188.outbound.protection.outlook.com ([207.46.163.188]:5248
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750790AbaCXVTr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 17:19:47 -0400
From: Anders Berg <anders.berg@lsi.com>
To: Russell King <linux@arm.linux.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Anders Berg <anders.berg@lsi.com>
Subject: [PATCH RFC] ARM: mm: Fix for highmem on machines with more than 14 cores
Date: Mon, 24 Mar 2014 22:02:11 +0100
Message-ID: <cover.1395692531.git.anders.berg@lsi.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [85.229.45.38]
X-ClientProxiedBy: DB4PR07CA040.eurprd07.prod.outlook.com (10.242.229.50) To
 CO1PR07MB377.namprd07.prod.outlook.com (10.141.74.156)
X-Forefront-PRVS: 01604FB62B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019001)(6009001)(6069001)(428001)(189002)(199002)(164054003)(89996001)(95666003)(69226001)(81342001)(94946001)(46102001)(4396001)(90146001)(47976001)(51856001)(93916002)(85306002)(33646001)(62966002)(95416001)(56816005)(87976001)(50226001)(50466002)(88136002)(80976001)(97186001)(74366001)(53806001)(81816001)(97336001)(81686001)(98676001)(93136001)(92726001)(50986001)(86362001)(94316002)(47736001)(49866001)(85852003)(92566001)(81542001)(74876001)(76482001)(87286001)(83322001)(56776001)(54316002)(87266001)(93516002)(42186004)(63696002)(47776003)(76176001)(76786001)(20776003)(76796001)(77096001)(65816001)(77156001)(80022001)(36756003)(79102001)(31966008)(77982001)(59766001)(66066001)(74662001)(47446002)(74502001)(23676002);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR07MB377;H:localhost.localdomain;FPR:1A62FDE7.7F13B449.69C51707.8CC53379.2013F;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: lsi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

While working of platform support for the LSI AXM5516 SoC (a 16 x A15 device)
we ran into this limitation in fixmap.h where there is not enough room for the
per-cpu pages if NR_CPUS is set to 16.

The following patch avoids the overlap by lowering the base address according to
the values of NR_CPUS and KM_TYPE_NR. Is this the way to handle this?

Thanks,
Anders


Anders Berg (1):
  ARM: mm: Fix for highmem on machines with more than 14 cores

 arch/arm/include/asm/fixmap.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

-- 
1.8.3.2

