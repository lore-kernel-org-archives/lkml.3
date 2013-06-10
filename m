Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035Ab3FJL0k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 07:26:40 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:41521 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751843Ab3FJL0i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 07:26:38 -0400
From: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
To: Kevin Hilman <khilman@linaro.org>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "zonque@gmail.com" <zonque@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "Bedia, Vaibhav" <vaibhav.bedia@ti.com>,
        "Rajashekhara, Sudhakar" <sudhakar.raj@ti.com>
Subject: RE: [PATCH 2/2] rtc: omap: add rtc wakeup support to alarm events
Thread-Topic: [PATCH 2/2] rtc: omap: add rtc wakeup support to alarm events
Thread-Index: AQHOXiYQaPj+OUHVHUilAFHAKAjcJ5ku1Q+A
Date: Mon, 10 Jun 2013 11:25:17 +0000
Message-ID: <1BAFE6F6C881BF42822005164F1491C33EC2E907@DBDE04.ent.ti.com>
References: <1369982005-8572-1-git-send-email-gururaja.hebbar@ti.com>
	<1369982005-8572-3-git-send-email-gururaja.hebbar@ti.com>
 <87a9nb2gjh.fsf@linaro.org>
In-Reply-To: <87a9nb2gjh.fsf@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 23:11:22, Kevin Hilman wrote:
> Hebbar Gururaja <gururaja.hebbar@ti.com> writes:
> 
> > On some platforms (like AM33xx), a special register (RTC_IRQWAKEEN)
> > is available to enable Wakeup feature for Alarm Events.
> >
> > Since new platforms/Boards are now added through DT only, this feature
> > is supported via DT property only.
> 
> > Platforms using such IP should add the property "ti,has_irq_wake_enb"
> > in rtc DT node.
> 
> This is a property of the IP, not the board.  Can't you detect this
> based on the revision of the IP?

Here is what I found out till now.

1. rtc-omap driver is used by Davinci, OMAP-1/2 & AM33xx SoC.

2. Only AM33xx soc rtc ip has revision register (& populated). Older OMAP
   Or davinci doesn't have this register.

3. AFAIK, this was the reason why Afzal used platform_device_id & 
   of_device_id->data method to detect new versions (commit
   9e0344dcc225fe1a0e8b8af9ff7df44ec4613580)


So now either 
a. I can follow the same method and add new member to omap_rtc_devtype & add a new compatible in 
 omap_rtc_of_match in rtc-omap.c

or

b. use dt property to indicate existence of above property.


Kindly let me know your opinion about the same.

> 
> Kevin
> 


Regards, 
Gururaja
