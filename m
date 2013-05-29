Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934959Ab3E2Dq3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 23:46:29 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:55388 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932888Ab3E2Dq0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 23:46:26 -0400
From: "B, Ravi" <ravibabu@ti.com>
To: "Balbi, Felipe" <balbi@ti.com>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v1 0/9] adding dual instance and usb-phy support for
 am335x platform
Thread-Topic: [PATCH v1 0/9] adding dual instance and usb-phy support for
 am335x platform
Thread-Index: AQHOV3r6wMyvlgFQ2UaKBAsz40ji1JkaX6AAgAEowcA=
Date: Wed, 29 May 2013 03:46:20 +0000
Message-ID: <6C6B28D4DC342643927BEAFCE8707BF63EAEB992@DBDE04.ent.ti.com>
References: <1369288888-8614-1-git-send-email-ravibabu@ti.com>
 <20130528173947.GF15794@arwen.pp.htv.fi>
In-Reply-To: <20130528173947.GF15794@arwen.pp.htv.fi>
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

Felipe

> Subject: Re: [PATCH v1 0/9] adding dual instance and usb-phy support for am335x platform

> Hi,

>On Thu, May 23, 2013 at 11:31:19AM +0530, Ravi Babu wrote:
>> This patch set series
>>         - adds dual musb instances support for am335x platform
>>         - adds phy-dsps-usb driver based on TI's gs70 driver
>>         - adds DT bindings for am33xx usb-phy
>> 	- removed references to usb-nop-xceiv from musb

>as Sergei pointed out, this would break some DaVinci/DA8xx platforms, so I'm dropping from it from my queue.

As I understand, already all musb glue platform drivers(dsps/davinci/da8xx) are changed to new usb_get_phy() API set.  
Currently the mainline code snippet as shown.

dsps/davinci/da8xx/xxx_musb_init() {
...
        usb_nop_xceiv_register() 
..
        musb->xceiv = usb_get_phy(USB_PHY_TYPE_USB2);
        if (IS_ERR_OR_NULL(musb->xceiv)) {
                ret = -EPROBE_DEFER;
                goto fail;
        }
..
}
Because of this all glue xxx_musb_init() will fail to get the phy without the phy-bindings for each controller. 
Without this patch series am335x musb will fail to get usb_phy(). Similarly phy support to be added for all davinci/da8xx
platform also. The usb_nop_xciev_xx() is dummy unused API here and hence removed from all glue in this patch series.

1) dsps platforms (am335x/dm81xx) series uses TI gs70 based phy 
	This patch adds support for ths dsps phy driver at drivers/usb/phy/usb-dsps-phy.c 
2) omapl13x/da8xx series of soc uses different phy
	Separate phy driver need to be added at drivers/usb/phy/usb-da8xx-phy.c
3) similarly all davinci series of soc uses separate TI-phy 
	Separate phy driver need to added at drivers/usb/phy/usb-davinci-phy.c

The bindings of the respective usb-phy and controller need to done in DT or non-DT way.  
I can add usb-phy support for davinci/da8xx platform in similar way.

---
Ravi B
