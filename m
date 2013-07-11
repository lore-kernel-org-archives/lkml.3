Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411Ab3GKWoA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 18:44:00 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:64458 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756391Ab3GKWn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 18:43:59 -0400
Message-ID: <51DF354D.6050401@googlemail.com>
Date: Fri, 12 Jul 2013 00:44:29 +0200
From: Ulrich Prinz <ulrich.prinz@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        John Stultz <john.stultz@linaro.org>, Jamie Iles <jamie@jamieiles.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        Grant Likely <grant.likely@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH 9/9] clocksource: dw_apb_timer: special variant for rockchip
 rk3188 timers
References: <201307060051.09716.heiko@sntech.de> <201307060056.29370.heiko@sntech.de> <alpine.DEB.2.02.1307060153110.32106@ionos.tec.linutronix.de> <51D87E04.3060704@googlemail.com> <alpine.DEB.2.02.1307062233480.32106@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1307062233480.32106@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey guys,

according the dw_apb_timer I need your statement...

Am 06.07.2013 23:00, schrieb Thomas Gleixner:
> Ulrich,
> 
> On Sat, 6 Jul 2013, Ulrich Prinz wrote:
> 
>> I got the message. With modifying the existing driver to support more
>> function pointers in its system struct and assigning them at the
>> beginning, and using them on runtime, these quirks are obsolete.
> 
> Correct.
>  
>>
>> Adding more function pointers to a system relevant structure, doubling
>> the number of functions and such didn't look non-invasive to me.
> 
> Well, it always depends. If there is a single place to deal with some
> oddball hardware, a flag is often the simplest way to go.
> 
> If you have to add 10 conditionals in several functions then in a
> first step converting the existing implementation into function
> pointer calls and then in the next step providing new implementations
> for your hardware is most of the time simpler and cleaner.
> 
>> But, I totally agree with your argumentation and I even wanted to do it
>> in the way you explained in your replies. Just the courage was missing I
>> guess :)
> 
> Gut feelings are often a better guidance than our self-doubting
> intellect. :)

You can look at my github repo for the new driver, rewriting the
interface as discussed above:
https://github.com/Astralix/linux-rockchip/blob/wip/dw_timer64/drivers/clocksource/dw_apb_timer.c

Summary: It is a 90% rewrite of the complete dw_apb_timer.c and
modifications of dw_apb_timer_of.c and dw_apb_timer.h and the related
x86 drivers are needed.
And after that the 64bit functionality is still not given as the
existing structures do not take it. But for now scheduler doesn't
support 64bit either, I guess.

The drivers local struct stays, but instead of carrying pointers to
registers it now consists of function pointers. This could be used to
fit almost any kind of timer.

I would really appreciate your comments. Sure I need to clean up a bit,
but we're still testing. But before investing more time into that code I
need you comment if I should continue or split to a separate driver for
these kind of timers.

Thanks for any comments

Regards
	Ulrich

