Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbaI2Aaz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 20:30:55 -0400
Received: from mailout.micron.com ([137.201.242.129]:64936 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741AbaI2Aax convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 20:30:53 -0400
From: bpqw <bpqw@micron.com>
To: Marek Vasut <marex@denx.de>
CC: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        "shijie8@gmail.com" <shijie8@gmail.com>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>,
        "grmoore@altera.com" <grmoore@altera.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/1 v2] driver:mtd:spi-nor: Add Micron quad I/O support
Thread-Topic: [PATCH 1/1 v2] driver:mtd:spi-nor: Add Micron quad I/O support
Thread-Index: AQHP222ppdcPMx7pY0GymPbv9gLaP5wXPlPg
Date: Mon, 29 Sep 2014 00:30:04 +0000
Message-ID: <A765B125120D1346A63912DDE6D8B6315DCF74@NTXXIAMBX02.xacn.micron.com>
References: <A765B125120D1346A63912DDE6D8B6315DCC46@NTXXIAMBX02.xacn.micron.com>
 <201409261046.07132.marex@denx.de>
 <A765B125120D1346A63912DDE6D8B6315DCED6@NTXXIAMBX02.xacn.micron.com>
 <201409290043.43750.marex@denx.de>
In-Reply-To: <201409290043.43750.marex@denx.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.84.5]
x-tm-as-product-ver: SMEX-10.0.0.4152-7.000.1014-20982.003
x-tm-as-result: No--40.817300-0.000000-31
x-tm-as-user-approved-sender: Yes
x-tm-as-user-blocked-sender: No
x-mt-checkinternalsenderrule: True
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> For Micron spi norflash,you can enable Quad spi transfer by clear 
>> EVCR(Enhanced Volatile Configuration Register) Quad I/O protocol bit.
>
>OK, this information is nice and all, but what does this patch do? I can't learn this information from the commit message as it is, can I ? 
>And , the purpose of the commit message is exactly to summarize the change the patch implements.


you don't understand what purpose of this patch! just as subject and commit message described,
it is for enable Micron Quad spi transfer mode.do you read the spi-nor.c file? please pay attention
to the set_quad_mode() function.by the way,I can add more commit message for it,but I think
it is redundant,don't need.

>> +static int micron_quad_enable(struct spi_nor *nor) {
>> +	int ret, val;
>> +
>> +	ret = nor->read_reg(nor, SPINOR_OP_RD_EVCR, &val, 1);
>> +	if (ret < 0) {
>> +		dev_err(nor->dev, "error %d reading EVCR\n", ret);
>> +		return -EINVAL;
>> +	}
>> +
>> +	write_enable(nor);
>> +
>> +	/* set EVCR ,enable quad I/O */
>> +	nor->cmd_buf[0] = val & ~EVCR_QUAD_EN_MICRON;
>> +	ret = nor->write_reg(nor, SPINOR_OP_WD_EVCR, nor->cmd_buf, 1, 0);
>> +	if (ret < 0) {
>> +		dev_err(nor->dev,
>> +			"error while writing EVCR register\n");
>> +		return -EINVAL;

>Why not just "return ret;" ?
>[...]

Ok,this is good,I will modify it in the next patch version.thanks.
