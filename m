Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760532Ab3LIGIS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 01:08:18 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:33809 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755504Ab3LIGIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 01:08:16 -0500
Message-ID: <52A55E2C.7070500@ti.com>
Date: Mon, 9 Dec 2013 11:37:40 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: <balbi@ti.com>, Tony Lindgren <tony@atomide.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
CC: Javier Martinez Canillas <javier@dowhile0.org>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] arm: omap: remove *.auto* from device names given
 in usb_bind_phy
References: <1386331571-30903-1-git-send-email-kishon@ti.com> <1386331571-30903-3-git-send-email-kishon@ti.com> <CABxcv=n67gNq6ayx+t_mfZ0++UBKkXpH9avXvRKFEH4VUrwy0g@mail.gmail.com> <20131206210835.GM21086@saruman.home>
In-Reply-To: <20131206210835.GM21086@saruman.home>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Saturday 07 December 2013 02:38 AM, Felipe Balbi wrote:
> Hi,
>
> On Fri, Dec 06, 2013 at 01:14:38PM +0100, Javier Martinez Canillas wrote:
>> On Fri, Dec 6, 2013 at 1:06 PM, Kishon Vijay Abraham I <kishon@ti.com> wrote:
>>> Previously MUSB wrapper (OMAP) device used PLATFORM_DEVID_AUTO while creating
>>> MUSB core device. So in usb_bind_phy (binds the controller with the PHY), the
>>> device name of the controller had *.auto* in it. Since with using
>>> PLATFORM_DEVID_AUTO, there is no way to know the exact device name in advance,
>>> the data given in usb_bind_phy became obsolete and usb_get_phy was failing.
>>> So MUSB wrapper was modified not to use PLATFORM_DEVID_AUTO. Corresponding
>>> change is done in board file here.
>>>
>>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>>> ---
>>>   arch/arm/mach-omap2/board-2430sdp.c        |    2 +-
>>>   arch/arm/mach-omap2/board-3430sdp.c        |    2 +-
>>>   arch/arm/mach-omap2/board-cm-t35.c         |    2 +-
>>>   arch/arm/mach-omap2/board-devkit8000.c     |    2 +-
>>>   arch/arm/mach-omap2/board-ldp.c            |    2 +-
>>>   arch/arm/mach-omap2/board-omap3beagle.c    |    2 +-
>>>   arch/arm/mach-omap2/board-omap3logic.c     |    2 +-
>>>   arch/arm/mach-omap2/board-omap3pandora.c   |    2 +-
>>>   arch/arm/mach-omap2/board-omap3stalker.c   |    2 +-
>>>   arch/arm/mach-omap2/board-omap3touchbook.c |    2 +-
>>>   arch/arm/mach-omap2/board-overo.c          |    2 +-
>>>   arch/arm/mach-omap2/board-rx51.c           |    2 +-
>>>   12 files changed, 12 insertions(+), 12 deletions(-)
>>>
>>
>> You can drop this patch since boards files are being removed for v3.14
>
> if we can drop this patch, the whole series is invalid, since we'll be
> using DT phandles to find PHYs going forward, no ?
>
yeah. But in one of the other threads, Tony seemed ok to take a patch 
that fixes the same issue in mach-omap2/twl-common.c. So it's better to 
confirm with Tony.

Thanks
Kishon
