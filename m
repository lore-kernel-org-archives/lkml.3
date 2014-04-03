Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbaDCU5V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 16:57:21 -0400
Received: from mail.lang.hm ([64.81.33.126]:58660 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753830AbaDCU5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 16:57:13 -0400
Date: Thu, 3 Apr 2014 13:57:04 -0700 (PDT)
From: David Lang <david@lang.hm>
X-X-Sender: dlang@asgard.lang.hm
To: Jason Cooper <jason@lakedaemon.net>
cc: Levente Kurusa <levex@linux.com>,
        =?ISO-8859-2?Q?Teodora_B=E3lu=FE=E3?= <teobaluta@gmail.com>,
        Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
Subject: Re: [RFC] QR encoding for Oops messages
In-Reply-To: <20140401142051.GO28304@titan.lakedaemon.net>
Message-ID: <alpine.DEB.2.02.1404031353280.14073@nftneq.ynat.uz>
References: <1395093587-2583-1-git-send-email-teobaluta@gmail.com> <20140319201838.GA11403@redhat.com> <CACV2jQBrKBUmiYRj8L4tvWucGX5U0EqufC8BkSXoKOL1BO-Tuw@mail.gmail.com> <20140321132816.GW15608@titan.lakedaemon.net> <532DC3D3.9060008@linux.com>
 <CACV2jQBfRdQOyXF80WLoqm08-3VpWZno6UphKKPWmQD2f_yitA@mail.gmail.com> <20140323193839.GY15608@titan.lakedaemon.net> <CAAsK9AF8VevpdF-3nLC5sadV4y31cVeVWb5f2E=sV3ROu3Yk4Q@mail.gmail.com> <20140401142051.GO28304@titan.lakedaemon.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Apr 2014, Jason Cooper wrote:

>> Now I guess we need to think how to make it work without a
>> framebuffer. I already suggested using the ASCII characters,
>> but seeing the resolution of this QR code for example (147x147),
>> made me realize that we can't shuffle that into a 80x25 textmode
>> display. Any ideas how to fix that or should we just simply depend
>> on a framebuffer being present?
>
> I think depending on the framebuffer being present (via kconfig) is
> sane.  Folks running old systems know what they're in for, like missing
> shiny new features. ;-)

First get it working and into acceptable form, but after that, take a look at 
the various ASCII-art tools out there. While the display may be limited to 
80x25, that's not a hard requirement (and I'd happily run systems with a smaller 
text console if this was an option), and then you can look at the possibility of 
using characters that represent more than one pixel per character. While this 
may not be able to render everything perfectly, remember that qr codes can 
include redundancy to correct for bad pixels, you may be able to get something 
working.

David Lang
