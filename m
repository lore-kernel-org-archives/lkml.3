Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933975AbaH0Kbi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 06:31:38 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:35059 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933374AbaH0Kbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 06:31:36 -0400
Message-ID: <53FDB37C.8030707@ti.com>
Date: Wed, 27 Aug 2014 13:31:24 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>, <gregkh@linuxfoundation.org>
CC: <balbi@ti.com>, <ming.lei@canonical.com>, <mwelling@emacinc.com>,
        <stefan@herbrechtsmeier.net>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, "[3.8+]" <stable@vger.kernel.org>
Subject: Re: [PATCH] usb: hub: Prevent hub autosuspend if usbcore.autosuspend
 is -1
References: <Pine.LNX.4.44L0.1408041006530.1169-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1408041006530.1169-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2014 05:07 PM, Alan Stern wrote:
> On Mon, 4 Aug 2014, Roger Quadros wrote:
> 
>> If user specifies that USB autosuspend must be disabled by module
>> parameter "usbcore.autosuspend=-1" then we must prevent
>> autosuspend of USB hub devices as well.
>>
>> commit 596d789a211d introduced in v3.8 changed the original behaivour
>> and stopped respecting the usbcore.autosuspend parameter for hubs.
>>
>> Fixes: 596d789a211d "USB: set hub's default autosuspend delay as 0"
>>
>> Cc: [3.8+] <stable@vger.kernel.org>
>> Signed-off-by: Roger Quadros <rogerq@ti.com>
> 
> Acked-by: Alan Stern <stern@rowland.harvard.edu>
> 

Just noticed the below error by the Intel's build script

> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-linus
> head:   039368901ad0a6476c7ecf0cfe4f84d735e30135
> commit: bdd405d2a5287bdb9b04670ea255e1f122138e66 [19/20] usb: hub: Prevent hub autosuspend if usbcore.autosuspend is -1
> config: make ARCH=sparc64 defconfig
> 
> All error/warnings:
> 
>    drivers/usb/core/hub.c: In function 'hub_probe':
>>> drivers/usb/core/hub.c:1735:21: error: 'struct dev_pm_info' has no member named 'autosuspend_delay'
>      if (hdev->dev.power.autosuspend_delay >= 0)
>                         ^

Seems like the "if" has to be placed within a #ifdef CONFIG_PM_RUNTIME.

Greg,

Should I send a v2 of this patch or a fix on top of your usb-linus branch?

cheers,
-roger
