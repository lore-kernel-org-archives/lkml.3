Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933656Ab3CMQgV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 12:36:21 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:40339 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756441Ab3CMQgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 12:36:20 -0400
Message-ID: <5140AAFD.4080508@ti.com>
Date: Wed, 13 Mar 2013 18:36:13 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: <balbi@ti.com>, <b-cousson@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH 00/24] ARM: OMAP2+: Adapt to ehci-omap changes for 3.10
References: <1363088606-2692-1-git-send-email-rogerq@ti.com> <20130312164007.GZ26093@atomide.com> <5140821B.2030902@ti.com> <20130313162454.GE26093@atomide.com>
In-Reply-To: <20130313162454.GE26093@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2013 06:24 PM, Tony Lindgren wrote:
> * Roger Quadros <rogerq@ti.com> [130313 06:46]:
>> On 03/12/2013 06:40 PM, Tony Lindgren wrote:
>>> * Roger Quadros <rogerq@ti.com> [130312 04:47]:
>>>> Hi Tony,
>>>>
>>>> These patches provide the SoC side code required to support
>>>> the changes in the OMAP USB Host drivers done in [1], [2] & [3].
>>> ... 
>>>
>>>>  arch/arm/mach-omap2/board-3430sdp.c                |   97 +++++++++++++++-
>>>>  arch/arm/mach-omap2/board-3630sdp.c                |  100 +++++++++++++++-
>>>>  arch/arm/mach-omap2/board-am3517crane.c            |   95 +++++++++++++--
>>>>  arch/arm/mach-omap2/board-am3517evm.c              |   66 ++++++++++-
>>>>  arch/arm/mach-omap2/board-cm-t35.c                 |   95 ++++++++++++++-
>>>>  arch/arm/mach-omap2/board-cm-t3517.c               |   97 +++++++++++++++-
>>>>  arch/arm/mach-omap2/board-devkit8000.c             |   20 ++--
>>>>  arch/arm/mach-omap2/board-generic.c                |   67 +++++++++++
>>>>  arch/arm/mach-omap2/board-igep0020.c               |  112 ++++++++++++++++---
>>>>  arch/arm/mach-omap2/board-omap3beagle.c            |   93 +++++++++++++--
>>>>  arch/arm/mach-omap2/board-omap3evm.c               |   62 ++++++++--
>>>>  arch/arm/mach-omap2/board-omap3pandora.c           |   52 +++++++--
>>>>  arch/arm/mach-omap2/board-omap3stalker.c           |   52 +++++++-
>>>>  arch/arm/mach-omap2/board-omap3touchbook.c         |   62 +++++++++-
>>>>  arch/arm/mach-omap2/board-omap4panda.c             |  122 ++++++++++++++------
>>>>  arch/arm/mach-omap2/board-overo.c                  |   54 ++++++++-
>>>>  arch/arm/mach-omap2/board-zoom.c                   |   56 ++++++++-
>>>
>>> Can't you have some mach-omap2/ehci-common.c that takes care
>>> of the initializiation to avoid this much addition to the
>>> board-*.c files? You may be able to have just a common function
>>> to do it and pass few parameters?
>>
>> Since we moved reset and power handling for the USB PHYs from omap-echi
>> driver into the USB PHY driver we need to define the regulator data
>> for RESET and Power line of each PHY. So most of the code added is just
>> regulator data for the PHY rather than omap-ehci.
> 
> It seems that you're now repeating minor variations of the same PHY
> over and over again though.

Yes it is the vcc and reset regulator data for the PHY that
is getting repeated with variations in the GPIO number.

>  
>> Instead of a common function, I can implement some macros that make it
>> easier to define the regulators for the PHY in the board files.
>> Does this sound OK?
>>
>> Personally I don't like such macros because it hides the implementation
>> and is difficult to read/debug.
> 
> I'd prefer a common function to initialize the PHY though as it sounds
> like using macros would just allocate similar PHY many times which seems
> unnecessary.
> 
OK, so we want to create the regulator data at runtime to save some memory?
I'll come up with something.

cheers,
-roger
