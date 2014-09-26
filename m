Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344AbaIZIkg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 04:40:36 -0400
Received: from mailout.micron.com ([137.201.242.129]:57768 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588AbaIZIk2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 04:40:28 -0400
From: bpqw <bpqw@micron.com>
To: Marek Vasut <marex@denx.de>
CC: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        "shijie8@gmail.com" <shijie8@gmail.com>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>,
        "grmoore@altera.com" <grmoore@altera.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/1] driver:mtd:spi-nor: Add Micron quad I/O support
Thread-Topic: [PATCH 1/1] driver:mtd:spi-nor: Add Micron quad I/O support
Thread-Index: AQHP2KkjagwG2in0R7+6ioZ2PHnYSpwTCHzA
Date: Fri, 26 Sep 2014 08:39:38 +0000
Message-ID: <A765B125120D1346A63912DDE6D8B6315DCDF1@NTXXIAMBX02.xacn.micron.com>
References: <A765B125120D1346A63912DDE6D8B6315DCC46@NTXXIAMBX02.xacn.micron.com>
 <201409251211.57183.marex@denx.de>
In-Reply-To: <201409251211.57183.marex@denx.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.84.5]
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-20976.005
X-TM-AS-Result: No--1.831700-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
x-mt-checkinternalsenderrule: True
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +	/* set EVCR ,enable quad I/O */
>> +	nor->cmd_buf[0] = val & ~EVCR_QUAD_EN_MICRON;
>> +	ret = nor->write_reg(nor, SPINOR_OP_WD_EVCR, nor->cmd_buf, 1, 0);
>> +	if (ret < 0) {
>> +		dev_err(nor->dev,
>> +			"error while writing EVCR register\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	if (wait_till_ready(nor))
>> +		return 1;

>Why does this not return proper error code or even better, return value from
>wait_till_ready() ?
>
>Other than that, there's nothing wrong with the patch I think.

Hi,Marek
Thanks for your review,you can find the same usage in the spi-nor.c.
Below method is OK? Or you can give me some suggestion.

if (wait_till_ready(nor))
	return - EINVAL;
