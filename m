Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253AbaBXAXf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 19:23:35 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:57535 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750976AbaBXAXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 19:23:33 -0500
Message-ID: <530A9100.7090303@hurleysoftware.com>
Date: Sun, 23 Feb 2014 19:23:28 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Hal Murray <murray+fedora@ip-64-139-1-69.sjc.megapath.net>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Stanislaw Gruszka <sgruszka@redhat.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: locking changes in tty broke low latency feature
References: <20140219230623.736E8406062@ip-64-139-1-69.sjc.megapath.net> <53056E99.9070900@hurleysoftware.com> <53064672.3000807@hurleysoftware.com> <alpine.DEB.2.02.1402232330190.21251@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1402232330190.21251@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On 02/23/2014 05:33 PM, Thomas Gleixner wrote:
> On Thu, 20 Feb 2014, Peter Hurley wrote:
>
>> On 02/19/2014 09:55 PM, Peter Hurley wrote:
>>> On 02/19/2014 06:06 PM, Hal Murray wrote:
>>>>> Can you give me an idea of your device's average and minimum required
>>>>> latency (please be specific)?  Is your target arch x86 [so I can
>>>>> evaluate the
>>>>> the impact of bus-locked instructions relative to your expected]?
>>>>
>>>> The code I'm familiar with is ntpd and gpsd.  They run on almost any
>>>> hardware
>>>> or OS and talk to a wide collection of devices.
>>>>
>>>> There is no hard requirement for latency.  They just work better with
>>>> lower
>>>> latency.  The lower the better.
>>>>
>>>> People gripe about the latency due to USB polling which is about a ms.
>>>
>>> Have you tried 3.12+ without low_latency? I ripped out a lot of locks
>>> from 3.12+ so it's possible it already meets your requirements.
>>
>> Using Alan's idea to mock up a latency test, I threw together a test jig
>> using two computers running 3.14-rc1 and my fwserial driver (modified to
>> not aggregrate writes) in raw mode where the target does this:
>
> This is a complete pointless test. Use a bog standard 8250 UART on the
> PC and connect a microcontroller on the other end which serves you an
> continous stream of data at 115200 Baud.
>
> There is no way you can keep up with that without the low latency
> option neither on old and nor on new machines if you have enough other
> stuff going on in the system.

I'm not sure exactly what you mean by 'keep up'?
115kbaud is 11.25KB/sec which is a trivial workload (unless you're
using a 1-byte read buffer).

If you have enough other stuff going on in the system (hackbench?),
even the low_latency knob won't fix the inability to keep up because all
the buffering will fill up and overrun anyway.

So what I need to understand about your setup is:
a) is throughput the actual problem or is latency? IOW, does the
    device have a minimum response time from a user-space process
    or is buffered data getting dropped?
b) is the device flow-controlled or is that not an option?

Based on those answers, if necessary, I could get you an instrumentation
patch, if your willing, so I can profile where the problem is.

And I haven't seen a bog standard 8250 UART in 3 decades. What UART
do you actually have?

Regards,
Peter Hurley



