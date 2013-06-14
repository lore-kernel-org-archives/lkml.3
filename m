Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479Ab3FNLkA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 07:40:00 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:51721 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300Ab3FNLj6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 07:39:58 -0400
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
Thread-Index: AQHOaIRiaPj+OUHVHUilAFHAKAjcJ5k1FBOw
Date: Fri, 14 Jun 2013 11:38:41 +0000
Message-ID: <1BAFE6F6C881BF42822005164F1491C33EC35C68@DBDE04.ent.ti.com>
References: <1369982005-8572-1-git-send-email-gururaja.hebbar@ti.com>
	<1369982005-8572-3-git-send-email-gururaja.hebbar@ti.com>
	<87a9nb2gjh.fsf@linaro.org>
	<1BAFE6F6C881BF42822005164F1491C33EC34679@DBDE04.ent.ti.com>
 <87k3lxabyg.fsf@linaro.org>
In-Reply-To: <87k3lxabyg.fsf@linaro.org>
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

On Fri, Jun 14, 2013 at 03:51:43, Kevin Hilman wrote:
> "Hebbar, Gururaja" <gururaja.hebbar@ti.com> writes:
> 
> > Hi Kevin,
> >
> > On Mon, Jun 10, 2013 at 16:55:17, Hebbar, Gururaja wrote:
> >> On Fri, May 31, 2013 at 23:11:22, Kevin Hilman wrote:
> >> > Hebbar Gururaja <gururaja.hebbar@ti.com> writes:
> >> > 
> >> > > On some platforms (like AM33xx), a special register (RTC_IRQWAKEEN)
> >> > > is available to enable Wakeup feature for Alarm Events.
> >> > >
> >> > > Since new platforms/Boards are now added through DT only, this feature
> >> > > is supported via DT property only.
> >> > 
> >> > > Platforms using such IP should add the property "ti,has_irq_wake_enb"
> >> > > in rtc DT node.
> >> > 
> >> > This is a property of the IP, not the board.  Can't you detect this
> >> > based on the revision of the IP?
> >> 
> >> Here is what I found out till now.
> >> 
> >> 1. rtc-omap driver is used by Davinci, OMAP-1/2 & AM33xx SoC.
> >> 
> >> 2. Only AM33xx soc rtc ip has revision register (& populated). Older OMAP
> >>    Or davinci doesn't have this register.
> >> 
> >> 3. AFAIK, this was the reason why Afzal used platform_device_id & 
> >>    of_device_id->data method to detect new versions (commit
> >>    9e0344dcc225fe1a0e8b8af9ff7df44ec4613580)
> >> 
> >> 
> >> So now either 
> >> a. I can follow the same method and add new member to omap_rtc_devtype & add a new compatible in 
> >>  omap_rtc_of_match in rtc-omap.c
> >> 
> >> or
> >> 
> >> b. use dt property to indicate existence of above property.
> >> 
> >> 
> >> Kindly let me know your opinion about the same.
> >
> > Any update on this. I have patch ready for both the choices. Waiting for your ok to send
> 
> I think (a) is better.

Ok. I will add the property using a new DT compatibility.


> 
> The driver should always do a device_init_wakeup(dev, true), *except*
> for devtypes that don't have this feature.

"wakeup capable" and "irq-wake-enable-for-alarm-event" are different

For "irq-wake-enable-for-alarm-event", I will add a new DT compability.

However, wakeup capable notification is done in another patch using the a 
DT property "ti,wakeup_capable".

The reason for using a dt property is specified below


	commit fa5b07820fe3a0fc06ac368516e71f10a59b9539
	Author: Sekhar Nori <nsekhar@ti.com>
	Date:   Wed Oct 27 15:33:05 2010 -0700

	rtc: omap: let device wakeup capability be configured from chip
	init logic

	The rtc-omap driver currently hardcodes the RTC wakeup
	capability to be "not capable".  While this seems to be true for
	existing OMAP1 boards which are not wired for this, the
	DA850/OMAP-L138 SoC, the RTC can always be wake up source from
	its "deep sleep" mode.


So I cannot directly add device_init_wakeup(dev, true), inside driver code.
So, I added a DT property




> 
> Kevin
> 
> 


Regards, 
Gururaja
