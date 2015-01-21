Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206AbbAUCNK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 21:13:10 -0500
Received: from mailout.micron.com ([137.201.242.129]:58694 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbbAUCNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 21:13:08 -0500
From: =?utf-8?B?UWkgV2FuZyDnjovotbcgKHFpd2FuZyk=?= <qiwang@micron.com>
To: Ezequiel Garcia <ezequiel.garcia@imgtec.com>,
        Brian Norris <computersforpeace@gmail.com>
CC: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        =?utf-8?B?RnJhbmsgTGl1IOWImOe+pCAoZnJhbmtsaXUp?= 
	<frankliu@micron.com>,
        =?utf-8?B?TWVsYW5pZSBaaGFuZyDlvKDnh5UgKG1lbGFuaWV6aGFuZyk=?= 
	<melaniezhang@micron.com>,
        =?utf-8?B?UGV0ZXIgUGFuIOa9mOagiyAocGV0ZXJwYW5kb25nKQ==?= 
	<peterpandong@micron.com>
Subject: RE: [PATCH 0/3] An alternative to SPI NAND
Thread-Topic: [PATCH 0/3] An alternative to SPI NAND
Thread-Index: AdAq2q78IdxvQLPKQ322Hb2GbRwNjAAAGruwAAAwq2D//3/+gP//ZSPQgADC/oD/+NfYMIAae92A//537tA=
Date: Wed, 21 Jan 2015 02:11:27 +0000
Message-ID: <71CF8D7F32C5C24C9CD1D0E02D52498A77151E62@NTXXIAMBX02.xacn.micron.com>
References: <87F60714EC601C4C83DFF1D2E3D390A04AB3F3@NTXXIAMBX02.xacn.micron.com>
 <20150108010257.GP9759@ld-irv-0074>
 <71CF8D7F32C5C24C9CD1D0E02D52498A7714DD2A@NTXXIAMBX02.xacn.micron.com>
 <54ADF90B.1070800@imgtec.com>
 <71CF8D7F32C5C24C9CD1D0E02D52498A7714F043@NTXXIAMBX02.xacn.micron.com>
 <54BE2F7B.60003@imgtec.com>
In-Reply-To: <54BE2F7B.60003@imgtec.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.84.5]
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-21268.000
X-TM-AS-Result: No--8.602400-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
x-mt-checkinternalsenderrule: True
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0L2DL4A016479

On 01/20/2015 6:36 PM, Ezequiel Garcia wrote:
>
>On 01/12/2015 12:10 PM, Qi Wang ç‹èµ· (qiwang) wrote:
>> Hi Ezequiel,
>>
>> On 01/08/2015 11:27 AM, Ezequiel Garcia wrote:
>>>
>>> Hi Qi Wang,
>>>
>>> On 01/07/2015 11:45 PM, Qi Wang ç‹èµ· (qiwang) wrote:
>>>> Hi Brian,
>>>>
>>>> On Thu, Jan 08, 2015 at 9:03:24AM +0000, Brian Norris wrote:
>>>>>
>>>>> On Thu, Jan 08, 2015 at 12:47:24AM +0000, Peter Pan æ½˜æ ‹ (peterpandong)
>>>>> wrote:
>>>>>> Documentation/devicetree/bindings/mtd/spi-nand.txt |   22 +
>>>>>> drivers/mtd/Kconfig                                |    2 +
>>>>>> drivers/mtd/Makefile                               |    1 +
>>>>>> drivers/mtd/spi-nand/Kconfig                       |    7 +
>>>>>> drivers/mtd/spi-nand/Makefile                      |    3 +
>>>>>> drivers/mtd/spi-nand/spi-nand-base.c               | 2034
>>>>> ++++++++++++++++++++
>>>>>> drivers/mtd/spi-nand/spi-nand-bbt.c                | 1279
>++++++++++++
>>>>>
>>>>> I can already tell by the diffstat that I don't like this. We probably
>>>>> don't need 3000 new lines of code for this, but we especially don't
>want
>>>>> to duplicate nand_bbt.c. It won't take a lot of work to augment
>>>>> nand_bbt.c to make it shareable. (I can whip that patch up if needed.)
>>>>
>>>> Yes, I agree with you, Nand_bbt.c do can be shared by Parallel NAND and
>>>> SPI NAND. Actually, we are working at this now. Will send patches to
>you
>>>> Once we finished it.
>>>>
>>>
>>> Thanks for the quick submission!
>>>
>>> However, Brian is right, this code duplication is a no go.
>>>
>>> Perhaps a more valid approach would be to first identify the code that
>>> needs to be shared in nand_bbt.c and nand_base.c, and export those
>>> symbols (or maybe do the required refactor).
>>
>> Yes, I agree Brian's suggestion in another mail.
>>
>> " The BBT code is something we definitely want to share, but it's
>actually
>> not very closely tied to nand_base.c, and it looks pretty easy to adapt
>> to any MTD that implements mtd_read_oob()/mtd_write_oob(). We'd just
>> need to parameterize a few relevant device details into a new nand_bbt
>> struct, rather than using struct nand_chip directly."
>>
>> To abstract a new nand_bbt struct instead of nand_chip to make SPI NAND
>> and parallel NAND can share nand_bbt.c file, I already begin to work on
>> this.
>>
>> For code shared in nand_base.c, I agree it would be better if we can find
>> a good method to share nand_base.c code between spi nand and parallel
>nand.
>> But frankly speaking, I'm not satisfied for the remap command method.
>This
>> method make code difficult to maintain when SPI NAND and Parallel NAND
>> evolve much differently in the future.
>>
>> Take some example,
>> If one new command (cache operation, multiple plane operation)
>implemented
>> in parallel NAND code, and is used in nand_read or nand_write, that will
>> cause maintainer to modify SPI NAND code to remap this new command,
>though
>> this modification probably could be slight. That means modification on
>> Parallel NAND flash need to consider SPI NAND as well.
>>
>> How do you think about this?
>>
>> For Peter Pan's patchset, if we do some modification to make nand_bbt.c
>to
>> make it shareable for Parallel and SPI NAND. The code line should be 2000.
>> I believe I can review this spi-nand-base.c to remove some redundant code
>> that may hundreds line. Is 1700 or 1800 code line is more acceptable?
>>
>> Let me know your opinions.
>>
>
>Sounds good.
>
>Do you still plan to maintain the spi-nand-base.c and spi-nand-device.c
>separation?	

Yes, still plan to maintain the spi-nand-base.c and spi-nand-device.c
separation. Abstract common code to spi-nand-base.c, and spi-nand-device.c is
used for realize the different function for different SPI NAND, such as ecc
layout, read ID etc.

Thanks
--
Qi Wang


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
