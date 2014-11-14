Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934699AbaKNCGz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 21:06:55 -0500
Received: from mailout.micron.com ([137.201.242.129]:41610 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933518AbaKNCGy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 21:06:54 -0500
From: bpqw <bpqw@micron.com>
To: Graham Moore <grmoore@opensource.altera.com>,
        Brian Norris <computersforpeace@gmail.com>
CC: Marek Vasut <marex@denx.de>, "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "shijie8@gmail.com" <shijie8@gmail.com>, bpqw <bpqw@micron.com>
Subject: RE: [V5 PATCH 1/1] driver:mtd:spi-nor: Add quad I/O support for
 Micron spi nor
Thread-Topic: [V5 PATCH 1/1] driver:mtd:spi-nor: Add quad I/O support for
 Micron spi nor
Thread-Index: AQHP+W8IEF9rxWxnKkG/zeWVIWCG6Zxb9qNUgAA3tsCAAxFVgIAAJg1g
Date: Fri, 14 Nov 2014 02:06:04 +0000
Message-ID: <A765B125120D1346A63912DDE6D8B6315EBFB7@NTXXIAMBX02.xacn.micron.com>
References: <A765B125120D1346A63912DDE6D8B6315DCC46@NTXXIAMBX02.xacn.micron.com>
 <201409251211.57183.marex@denx.de>
 <A765B125120D1346A63912DDE6D8B6315DCDF1@NTXXIAMBX02.xacn.micron.com>
 <201409261046.07132.marex@denx.de>
 <A765B125120D1346A63912DDE6D8B6315EA24E@NTXXIAMBX02.xacn.micron.com>
 <54613259.4070903@opensource.altera.com>
 <alpine.DEB.2.02.1411111336010.1356@lava-test-server>
 <A765B125120D1346A63912DDE6D8B6315EB0DA@NTXXIAMBX02.xacn.micron.com>
 <alpine.DEB.2.02.1411130945300.19890@lava-test-server>
In-Reply-To: <alpine.DEB.2.02.1411130945300.19890@lava-test-server>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.84.5]
x-tm-as-product-ver: SMEX-10.0.0.4152-7.000.1014-21102.001
x-tm-as-result: No--37.232500-0.000000-31
x-tm-as-user-approved-sender: Yes
x-tm-as-user-blocked-sender: No
x-mt-checkinternalsenderrule: True
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> This maybe your spi controller is still extended mode, Once EVCR bit 7 
>> is set to 0, the spi nor device will operate in quad I/O.Command-address-data line is 4-x-4.
>> So after send WRITE EVCR command , spi controller also  must transfer 
>> to quad I/O Mode,and set its Command-address-data line also Should be 4-x-4 .

>Thanks, this helped.  I added some code to snoop the command stream for WRITE EVCR with quad mode, 
>and then set up the quad mode in the controller.  Seems kinda ugly, but working now.

>-Graham

Yes ,if enable spi nor Quad I/O, firstly, must check spi controller if support Quad I/O protocol,
and after enable spi nor Quad I/O mode ,spi controller also must be transferred to Quad I/O protocol.
Their two side must be matched together.
Maybe spi controller can do this changes.

Hi,Brian

Can you give me some tips about this patch? Thanks!

-Bean Huo
