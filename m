Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863Ab3KEXre (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 18:47:34 -0500
Received: from mail-vb0-f43.google.com ([209.85.212.43]:37389 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755719Ab3KEXrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 18:47:32 -0500
MIME-Version: 1.0
In-Reply-To: <20131105144328.fb5a6a1d423776b324771706@linux-foundation.org>
References: <C3050A4DBA34F345975765E43127F10F1C0643B8@szxeml512-mbx.china.huawei.com>
	<20131020120603.GA18678@localhost>
	<C3050A4DBA34F345975765E43127F10F1C084C81@szxeml512-mbs.china.huawei.com>
	<20131105144328.fb5a6a1d423776b324771706@linux-foundation.org>
Date: Tue, 5 Nov 2013 15:47:31 -0800
Message-ID: <CAN8TOE8CoSsUSGaLG5Z_-xVLhhnm052Hp2Rqzs3Hr3cU8Lp-8g@mail.gmail.com>
Subject: Re: [PATCH 2/2] mtd: cmdlinepart: use cmdline partition parser lib
From: Brian Norris <computersforpeace@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Caizhiyong <caizhiyong@hisilicon.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        "Wanglin (Albert)" <albert.wanglin@hisilicon.com>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Karel Zak <kzak@redhat.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 5, 2013 at 2:43 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Tue, 22 Oct 2013 13:14:17 +0000 Caizhiyong <caizhiyong@hisilicon.com> wrote:
>
>> In the previous version, adjust the cmdline parser code to library-style
>> code, and move it to a separate file "block/cmdline-parser.c", we can use
>> it in some client code. there is no any functionality change in the adjusting.
>>
>> this patch use cmdline parser lib.
>>
>> For further information, see "https://lkml.org/lkml/2013/8/6/550"
>
> Thanks for doing this.  Could we please get some acked-by's or,
> preferably, tested-by's from the MTD people?

Nobody has had time to test this on MTD, it seems, and as such, I
strongly recommend you do not force it through -mm. We are perfectly
capable of merging it through the MTD tree if it ever gets proper
vetting by people in MTD (not just on block devices), and I am well
aware of this patch set's existence.

However, the patch really provides little to no benefit to the MTD
subsystem at the moment, at the added cost of reviewing the small
differences in parsing. For some reason, Cai decided to make small
differences in the parser between drivers/mtd/cmdlinepart.c and
block/cmdline-parser.c, and it is not obvious that these differences
retain the same parsing. For instance, according to my code
read-through, the block device parser seems to accept multiple
partitions to be specified with "-" (meaning "fill the remaining
device"). MTD already has code that rejects such a parser string
outright.

So, I'd recommend one of the following:
(1) We (MTD users) make more time to properly test this patch and post
relevant results (i.e., tested partition strings) or
(2) Somebody (Cai?) spend time to actually make block/cmdline-parser.c
fully equivalent to the parser in drivers/mtd/cmdlinepart.c. That
means it should be trivial to compare the two and say "yes, these are
equivalent". That is currently not the case, AFAICT.

Without one of those two, I will give my NAK.

Brian
