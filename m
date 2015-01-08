Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861AbbAHD3P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 22:29:15 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:58802 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640AbbAHD3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 22:29:14 -0500
Message-ID: <54ADF90B.1070800@imgtec.com>
Date: Thu, 8 Jan 2015 00:27:07 -0300
From: Ezequiel Garcia <ezequiel.garcia@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: =?UTF-8?B?IlFpIFdhbmcg546L6LW3IChxaXdhbmcpIg==?= 
	<qiwang@micron.com>,
        Brian Norris <computersforpeace@gmail.com>
CC: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        =?UTF-8?B?IkZyYW5rIExpdSDliJjnvqQgKGZyYW5rbGl1KSI=?= 
	<frankliu@micron.com>,
        =?UTF-8?B?Ik1lbGFuaWUgWmhhbmcg5byg54eVIChtZWxhbmll?=
	 =?UTF-8?B?emhhbmcpIg==?= <melaniezhang@micron.com>,
        =?UTF-8?B?IlBldGVyIFA=?=
	 =?UTF-8?B?YW4g5r2Y5qCLIChwZXRlcnBhbmRvbmcpIg==?= 
	<peterpandong@micron.com>
Subject: Re: [PATCH 0/3] An alternative to SPI NAND
References: <87F60714EC601C4C83DFF1D2E3D390A04AB3F3@NTXXIAMBX02.xacn.micron.com> <20150108010257.GP9759@ld-irv-0074> <71CF8D7F32C5C24C9CD1D0E02D52498A7714DD2A@NTXXIAMBX02.xacn.micron.com>
In-Reply-To: <71CF8D7F32C5C24C9CD1D0E02D52498A7714DD2A@NTXXIAMBX02.xacn.micron.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.100.200.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Qi Wang,

On 01/07/2015 11:45 PM, Qi Wang 王起 (qiwang) wrote:
> Hi Brian,
> 
> On Thu, Jan 08, 2015 at 9:03:24AM +0000, Brian Norris wrote:
>>
>> On Thu, Jan 08, 2015 at 12:47:24AM +0000, Peter Pan 潘栋 (peterpandong)
>> wrote:
>>> Documentation/devicetree/bindings/mtd/spi-nand.txt |   22 +
>>> drivers/mtd/Kconfig                                |    2 +
>>> drivers/mtd/Makefile                               |    1 +
>>> drivers/mtd/spi-nand/Kconfig                       |    7 +
>>> drivers/mtd/spi-nand/Makefile                      |    3 +
>>> drivers/mtd/spi-nand/spi-nand-base.c               | 2034
>> ++++++++++++++++++++
>>> drivers/mtd/spi-nand/spi-nand-bbt.c                | 1279 ++++++++++++
>>
>> I can already tell by the diffstat that I don't like this. We probably
>> don't need 3000 new lines of code for this, but we especially don't want
>> to duplicate nand_bbt.c. It won't take a lot of work to augment
>> nand_bbt.c to make it shareable. (I can whip that patch up if needed.)
> 
> Yes, I agree with you, Nand_bbt.c do can be shared by Parallel NAND and
> SPI NAND. Actually, we are working at this now. Will send patches to you
> Once we finished it.
> 

Thanks for the quick submission!

However, Brian is right, this code duplication is a no go.

Perhaps a more valid approach would be to first identify the code that
needs to be shared in nand_bbt.c and nand_base.c, and export those
symbols (or maybe do the required refactor).

Then, separate the SPI NAND upper and lower logic (in a similar to my
proposal, which I still consider turned out to be clean).

These two things would lead to a simpler and smaller patchset. I also
suggest to cut off everything that we don't utterly need on a first
submission, so it's easier to review.
-- 
Ezequiel
