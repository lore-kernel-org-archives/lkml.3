Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562AbaHYUV4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 16:21:56 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:43583 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754818AbaHYUVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 16:21:55 -0400
Message-ID: <53FB9AC4.8010704@gmail.com>
Date: Mon, 25 Aug 2014 13:21:24 -0700
From: Florian Fainelli <f.fainelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3/3] ARM: zynq: DT: Add Ethernet phys
References: <1408550219-19825-1-git-send-email-soren.brinkmann@xilinx.com> <1408550219-19825-3-git-send-email-soren.brinkmann@xilinx.com> <5a7b6f57-b6c0-4fb3-af0d-d403277c0207@BN1AFFO11FD045.protection.gbl> <53F5D8D9.7040604@suse.de> <f166a186-301c-4288-97cf-71f8173c07e7@BN1AFFO11FD010.protection.gbl> <CAGVrzcYWN83tznwvw1M9V_mwWgobs2kwtRvEj4stqE=XGC10fg@mail.gmail.com> <20140825174610.GA13737@obsidianresearch.com>
In-Reply-To: <20140825174610.GA13737@obsidianresearch.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2014 10:46 AM, Jason Gunthorpe wrote:
> On Fri, Aug 22, 2014 at 01:47:09PM -0700, Florian Fainelli wrote:
> 
>>>  - the ID based strings seem to be not needed since, IIUC, the core
>>>    reads the ID from the PHY and uses it, so I just left it out not
>>>    trying to figure out how to obtain the correct ID
>>
>> It is not needed, but it is one way to specify a PHY device if you do
>> not know what compatible string to use instead.
> 
> No, it is a way to specify a PHY device if the kernel can't auto probe
> the Phy ID.
> 
> Last I checked, the kernel doesn't support plain text compatible
> strings for phys - everything is driven on the phy id, either auto
> probed or specified in the DT.

That's right. Some PHY drivers might be relying on specific compatible
strings though, but not the core PHY library that probes and maps a
driver to a PHY node.

> 
>>>  - the marvell compatible strings are used in our vendor tree. They
>>>    aren't used anywhere but in our vendor tree. I though keeping them is
>>>    nice since it identifies the PHY fully. And in case that level of
>>>    detail is needed at some point it is already there.
>>
>> And this is the recommended way to do it in case we ever need to key a
>> software decision based on the hardware.
> 
> All compatible strings need to be documented.
> 
> .. and they need to encode more information than you get from the phy
> id - die revsision, package option, functional options, voltage
> codes. Etc.
> 
> .. and they actually need to be *right*

Agreed.

> 
> An example: The kernel reports 88E1318S for all four chips in that
> family, AFAIK you have to read the package marking to figure out which
> you have (it is the same die, with options switched on/off at
> packaging time). People have already posted patches trying to
> helpfully add a 'marvell,88E1318S' compatible string based on kernel
> output. Except it is wrong, it isn't actually the '8S version in the
> HW.
> 
> Even worse, Marvell has a whole series of socket compatible phys. Just
> because the board the DT author looked at has a '318, doesn't mean
> that every board ever made will. We've actually already been switching
> between the 318 and 318S for production depending on which has part
> availability.
> 
> Basically: don't try to override self-discoverable hardware in DT
> without a really good reason.

I think that's a very good point, at the very least let's use a
compatible string that contains the full 32-bits PHY OUI.

Thanks
--
Florian
