Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758550Ab3FTXLN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 19:11:13 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:51340 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754296Ab3FTXLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 19:11:11 -0400
Message-ID: <51C38BFE.9000405@ahsoftware.de>
Date: Fri, 21 Jun 2013 01:10:54 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [rtc-linux] Re: [PATCH 4/9 RESEND] RFC: timekeeping: introduce
 flag systime_was_set
References: <51BA1FF7.4000206@ahsoftware.de> <1371228732-5749-1-git-send-email-holler@ahsoftware.de> <1371228732-5749-5-git-send-email-holler@ahsoftware.de> <51BB55C0.7090603@linaro.org> <51BB5B65.3000400@ahsoftware.de> <51BB60B1.6040007@linaro.org> <51BC034C.8080702@ahsoftware.de> <51BF5132.1060400@linaro.org> <51C2D62A.3060906@ahsoftware.de> <51C33B9B.7030600@linaro.org> <51C34DCC.8080501@ahsoftware.de> <51C357ED.7080409@linaro.org>
In-Reply-To: <51C357ED.7080409@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 20.06.2013 21:28, schrieb John Stultz:

>>>
>>> But ntpd can be installed afterwards, and it would be silly to require
>>> users edit their boot arguments when installing the ntp package.
>>>
>
> This point you left un-addressed, and is the key problem I see with
> requiring boot arguments.

There is no requirement for an additional boot argument.

That would only be necessary if you start ntpdate without using a 
persistent clock and before loading of (working) rtc-modules would have 
finished. And even then it would only be necessary if you use ntpdate 
(once) while a driver for the rtc is in it's registration phase and 
wants to set the clock or if you use ntp and the rtc which registers 
while ntp sets the time, has a time which would force ntp to refuse 
further adjustments. And in both cases only, if you don't have disabled 
the proposed hctosys with using a boot argument. Just because a boot 
argument makes it possible to disable hctosys by RTC doesn't mean it's 
necessary.

Sorry for beeing pedantic, but I have to defend my decision to avoid 
locking just because of that possibility. I was fully aware of that 
unlikely race condition.

Anyway, I've already accomplished to add locking to prevent that case.

Regards,

Alexander Holler
