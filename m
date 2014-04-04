Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbaDDWHJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 18:07:09 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:59066 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759AbaDDWHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 18:07:01 -0400
MIME-Version: 1.0
In-Reply-To: <533EDB15.40305@linux.com>
References: <1395093587-2583-1-git-send-email-teobaluta@gmail.com>
	<20140319201838.GA11403@redhat.com>
	<CACV2jQBrKBUmiYRj8L4tvWucGX5U0EqufC8BkSXoKOL1BO-Tuw@mail.gmail.com>
	<20140321132816.GW15608@titan.lakedaemon.net>
	<532DC3D3.9060008@linux.com>
	<CACV2jQBfRdQOyXF80WLoqm08-3VpWZno6UphKKPWmQD2f_yitA@mail.gmail.com>
	<20140323193839.GY15608@titan.lakedaemon.net>
	<CAAsK9AF8VevpdF-3nLC5sadV4y31cVeVWb5f2E=sV3ROu3Yk4Q@mail.gmail.com>
	<20140401142051.GO28304@titan.lakedaemon.net>
	<alpine.DEB.2.02.1404031353280.14073@nftneq.ynat.uz>
	<20140404151542.GB28334@titan.lakedaemon.net>
	<533EDB15.40305@linux.com>
Date: Sat, 5 Apr 2014 00:42:32 +0300
Message-ID: <CACV2jQCxfQzRydFD6KizFnquasqtqaz1O_yNnVDBetFA5UryrA@mail.gmail.com>
Subject: Re: [RFC] QR encoding for Oops messages
From: =?ISO-8859-2?B?VGVvZG9yYSBC42x1/uM=?= <teobaluta@gmail.com>
To: Levente Kurusa <levex@linux.com>
Cc: Jason Cooper <jason@lakedaemon.net>, David Lang <david@lang.hm>,
        Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 4, 2014 at 7:17 PM, Levente Kurusa <levex@linux.com> wrote:
> Hi,
>
> On 04/04/2014 05:15 PM, Jason Cooper wrote:
>> On Thu, Apr 03, 2014 at 01:57:04PM -0700, David Lang wrote:
>>> On Tue, 1 Apr 2014, Jason Cooper wrote:
>>>
>>>>> Now I guess we need to think how to make it work without a
>>>>> framebuffer. I already suggested using the ASCII characters,
>>>>> but seeing the resolution of this QR code for example (147x147),
>>>>> made me realize that we can't shuffle that into a 80x25 textmode
>>>>> display. Any ideas how to fix that or should we just simply depend
>>>>> on a framebuffer being present?
>>>>
>>>> I think depending on the framebuffer being present (via kconfig) is
>>>> sane.  Folks running old systems know what they're in for, like missing
>>>> shiny new features. ;-)
>>>
>>> First get it working and into acceptable form, but after that, take
>>> a look at the various ASCII-art tools out there. While the display
>>> may be limited to 80x25, that's not a hard requirement (and I'd
>>> happily run systems with a smaller text console if this was an
>>> option), and then you can look at the possibility of using
>>> characters that represent more than one pixel per character. While
>>> this may not be able to render everything perfectly, remember that
>>> qr codes can include redundancy to correct for bad pixels, you may
>>> be able to get something working.
>
> I am not sure depending on the error recovery is good practice.
> We also have to take into account that scanners themselves also
> create noise and may not be perfect. Better reserve the error
> recovery for those details instead of messing the QR code with
> characters...

You do have the option of error recovery for up to 30% recovery (H
level), but that means the space you get for storing is smaller.

>
>>
>> I'm not sure this will work.  The screen space allocated to a single
>> character isn't square.  However, the QR pixels are square.  I see a lot
>> of fragile complexity ahead...
>>
>
> ... not to mention this as well.
>
>
> IMHO supporting textmode is just not worth the effort. Besides,
> what would we gain from it? Supporting those devices without
> a framebuffer? Do devices like that even exist anymore? In fact,
> even to make this you need a screen, and AFAIK most screens come
> with some kind of a framebuffer to drive them.

Guys, first things first is cleaning the library up. I haven't managed
to do anything yet as I am working on my thesis (bachelor's degree,
yay!). I will do some this weekend and that is removing the kanji mode
support. So, Levente, pleaso do that parameter thing you mentioned.
Merging that with the cleanup shouldn't be a problem. :-)

I think writing the QR to the frame buffer is the way to do it for
now. Doing a QR in text mode (as in displaying it, not as previously
mentioned idea with the link base64 encoding &/ compression) would
mean that for each square you get an ASCII character filling up your
screen. To get an idea of how the QR looks on the frame buffer I've
made a screenshot. That's the whole Oops message being encoded and
compressed. [0]

The problem with frame buffer is that I currently implemented it using
the generic frame buffer API. There are some issues as mentioned in
the first post of this RFC [1]. Would making it work with KMS be
better? Any opinions?

Thanks,
--
Teodora

[0] http://swarm.cs.pub.ro/~teobaluta/QR_code_fb.jpg
[1] https://lkml.org/lkml/2014/3/17/525

>
> --
> Regards,
> Levente Kurusa
