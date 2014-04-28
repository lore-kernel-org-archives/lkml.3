Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487AbaD1TYx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:24:53 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:44987 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756697AbaD1TYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:24:51 -0400
MIME-Version: 1.0
In-Reply-To: <53555C56.1040900@infradead.org>
References: <1397415946.1555.16.camel@vger.seibold.net>
	<53555C56.1040900@infradead.org>
Date: Mon, 28 Apr 2014 11:16:37 -0700
Message-ID: <CALAqxLVVGM2nON71BbhuD-7eXnqbKGomfL63COaT7nePuQQ=zg@mail.gmail.com>
Subject: Re: X86: Impossible select Enhanced Real Time Clock Support (legacy
 PC RTC driver)
From: John Stultz <john.stultz@linaro.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stefani Seibold <stefani@seibold.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <greg@kroah.com>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Prarit Bhargava <prarit@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2014 at 10:58 AM, Randy Dunlap <rdunlap@infradead.org> wrote:
> [adding more patch committers]
>
> On 04/13/2014 12:05 PM, Stefani Seibold wrote:
>> Since some kernel version it is impossible to select the Enhanced Real
>> Time Clock Support (legacy PC RTC driver) because RTC_LIB is set by
>> default in arch/x86/Kconfig, but the rule for selecting CONFIG_RTC is
>> RTC_LIB=n. So the code of driver/char/rtc is still useless.
>>
>> This breaks the API since there is no more misc device /dev/rtc
>> available without a udev rule or a link to /dev/rtc0.

So yea.. I feel like that /dev/rtcN renaming (and API) break (which
was a huge and annoying pain) was back in the 2.6.18-ish era?

But it sounds like the driver/char/rtc bit is dead code, and needs a
cleanup? Or is there some use of that code that you need that the
generic RTC layer doesn't have?

thanks
-john
