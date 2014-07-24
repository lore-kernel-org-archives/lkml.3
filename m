Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934329AbaGXHzo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 03:55:44 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:57394 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934045AbaGXHzm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 03:55:42 -0400
From: "Gupta, Pekon" <pekon@ti.com>
To: Brian Norris <computersforpeace@gmail.com>, bpqw <bpqw@micron.com>
CC: "ron@debian.org" <ron@debian.org>,
        "artem.bityutskiy@linux.intel.com" <artem.bityutskiy@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "b32955@freescale.com" <b32955@freescale.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "ezequiel.garcia@free-electrons.com" 
	<ezequiel.garcia@free-electrons.com>,
        "u.kleine-koenig@pengutronix.de" <u.kleine-koenig@pengutronix.de>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>
Subject: RE: Subject: [PATCH 1/1] mtd:nand:fix nand_lock/unlock() function
Thread-Topic: Subject: [PATCH 1/1] mtd:nand:fix nand_lock/unlock() function
Thread-Index: AQHPpt7U8KJkpY2vFkSsKRBDHDBNlZuu2QdQ
Date: Thu, 24 Jul 2014 07:54:41 +0000
Message-ID: <20980858CB6D3A4BAE95CA194937D5E73EB068AB@DBDE04.ent.ti.com>
References: <CB9F11E856CFD04BB18EC1C68F2598931B1112@NTXXIAMBX01.xacn.micron.com>
 <20140724012730.GA3711@ld-irv-0074>
In-Reply-To: <20140724012730.GA3711@ld-irv-0074>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From: Brian Norris
>
>Hi White,
>
>On Thu, Jul 24, 2014 at 01:00:01AM +0000, bpqw wrote:
>> Do nand reset before write protect check
>> If we want to check the WP# low or high through STATUS READ and check bit 7,
>> we must reset the device, other operation (eg.erase/program a locked block) can
>> also clear the bit 7 of status register.
>>
>> Signed-off-by: White Ding <bpqw@micron.com>
>> ---
>>  drivers/mtd/nand/nand_base.c |   18 ++++++++++++++++++
>>  1 file changed, 18 insertions(+)
>>
>> diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
>> index 41167e9..22dd3aa 100644
>> --- a/drivers/mtd/nand/nand_base.c
>> +++ b/drivers/mtd/nand/nand_base.c
>> @@ -965,6 +965,15 @@ int nand_unlock(struct mtd_info *mtd, loff_t ofs, uint64_t len)
>[...]
>> @@ -1015,6 +1024,15 @@ int nand_lock(struct mtd_info *mtd, loff_t ofs, uint64_t len)
>[...]
>
>I don't see any in-tree users of nand_{un,}lock(). I recently caught a
>bug in nand_lock() via inspection (still need to send a fix), but I was
>considering dropping the functions entirely.
>
>I presume you have some out-of-tree driver that uses these functions,
>then?
>
Please don't drop nand_{unlock, lock} interfaces at-least for sometime.
I remember there were some users trying to use these for secure
applications. But due to lack of proper userland utility support they
probably dropped the idea.
Good to have this added as part of mtd-utils package, and then let it live
for some more time.


with regards, Pekon
