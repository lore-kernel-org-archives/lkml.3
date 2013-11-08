Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690Ab3KHHOd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 02:14:33 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:42488 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655Ab3KHHO2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 02:14:28 -0500
From: Caizhiyong <caizhiyong@hisilicon.com>
To: Brian Norris <computersforpeace@gmail.com>
CC: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        "Wanglin (Albert)" <albert.wanglin@hisilicon.com>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Karel Zak <kzak@redhat.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "Shmulik Ladkani" <shmulik.ladkani@gmail.com>
Subject: RE: [PATCH 2/2] mtd: cmdlinepart: use cmdline partition parser lib
Thread-Topic: [PATCH 2/2] mtd: cmdlinepart: use cmdline partition parser lib
Thread-Index: AQHO2oFrdZVowL3RlkWq6ldfMyBBbpoa6lug
Date: Fri, 8 Nov 2013 07:13:21 +0000
Message-ID: <C3050A4DBA34F345975765E43127F10F1C08B2A8@szxeml512-mbs.china.huawei.com>
References: <C3050A4DBA34F345975765E43127F10F1C0643B8@szxeml512-mbx.china.huawei.com>
	<20131020120603.GA18678@localhost>
	<C3050A4DBA34F345975765E43127F10F1C084C81@szxeml512-mbs.china.huawei.com>
	<20131105144328.fb5a6a1d423776b324771706@linux-foundation.org>
 <CAN8TOE8CoSsUSGaLG5Z_-xVLhhnm052Hp2Rqzs3Hr3cU8Lp-8g@mail.gmail.com>
In-Reply-To: <CAN8TOE8CoSsUSGaLG5Z_-xVLhhnm052Hp2Rqzs3Hr3cU8Lp-8g@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.67.223.36]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Nobody has had time to test this on MTD, it seems, and as such, I
> strongly recommend you do not force it through -mm. We are perfectly
> capable of merging it through the MTD tree if it ever gets proper
> vetting by people in MTD (not just on block devices), and I am well
> aware of this patch set's existence.
> 
> However, the patch really provides little to no benefit to the MTD
> subsystem at the moment, at the added cost of reviewing the small
> differences in parsing. For some reason, Cai decided to make small
> differences in the parser between drivers/mtd/cmdlinepart.c and
> block/cmdline-parser.c, and it is not obvious that these differences
> retain the same parsing. For instance, according to my code
> read-through, the block device parser seems to accept multiple
> partitions to be specified with "-" (meaning "fill the remaining
> device"). MTD already has code that rejects such a parser string
> outright.

The next '-' partition be ignore at function "cmdline_parts_set", and the client will get a right result.
Is there any other worry about '-' I don't know ?

> 
> So, I'd recommend one of the following:
> (1) We (MTD users) make more time to properly test this patch and post
> relevant results (i.e., tested partition strings) or
> (2) Somebody (Cai?) spend time to actually make block/cmdline-parser.c
> fully equivalent to the parser in drivers/mtd/cmdlinepart.c. That
> means it should be trivial to compare the two and say "yes, these are
> equivalent". That is currently not the case, AFAICT.

I understand your worry about, we use cmdlinepart many years.
I will spend time to make block/cmdline-parser.c fully equivalent to the
parser in drivers/mtd/cmdlinepart.c.

> 
> Without one of those two, I will give my NAK.
> 
> Brian
