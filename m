Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391AbaEDIk3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 04:40:29 -0400
Received: from mail-by2lp0235.outbound.protection.outlook.com ([207.46.163.235]:56331
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752655AbaEDIk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 04:40:27 -0400
Message-ID: <5365FCF2.9090008@freescale.com>
Date: Sun, 4 May 2014 16:40:18 +0800
From: Hongbo Zhang <hongbo.zhang@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: <vkoul@infradead.org>, <dan.j.williams@intel.com>,
        <dmaengine@vger.kernel.org>, <scottwood@freescale.com>,
        <leo.li@freescale.com>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 7/8] DMA: Freescale: use spin_lock_bh instead of spin_lock_irqsave
References: <1397809071-5353-1-git-send-email-hongbo.zhang@freescale.com>
 <1397809071-5353-8-git-send-email-hongbo.zhang@freescale.com>
 <20140502165143.GI32284@intel.com>
In-Reply-To: <20140502165143.GI32284@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.1;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(428001)(24454002)(51704005)(479174003)(377454003)(189002)(199002)(86362001)(31966008)(44976005)(33656001)(76176999)(92726001)(46102001)(59896001)(74662001)(83506001)(83072002)(36756003)(85852003)(99396002)(80022001)(80976001)(65956001)(50466002)(4396001)(74502001)(64126003)(83322001)(20776003)(23756003)(87936001)(87266999)(19580395003)(79102001)(81342001)(77096999)(47776003)(81542001)(76482001)(54356999)(6806004)(101416001)(19580405001)(92566001)(65806001)(65816999)(50986999)(77982001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB394;H:tx30smr01.am.freescale.net;FPR:A454F836.AE364785.B6D06F87.20B0C02D.20190;MLV:sfv;PTR:gate-tx3.freescale.com;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 02015246A9
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 05/03/2014 12:51 AM, Vinod Koul wrote:
> On Fri, Apr 18, 2014 at 04:17:50PM +0800, hongbo.zhang@freescale.com wrote:
>> From: Hongbo Zhang <hongbo.zhang@freescale.com>
>>
>> The usage of spin_lock_irqsave() is a stronger locking mechanism than is
>> required throughout the driver. The minimum locking required should be used
>> instead. Interrupts will be turned off and context will be saved, it is
>> unnecessary to use irqsave.
>>
>> This patch changes all instances of spin_lock_irqsave() to spin_lock_bh(). All
>> manipulation of protected fields is done using tasklet context or weaker, which
>> makes spin_lock_bh() the correct choice.
>>
> This doesnt apply, perhpas due to depends on 6/8
>
So let's wait for the review result of 6/8.


