Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936451Ab3DJL1L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 07:27:11 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:59405 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523Ab3DJL1J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 07:27:09 -0400
From: "Bedia, Vaibhav" <vaibhav.bedia@ti.com>
To: "Poddar, Sourav" <sourav.poddar@ti.com>
CC: Kevin Hilman <khilman@linaro.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "rmk+kernel@arm.linux.org.uk" <rmk+kernel@arm.linux.org.uk>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        "Balbi, Felipe" <balbi@ti.com>, "Nayak, Rajendra" <rnayak@ti.com>
Subject: RE: [PATCHv3] driver: serial: prevent UART console idle on suspend
 while using "no_console_suspend"
Thread-Topic: [PATCHv3] driver: serial: prevent UART console idle on suspend
 while using "no_console_suspend"
Thread-Index: AQHOMf/UbV07E720zk6AHOHLsAfKmpjH5XwQgAYBjgCAAGAu44AAW/AAgABcfmD//9/uAIAAcfmw
Date: Wed, 10 Apr 2013 11:26:56 +0000
Message-ID: <B5906170F1614E41A8A28DE3B8D121433ED96C45@DBDE01.ent.ti.com>
References: <1365167733-28083-1-git-send-email-sourav.poddar@ti.com>
	<87mwtclvua.fsf@linaro.org> <516463D2.2070008@ti.com>
 <87obdnh6au.fsf@linaro.org> <516501A0.4000004@ti.com>
 <B5906170F1614E41A8A28DE3B8D121433ED96446@DBDE01.ent.ti.com>
 <51653450.2010200@ti.com>
In-Reply-To: <51653450.2010200@ti.com>
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

Hi Sourav,

On Wed, Apr 10, 2013 at 15:13:44, Poddar, Sourav wrote:
[...]
> Yes, had a look at that and found your situation similar to UART.
> 
> But how exactly this gets used, I mean I don't  see any drivers/ in mainline
> making use of this compatible string  "ti,am3352-ocmcram".  ?

OCMC clock is enabled during bootup (not sure whether that's the h/w
default or ROM does it) since the initial bootloader runs from there.
By marking the corresponding hwmod with HWMOD_INIT_NO_IDLE we leave the
clock running. Right now the sram code under arch/arm/plat-omap/ is what
manages the OCMC. I guess this needs to move somewhere under drivers/
and start managing the clocks. Even then we'll need a mechanism
to leave the clocks running as part of the kernel suspend process
since the assembly code which runs at the fag end of the suspend
process runs out of OCMC and hence we can't cut its clock.

On AM335x, the OCMC clock is cut to have PER power domain transition
but that's done in the WKUP-M3 firmware when going down. During the
wakeup sequence, WKUP-M3 re-enables the OCMC clock so that when the
kernel resumes the h/w state is same.

Regards,
Vaibhav
