Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549AbaJ2Jhx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 05:37:53 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36122 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755726AbaJ2Jhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 05:37:48 -0400
Message-ID: <5450B545.1050905@ti.com>
Date: Wed, 29 Oct 2014 11:37:09 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Frans Klaver <fransklaver@gmail.com>, Rostislav Lisovy <lisovy@gmail.com>
CC: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Tony Lindgren <tony@atomide.com>, <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <michal.vokac@comap.cz>, <sojkam1@fel.cvut.cz>,
        Rostislav Lisovy <lisovy@merica.cz>
Subject: Re: [PATCH v3 2/2] mtd: nand: omap: Synchronize the access to the
 ECC engine
References: <542D46A1.9090905@ti.com>	<1412259404-5202-1-git-send-email-lisovy@merica.cz> <CAH6sp9M0VaH8-4NXcRNUYQS8Zuzbkra6zmgjSebjv8Awj6i0og@mail.gmail.com>
In-Reply-To: <CAH6sp9M0VaH8-4NXcRNUYQS8Zuzbkra6zmgjSebjv8Awj6i0og@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rostislav,

Sorry to miss this one.

On 10/29/2014 11:24 AM, Frans Klaver wrote:
> On Thu, Oct 2, 2014 at 4:16 PM, Rostislav Lisovy <lisovy@gmail.com> wrote:
>>
>> diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
>> index f0dcdb6..dfae46f 100644
>> --- a/drivers/mtd/nand/omap2.c
>> +++ b/drivers/mtd/nand/omap2.c
>> @@ -144,8 +144,13 @@ static u_char bch8_vector[] = {0xf3, 0xdb, 0x14, 0x16, 0x8b, 0xd2, 0xbe, 0xcc,
>>         0xac, 0x6b, 0xff, 0x99, 0x7b};
>>  static u_char bch4_vector[] = {0x00, 0x6b, 0x31, 0xdd, 0x41, 0xbc, 0x10};
>>
>> +/* Shared among all NAND instances to synchronize the access to the ECC Engine */
>> +struct nand_hw_control omap_gpmc_controller = {
>> +       .lock = __SPIN_LOCK_UNLOCKED(omap_gpmc_controller.lock),
>> +       .wq = __WAIT_QUEUE_HEAD_INITIALIZER(omap_gpmc_controller.wq),
>> +};
>> +
> 
> Any reason not to make this one static?
> 
Right. Apart from that, this patch looks good for me.
So after that change you can add my

Acked-by: Roger Quadros <rogerq@ti.com>

cheers,
-roger

