Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529Ab3C0Ddd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 23:33:33 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:43056 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187Ab3C0Ddc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 23:33:32 -0400
Message-ID: <5152688A.70402@wwwdotorg.org>
Date: Tue, 26 Mar 2013 21:33:30 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Lubomir Rintel <lkundrak@v3.sk>
CC: linux-kernel@vger.kernel.org, Wim Van Sebroeck <wim@iguana.be>,
        linux-rpi-kernel@lists.infradead.org, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH] watchdog: Add Broadcom BCM2708 watchdog timer driver
References: <1363956907-5644-1-git-send-email-lkundrak@v3.sk>  <514D1273.8070902@wwwdotorg.org> <1364134324.2906.8.camel@hobbes.kokotovo>
In-Reply-To: <1364134324.2906.8.camel@hobbes.kokotovo>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2013 08:12 AM, Lubomir Rintel wrote:
> On Fri, 2013-03-22 at 20:24 -0600, Stephen Warren wrote:
> 
> Thank you for your response!
> 
>> On 03/22/2013 06:55 AM, Lubomir Rintel wrote:
>>> Signed-off-by: Lubomir Rintel <lkundrak at v3.sk>

>> A couple of general comments:
>>
>> 1)
>>
>> This driver touches the same registers that
>> arch/arm/mach-bcm2835/bcm2835.c uses to implement reboot and "power
>> off". Some co-ordination might be necessary.
>>
>> The implementation of bcm2835_power_off() could easily be moved into
>> this driver, to avoid some of the need for co-ordination.
>>
>> Moving bcm2835_restart() would be more tricky, since the ARM machine
>> descriptor needs a pointer to that function. I guess the kernel probably
>> ensures that none of the code in this watchdog driver is running by the
>> time bcm2835_restart() is called, although perhaps it'd be better to
>> have mach-bcm2835/bcm2835.c and this driver share a lock?
> 
> I need help here, I'm not sure what's the proper way to address this
> (whether to include the actual reboot code in the wdt driver or the
> platform driver).

I assume by "platform driver" you mean the code in
arch/arm/mach-bcm2835? The phrase "platform driver" usually refers to a
struct platform_driver, so that usage is a little unusual. I think you
would usually say "arch code" to refer to mach-bcm2835/, or something
like that!

> Is it okay to have the platform driver depend on watchdog timer?
> Is it okay for the platform driver not to reboot properly if the kernel
> is running without the wdt driver loaded?
> 
> (For now, I'll send a revised patch addressing the other issues so that
> it can be reviewed without addressing this yet.)

I guess what we should do here is merge the driver as you've posted it,
then later we can migrate any code from arch/arm/mach-bcm2835 into the
WDT driver.

IIRC, there certainly are some existing WDT drivers that implement the
reboot hook for their platforms, so it's probably OK to migrate that way
sometime, although indeed the issues you raise do deserve some thought.
