Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbaDDQRe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 12:17:34 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:36679 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008AbaDDQRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 12:17:30 -0400
Message-ID: <533EDB15.40305@linux.com>
Date: Fri, 04 Apr 2014 18:17:25 +0200
From: Levente Kurusa <levex@linux.com>
Reply-To: Levente Kurusa <levex@linux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>, David Lang <david@lang.hm>
CC: =?UTF-8?B?VGVvZG9yYSBCxINsdcWjxIM=?= <teobaluta@gmail.com>,
        Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
Subject: Re: [RFC] QR encoding for Oops messages
References: <1395093587-2583-1-git-send-email-teobaluta@gmail.com> <20140319201838.GA11403@redhat.com> <CACV2jQBrKBUmiYRj8L4tvWucGX5U0EqufC8BkSXoKOL1BO-Tuw@mail.gmail.com> <20140321132816.GW15608@titan.lakedaemon.net> <532DC3D3.9060008@linux.com> <CACV2jQBfRdQOyXF80WLoqm08-3VpWZno6UphKKPWmQD2f_yitA@mail.gmail.com> <20140323193839.GY15608@titan.lakedaemon.net> <CAAsK9AF8VevpdF-3nLC5sadV4y31cVeVWb5f2E=sV3ROu3Yk4Q@mail.gmail.com> <20140401142051.GO28304@titan.lakedaemon.net> <alpine.DEB.2.02.1404031353280.14073@nftneq.ynat.uz> <20140404151542.GB28334@titan.lakedaemon.net>
In-Reply-To: <20140404151542.GB28334@titan.lakedaemon.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 04/04/2014 05:15 PM, Jason Cooper wrote:
> On Thu, Apr 03, 2014 at 01:57:04PM -0700, David Lang wrote:
>> On Tue, 1 Apr 2014, Jason Cooper wrote:
>>
>>>> Now I guess we need to think how to make it work without a
>>>> framebuffer. I already suggested using the ASCII characters,
>>>> but seeing the resolution of this QR code for example (147x147),
>>>> made me realize that we can't shuffle that into a 80x25 textmode
>>>> display. Any ideas how to fix that or should we just simply depend
>>>> on a framebuffer being present?
>>>
>>> I think depending on the framebuffer being present (via kconfig) is
>>> sane.  Folks running old systems know what they're in for, like missing
>>> shiny new features. ;-)
>>
>> First get it working and into acceptable form, but after that, take
>> a look at the various ASCII-art tools out there. While the display
>> may be limited to 80x25, that's not a hard requirement (and I'd
>> happily run systems with a smaller text console if this was an
>> option), and then you can look at the possibility of using
>> characters that represent more than one pixel per character. While
>> this may not be able to render everything perfectly, remember that
>> qr codes can include redundancy to correct for bad pixels, you may
>> be able to get something working.

I am not sure depending on the error recovery is good practice.
We also have to take into account that scanners themselves also
create noise and may not be perfect. Better reserve the error
recovery for those details instead of messing the QR code with
characters...

> 
> I'm not sure this will work.  The screen space allocated to a single
> character isn't square.  However, the QR pixels are square.  I see a lot
> of fragile complexity ahead...
> 

... not to mention this as well.


IMHO supporting textmode is just not worth the effort. Besides,
what would we gain from it? Supporting those devices without
a framebuffer? Do devices like that even exist anymore? In fact,
even to make this you need a screen, and AFAIK most screens come
with some kind of a framebuffer to drive them.

-- 
Regards,
Levente Kurusa
