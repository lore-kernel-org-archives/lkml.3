Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751139AbaK0F43 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 00:56:29 -0500
Received: from mailout.micron.com ([137.201.242.129]:61614 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbaK0F42 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 00:56:28 -0500
From: bpqw <bpqw@micron.com>
To: Brian Norris <computersforpeace@gmail.com>
CC: Marek Vasut <marex@denx.de>, "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "shijie8@gmail.com" <shijie8@gmail.com>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>,
        "grmoore@altera.com" <grmoore@altera.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        bpqw <bpqw@micron.com>
Subject: RE: [V5 PATCH 1/1] driver:mtd:spi-nor: Add quad I/O support for
 Micron spi nor
Thread-Topic: [V5 PATCH 1/1] driver:mtd:spi-nor: Add quad I/O support for
 Micron spi nor
Thread-Index: AQHP+W8IEF9rxWxnKkG/zeWVIWCG6Zxz/eYA///KamA=
Date: Thu, 27 Nov 2014 05:55:43 +0000
Message-ID: <A765B125120D1346A63912DDE6D8B6315EE059@NTXXIAMBX02.xacn.micron.com>
References: <A765B125120D1346A63912DDE6D8B6315DCC46@NTXXIAMBX02.xacn.micron.com>
 <201409251211.57183.marex@denx.de>
 <A765B125120D1346A63912DDE6D8B6315DCDF1@NTXXIAMBX02.xacn.micron.com>
 <201409261046.07132.marex@denx.de>
 <A765B125120D1346A63912DDE6D8B6315EA24E@NTXXIAMBX02.xacn.micron.com>
 <20141126211240.GD21347@ld-irv-0074>
In-Reply-To: <20141126211240.GD21347@ld-irv-0074>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.84.5]
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-21132.004
X-TM-AS-Result: No--10.391500-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
x-mt-checkinternalsenderrule: True
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>First of all, can you fix your mail so that you have a proper 'From'?
>That should be your real name (not bpqw), so that it gives a proper patch author. 
>If you can't get your mail header to have the right 'From:' line, then it also works to begin your mail with:

Sorry for this confusion. This bpqw email is our software public mailbox dedicated to submit linux patch.
Because our personal email title include Chinese name, this will result to messy code in from item.
I have ever submit one patch many times by my personal mail, but I always didn't accept maintainer's response.
So I think, maybe my patch with Chinese name has been moved into maintainer's junk folder.

I don't know my mail from-field with Chinese name can or not be accepted, if can, 
I will submit next version patch by my personal mail.
 
>> This patch adds code which enables Quad I/O mode on Micron SPI NOR flashes.
>> 
>> For Micron SPI NOR flash,enabling or disabling quad I/O protocol is 
>> controlled by EVCR (Enhanced Volatile Configuration Register), Quad I/O protocol bit 7.
>> When EVCR bit 7 is reset to 0,the SPI NOR flash will operate in quad I/O mode.

>What's the difference between using EVCR and the ENTER QUAD I/O MODE
>(35h) command I see in some of your datasheets? Are both supported on all Micron quad I/O SPI NOR flash?

There is no difference between using EVCR and the ENTER QUAD I/O MODE command.
But, for some Micron spi nor, there no ENTER Quad I/O command(35h),such as n25q064.
for all current Micron spi nor, if it support quad I/O mode, Using EVCR definitely be supported.
So, we recommend that enable QUAD I/O mode by writing ECVR.
  

>Also, which SPI NOR is this enabled for? I don't see any Micron entries in spi_nor_ids[] which contain the SPI_NOR_QUAD_READ flag.

Yes, we now don't see any Micron entries in spi_nor_ids[] which contain the SPI_NOR_QUAD_READ flag.
But Micron spi nor in spi_nor_ids[] all support Quad I/O mode. maybe customer want to use default mode(extended I/O mode),
When submitted relevant patch, they didn't SPI_NOR_QUAD_READ flag in the spi_nor_ids[].
This patch is just for wanting to enable Micron Quad I/O mode.


>> Signed-off-by: bean huo <beanhuo@micron.com>
>> Acked-by: Marek Vasut <marex@denx.de>
>> ---
>>  v1-v2:
>> 	Modified to that capture wait_till_ready()
>> 	return value,if error,directly return its
>> 	the value.
>>  v2-v3:
>> 	Directly use the reurning error value of
>> 	read_reg and write_reg,instead of -EINVAL.
>>  v3-v4:
>> 	Modify commit logs that wraped into 80 columns
>>  v4-v5:
>> 	Rebuild new patch based on latest linux-mtd

>Please rebase on l2-mtd.git. Sorry if that wasn't clear earlier.

OK,I will rebase it and sumbit a new version. Thanks for your suggestion.

>> +		dev_err(nor->dev,
>> +			"error while writing EVCR register\n");

>Join the above two lines?

Will be fixed it in the next version.

>> +		return ret;
>> +	}
>> +
>> +	ret = wait_till_ready(nor);

>It's spi_nor_wait_till_ready(), now.

OK, will be fixed it.

>>  
>>  #define SR_QUAD_EN_MX		0x40	/* Macronix Quad I/O */
>>  
>> +#define EVCR_QUAD_EN_MICRON    0x80    /* Micron Quad I/O */

>Like with other register bitfields (SR, FSR), please place a comment above to describe the register, like:


OK, will be fixed it.

>Brian

All in all ,thanks for your response and valuable suggestions.
I will rebuild a new version, and submit it .

---Bean Huo---

