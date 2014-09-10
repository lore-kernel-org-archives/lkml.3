Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927AbaIJQz0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 12:55:26 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:14445 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbaIJQzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 12:55:24 -0400
Message-ID: <54108277.9000100@atmel.com>
Date: Wed, 10 Sep 2014 18:55:19 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Johan Hovold <johan@kernel.org>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        "Alexandre Belloni" <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Alessandro Zummo <a.zummo@towertech.it>, <rtc-linux@googlegroups.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] rtc: at91sam9: add DT bindings documentation
References: <1409733934-14465-1-git-send-email-boris.brezillon@free-electrons.com> <1409733934-14465-6-git-send-email-boris.brezillon@free-electrons.com> <20140910121424.GG2974@localhost> <20140910152019.111c4c01@bbrezillon> <20140910150702.GK2974@localhost> <20140910173114.593dd132@bbrezillon> <20140910155236.GL2974@localhost>
In-Reply-To: <20140910155236.GL2974@localhost>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2014 17:52, Johan Hovold :
> On Wed, Sep 10, 2014 at 05:31:14PM +0200, Boris BREZILLON wrote:
>> On Wed, 10 Sep 2014 17:07:02 +0200
>> Johan Hovold <johan@kernel.org> wrote:
> 
>>> Yes, this essentially what I suggested in the thread (and my last reply)
>>> and relying on syscon rather than a custom driver seems like a good
>>> idea. It would allow early access to the registers too with the recently
>>> proposed changes. It would not guarantee any kind of exclusivity,
>>> though, but I guess that's tolerable?
>>
>> Yep, that's one of the concern I had with the syscon/regmap
>> approach :-(, but I guess I'll give this solution a try and post a new
>> version of this series ;-).
> 
> Perhaps we should see what Nicolas and Jean-Christophe says before
> rushing into anything (again). ;)

I said and say it again: keep it simple: if gpbr 0 is used by bootloader
to pass information about the boot media, use gpbr 1, without protection
without anything fancy, please.

atmel,at91-rtt-as-rtc-gpbr = <1>;
is good for me.

We can decide to keep the DT binding as "unstable" and see what happen
in one year from now (I suspect nothing will happen). The result is that
we will have a simple update of this driver without new API or new
sub-system to learn and maintain.

So, all in all, I would just take what Johan or Boris did, and go with
this, now!


> I remember J-C considered loosing track of what was using a particular
> backup register to be a regression. But I guess you can't have it both
> ways (e.g. if you also want the early access soon provided by syscon).
> 
> I'll refresh my rtt and gmbr-node patches meanwhile, as they should be
> needed in some form at least.
> 
>> Can we just leave the rtt as an rtc problem on the side for now and bind
>> it to the rtc-at91sam9 driver.
>>
>> If we ever decide to add a new driver using the RTT for another purpose
>> we will still be able to reference the RTT block like this (and keep
>> the existing rtt node definition):
>>
>> rtt-based-rtc {
>> 	compatible = "atmel,rtt-rtc";
>> 	atmel,rtt = <&rtt>;
>> 	atmel,time-reg = <&gpbr 0x0>;
>> }
> 
> But why not do this from the start?
> 
>> rtt-based-xdev {
>> 	compatible = "atmel,rtt-xdev";
>> 	atmel,rtt = <&rtt>;
>> 	/*...*/
>> }
> 
> Johan
> 
> 


-- 
Nicolas Ferre
