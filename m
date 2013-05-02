Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538Ab3EBGSC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 02:18:02 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:36348 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397Ab3EBGR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 02:17:59 -0400
From: "Gupta, Pekon" <pekon@ti.com>
To: Huang Shijie <b32955@freescale.com>
CC: "computersforpeace@gmail.com" <computersforpeace@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dedekind1@gmail.com" <dedekind1@gmail.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>
Subject: RE: [PATCH V4 5/9] mtd: replace the hardcode with the onfi_feature()
Thread-Topic: [PATCH V4 5/9] mtd: replace the hardcode with the
 onfi_feature()
Thread-Index: AQHOQmAouYQ3/CJ+jUWG0+OGq/54/JjujdmggAIc74CAALvK8P//g3WAgACHJoA=
Date: Thu, 2 May 2013 06:17:27 +0000
Message-ID: <20980858CB6D3A4BAE95CA194937D5E73E9C0A2F@DBDE04.ent.ti.com>
References: <1366967337-5534-1-git-send-email-b32955@freescale.com>
 <1366967337-5534-6-git-send-email-b32955@freescale.com>
 <20980858CB6D3A4BAE95CA194937D5E73E9BF544@DBDE04.ent.ti.com>
 <5181CC19.8000904@freescale.com>
 <20980858CB6D3A4BAE95CA194937D5E73E9C09FC@DBDE04.ent.ti.com>
 <51820127.5060003@freescale.com>
In-Reply-To: <51820127.5060003@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r426I7Fk001881

> äº 2013å¹´05æœˆ02æ—¥ 13:42, Gupta, Pekon å†™é“:
> >>>> -	*busw = 0;
> >>>> -	if (le16_to_cpu(p->features)&   1)
> >>>> -		*busw = NAND_BUSWIDTH_16;
> >>>> +
> >>>> +	*busw = (onfi_feature(chip)&   ONFI_FEATURE_16_BIT_BUS) ?
> >>>> +			NAND_BUSWIDTH_16 : 0;
> >>> Is this really needed ? you have already checked the 'onfi_version'
> >> above in
> >>> nand_flash_detect_onfi() ..
> >>> 	if (!chip->onfi_version) {
> >>> 		pr_info("%s: unsupported ONFI version: %d\n",
> >> __func__, val);
> >>> 		return 0;
> >>> 	}
> >>>
> >>>
> >> I think checking the onfi_version has no relationship with this patch. :)
> >> This patch is just replace the hardcode for 16-bit onfi nand check.
> >>
> > [Pekon]: [Patch 3/9]: add a helper to get the supported features
> > I mean, do you really need this helper function ?
> > +static inline int onfi_feature(struct nand_chip *chip)
> > +{
> > +       return chip->onfi_version ? le16_to_cpu(chip-
> >onfi_params.features) : 0;
> > + }
> >
> > Following change should have been enough..
> > *busw = (le16_to_cpu(p->features)&   ONFI_FEATURE_16_BIT_BUS) ?
> > 			NAND_BUSWIDTH_16 : 0;
> yes. for this function, it's enough.
> 
> But we may use the onfi_feature() in other places, such as some drivers.
> That's reason why i added this helper.
> 
[Pekon]: onfi_feature() is actually not useful unless someone re-scans the
param page again. And once the device is probed following should
be used to check if itâ€™s a x16 device.
If (chip->options & NAND_BUSWIDTH_16) 
My view-point was that the code should have less redundancy :-)

Anyways, Thanks for your other patch for reading extended_param_page.
I too wanted that ecc.codeword and ecc.strength should come from 
device's parameters. I'll ack them once, I test using my driver.


with regards, pekon
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
