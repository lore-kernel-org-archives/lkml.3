Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964Ab3FDJtV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 05:49:21 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:46888 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151Ab3FDJtU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 05:49:20 -0400
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
Subject: RE: [PATCH 1/2] rtc: omap: add option to indicate wakeup support
 through DT
Thread-Topic: [PATCH 1/2] rtc: omap: add option to indicate wakeup support
 through DT
Thread-Index: AQHOXib/BNPfWUFEYEK7eB5cu8HcGZklUozg
Date: Tue, 4 Jun 2013 09:48:25 +0000
Message-ID: <1BAFE6F6C881BF42822005164F1491C33EC22315@DBDE04.ent.ti.com>
References: <1369982005-8572-1-git-send-email-gururaja.hebbar@ti.com>
	<1369982005-8572-2-git-send-email-gururaja.hebbar@ti.com>
 <87wqqf11nw.fsf@linaro.org>
In-Reply-To: <87wqqf11nw.fsf@linaro.org>
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

On Fri, May 31, 2013 at 23:18:03, Kevin Hilman wrote:
> Hebbar Gururaja <gururaja.hebbar@ti.com> writes:
> 
> > Even though RTC-IP is wakeup capable, Not all Boards support it.
> >
> > For example
> > The rtc alarm wakeup is available in rtc-ip since omap1 days but alarm
> > was not wired properly in previous ompa1 boards.
> >
> > 	commit fa5b07820fe3a0fc06ac368516e71f10a59b9539
> > 	Author: Sekhar Nori <nsekhar@ti.com>
> > 	Date:   Wed Oct 27 15:33:05 2010 -0700
> >
> > 	rtc: omap: let device wakeup capability be configured from chip
> > 	init logic
> >
> > 	The rtc-omap driver currently hardcodes the RTC wakeup
> > 	capability to be "not capable".  While this seems to be true for
> > 	existing OMAP1 boards which are not wired for this, the
> > 	DA850/OMAP-L138 SoC, the RTC can always be wake up source from
> > 	its "deep sleep" mode.
> >
> > Current rtc-omap driver expects the rtc module wake-up capabilities to
> > be set up by board specific code. However, in case of DT, this is not
> > possible.
> >
> > So, add a DT property "ti,wakeup_capable" to indicate that the module is
> > wake-up capable.
> 
> Why is this a TI-specific property?  

May be I am wrong but isn't this driver used only be TI SoC (Davinci, OMAP ...)

> 
> Also, I think we can do this without a new DT property.Did you see this
> patch from Tony which is already queued for v3.11:
> 
>     http://marc.info/?l=linux-omap&m=136917244530612&w=2

AFAIK, all boards that use twl rtc IP by default support rtc wakeup.

However, as mentioned in the commit message not all boards that uses
OMAP rtc IP supports rtc wake up (due to somoe wiring issue).
Hence I am adding a new DT property for this.

> 
> I think this is the right way to go.  Platforms that don't want/need
> wakeup support can disable it from userspace via:
> 
>     echo disabled > /sys/devices/.../power/wakeup

Hmmm. Debatable. Let me get some more info about this and come back

> 
> Kevin
> 
> 


Regards, 
Gururaja
