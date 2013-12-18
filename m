Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab3LRDs7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 22:48:59 -0500
Received: from mail-by2lp0242.outbound.protection.outlook.com ([207.46.163.242]:11625
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751945Ab3LRDs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 22:48:58 -0500
Message-ID: <1387338529.3140.42.camel@snotra.buserror.net>
Subject: Re: [v3][PATCH 7/8] book3e/kexec/kdump: redefine VIRT_PHYS_OFFSET
From: Scott Wood <scottwood@freescale.com>
To: Tiejun Chen <tiejun.chen@windriver.com>
CC: <benh@kernel.crashing.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Date: Tue, 17 Dec 2013 21:48:49 -0600
In-Reply-To: <1373357007-30785-8-git-send-email-tiejun.chen@windriver.com>
References: <1373357007-30785-1-git-send-email-tiejun.chen@windriver.com>
	 <1373357007-30785-8-git-send-email-tiejun.chen@windriver.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: BLUPR06CA003.namprd06.prod.outlook.com (10.255.223.141)
 To DM2PR03MB399.namprd03.prod.outlook.com (10.141.84.148)
X-Forefront-PRVS: 0064B3273C
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(377424004)(189002)(24454002)(199002)(46102001)(51856001)(83072002)(88136002)(31966008)(74662001)(74502001)(47446002)(74876001)(85852003)(77096001)(77156001)(50466002)(81542001)(69226001)(4396001)(50226001)(56816005)(49866001)(47976001)(50986001)(47736001)(33646001)(81816001)(53806001)(76482001)(85306002)(87266001)(42186004)(59766001)(81686001)(79102001)(81342001)(62966002)(54316002)(76786001)(65816001)(76796001)(80976001)(80022001)(74706001)(83322001)(74366001)(87976001)(56776001)(77982001)(90146001)(63696002)(89996001)(47776003)(87286001)(23676002)(32563001)(3826001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB399;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];CLIP:2601:2:5800:3f7:12bf:48ff:fe84:c9a0;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-09 at 16:03 +0800, Tiejun Chen wrote:
> Book3e is always aligned 1GB to create TLB so we should
> use (KERNELBASE - MEMORY_START) as VIRT_PHYS_OFFSET to
> get __pa/__va properly while boot kdump.

What if MEMORY_START - PHYSICAL_START >= 1 GiB?

What about the comment that says we can't use MEMORY_START before
parsing the device tree?

-Scott


