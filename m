Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759423Ab3FMWVt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 18:21:49 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:33838 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757899Ab3FMWVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 18:21:47 -0400
From: Kevin Hilman <khilman@linaro.org>
To: "Hebbar\, Gururaja" <gururaja.hebbar@ti.com>
Cc: "akpm\@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux\@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "zonque\@gmail.com" <zonque@gmail.com>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "grant.likely\@linaro.org" <grant.likely@linaro.org>,
        "rob.herring\@calxeda.com" <rob.herring@calxeda.com>,
        "rob\@landley.net" <rob@landley.net>,
        "a.zummo\@towertech.it" <a.zummo@towertech.it>,
        "devicetree-discuss\@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc\@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rtc-linux\@googlegroups.com" <rtc-linux@googlegroups.com>,
        "davinci-linux-open-source\@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "Bedia\, Vaibhav" <vaibhav.bedia@ti.com>,
        "Rajashekhara\, Sudhakar" <sudhakar.raj@ti.com>
Subject: Re: [PATCH 2/2] rtc: omap: add rtc wakeup support to alarm events
References: <1369982005-8572-1-git-send-email-gururaja.hebbar@ti.com>
	<1369982005-8572-3-git-send-email-gururaja.hebbar@ti.com>
	<87a9nb2gjh.fsf@linaro.org>
	<1BAFE6F6C881BF42822005164F1491C33EC34679@DBDE04.ent.ti.com>
Date: Thu, 13 Jun 2013 15:21:43 -0700
In-Reply-To: <1BAFE6F6C881BF42822005164F1491C33EC34679@DBDE04.ent.ti.com>
	(Gururaja Hebbar's message of "Thu, 13 Jun 2013 09:39:54 +0000")
Message-ID: <87k3lxabyg.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Hebbar, Gururaja" <gururaja.hebbar@ti.com> writes:

> Hi Kevin,
>
> On Mon, Jun 10, 2013 at 16:55:17, Hebbar, Gururaja wrote:
>> On Fri, May 31, 2013 at 23:11:22, Kevin Hilman wrote:
>> > Hebbar Gururaja <gururaja.hebbar@ti.com> writes:
>> > 
>> > > On some platforms (like AM33xx), a special register (RTC_IRQWAKEEN)
>> > > is available to enable Wakeup feature for Alarm Events.
>> > >
>> > > Since new platforms/Boards are now added through DT only, this feature
>> > > is supported via DT property only.
>> > 
>> > > Platforms using such IP should add the property "ti,has_irq_wake_enb"
>> > > in rtc DT node.
>> > 
>> > This is a property of the IP, not the board.  Can't you detect this
>> > based on the revision of the IP?
>> 
>> Here is what I found out till now.
>> 
>> 1. rtc-omap driver is used by Davinci, OMAP-1/2 & AM33xx SoC.
>> 
>> 2. Only AM33xx soc rtc ip has revision register (& populated). Older OMAP
>>    Or davinci doesn't have this register.
>> 
>> 3. AFAIK, this was the reason why Afzal used platform_device_id & 
>>    of_device_id->data method to detect new versions (commit
>>    9e0344dcc225fe1a0e8b8af9ff7df44ec4613580)
>> 
>> 
>> So now either 
>> a. I can follow the same method and add new member to omap_rtc_devtype & add a new compatible in 
>>  omap_rtc_of_match in rtc-omap.c
>> 
>> or
>> 
>> b. use dt property to indicate existence of above property.
>> 
>> 
>> Kindly let me know your opinion about the same.
>
> Any update on this. I have patch ready for both the choices. Waiting for your ok to send

I think (a) is better.

The driver should always do a device_init_wakeup(dev, true), *except*
for devtypes that don't have this feature.

Kevin

