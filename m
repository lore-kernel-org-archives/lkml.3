Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474Ab3FNRoL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 13:44:11 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:34443 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009Ab3FNRoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 13:44:09 -0400
Message-ID: <51BB565A.1010305@ahsoftware.de>
Date: Fri, 14 Jun 2013 19:43:54 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        rtc-linux@googlegroups.com, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [PATCH 7/9] RFC: rtc: implement rtc_read_timeval()
References: <51BA1FF7.4000206@ahsoftware.de> <1371228732-5749-1-git-send-email-holler@ahsoftware.de> <1371228732-5749-8-git-send-email-holler@ahsoftware.de> <51BB51A0.6050408@linaro.org>
In-Reply-To: <51BB51A0.6050408@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 14.06.2013 19:23, schrieb John Stultz:
> On 06/14/2013 09:52 AM, Alexander Holler wrote:
>> Some RTCs offer a higher resolution than seconds. To support reading such
>> high resolution timestamps from inside the kernel implement
>> rtc_read_timeval() and add a read_timeval to the rtc-ops.
>
> So I like the direction this patch is going. But if we're going to add a
> new interface, lets not use an already out-dated structure (timeval).
>
> Instead could you rework this to be timepsec based? Or ktime_t if its
> really internal only?

Sure, no problem. I wasn't aware timeval is out-dated and I've read 
somewhere in the sources a comment that ktime_t has to disappear. I had 
no clue if I should use timeval or timespec, and just have roled a dice 
to decide between timeval and timespec.

That "internal only" is only because I don't want to write changes for 
the userspace api to handle RTCs with greater precision than seconds. I 
don't have a writable RTC supporting such a precision and I want to 
leave this for people which are developing such devices and earning 
money with them.

Besides that, I have almost no knowledge about the userspace api for 
RTCs. If just looked a bit around in the in-kernel-ntp-sources for 
adjtimex, but that's all.

Please don't forget, my only motivation is to use an USB-RTC I've build 
myself to use with developer-boards without RTCs. All the other work 
like the support for higher precisions, the new hctosys or similiar is 
just because I let me trick to do that ;)

Regards,

Alexander Holler
