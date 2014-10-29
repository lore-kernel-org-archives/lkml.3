Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552AbaJ2TUC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 15:20:02 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:57474 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455AbaJ2TUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 15:20:00 -0400
Message-ID: <54513DDC.2020700@amacapital.net>
Date: Wed, 29 Oct 2014 12:19:56 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Bastien Nocera <hadess@hadess.net>, Pavel Machek <pavel@ucw.cz>
CC: John Stultz <john.stultz@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: A desktop environment[1] kernel wishlist
References: <1413881397.30379.7.camel@hadess.net>	 <CANcMJZA=7FNNCrMpz-mC4FaJMKi8hEhqGtO_bv7iJdWVC_GpWA@mail.gmail.com>	 <1413911644.30379.12.camel@hadess.net>	 <CALAqxLURBHdrprCZzUiXdO6M7sjbwawxyDQpoG1-HWRGBvaMjg@mail.gmail.com>	 <1413914978.30379.14.camel@hadess.net> <20141027092804.GB9807@amd> <1414420292.30379.55.camel@hadess.net>
In-Reply-To: <1414420292.30379.55.camel@hadess.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2014 07:31 AM, Bastien Nocera wrote:
> On Mon, 2014-10-27 at 10:28 +0100, Pavel Machek wrote:
>> Hi!
>>
>>>> I suspect wakeup type reporting is maybe not the best way to go about
>>>> this, since there may be a number of causes for wakeups and they can
>>>> arrive closely together in different orders, which can result in
>>>> races.
>>>>
>>>> For instance, if the machine suspends, and sets an alarm to be woken
>>>> up at midnight to do a backup, if the user resumes their laptop at
>>>> 11:59:59, should the backup still proceed at midnight?
>>>
>>> No. And I would expect that we would get a wake up type of "power
>>> button" or "lid open" in this case.
>>
>> I believe you should really use "is lid opened or AC or dock
>> connected" to determine if it was automatic resume or not. It should
>> work better and you can actually do it today.
> 
> There's no LID or docks on a tablet.

For a tablet, isn't the relevant piece of information whether the power
button was recently pressed, not whether the power button caused the wakeup?

It would be really annoying if there were a window around every RTC
wakeup during which pressing the power button didn't actually turn on
the screen.

--Andy
