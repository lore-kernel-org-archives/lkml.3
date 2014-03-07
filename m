Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053AbaCGRjO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 12:39:14 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:44052 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930AbaCGRjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 12:39:13 -0500
Message-ID: <531A0436.3080201@ti.com>
Date: Fri, 7 Mar 2014 23:09:02 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v6] phy: omap-usb2: move omap_usb.h from linux/usb/ to
 linux/phy/
References: <1393846695-14644-1-git-send-email-kishon@ti.com> <1394210888-1587-1-git-send-email-kishon@ti.com> <20140307165043.GC23885@saruman.home>
In-Reply-To: <20140307165043.GC23885@saruman.home>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 March 2014 10:20 PM, Felipe Balbi wrote:
> On Fri, Mar 07, 2014 at 10:18:08PM +0530, Kishon Vijay Abraham I wrote:
>> No functional change. Moved omap_usb.h from linux/usb/ to linux/phy/.
>> Also removed the unused members of struct omap_usb (after phy-omap-pipe3
>> started using it's own header file)
>
> does this depend in any other patch ? I get the following when applying
> *only* this patch on top of v3.14-rc5:

yeah.. this is for linux-phy tree. I'll take this patch.

Thanks
Kishon

>
> drivers/phy/phy-omap-usb2.c: In function ‘omap_usb2_suspend’:
> drivers/phy/phy-omap-usb2.c:106:21: error: ‘struct omap_usb’ has no member named ‘is_suspended’
>    if (suspend && !phy->is_suspended) {
>                       ^
> drivers/phy/phy-omap-usb2.c:109:6: error: ‘struct omap_usb’ has no member named ‘is_suspended’
>     phy->is_suspended = 1;
>        ^
> drivers/phy/phy-omap-usb2.c:110:28: error: ‘struct omap_usb’ has no member named ‘is_suspended’
>    } else if (!suspend && phy->is_suspended) {
>                              ^
> drivers/phy/phy-omap-usb2.c:117:6: error: ‘struct omap_usb’ has no member named ‘is_suspended’
>     phy->is_suspended = 0;
>        ^
> drivers/phy/phy-omap-usb2.c: In function ‘omap_usb2_probe’:
> drivers/phy/phy-omap-usb2.c:194:5: error: ‘struct omap_usb’ has no member named ‘is_suspended’
>    phy->is_suspended = 1;
>       ^
> make[1]: *** [drivers/phy/phy-omap-usb2.o] Error 1
> make: *** [drivers/phy/] Error 2
> make: *** Waiting for unfinished jobs....
>    CC [M]  drivers/usb/phy/phy-mxs-usb.o
> drivers/usb/phy/phy-omap-usb3.c:22:32: fatal error: linux/usb/omap_usb.h: No such file or directory
>   #include <linux/usb/omap_usb.h>
>                                  ^
> compilation terminated.
> make[1]: *** [drivers/usb/phy/phy-omap-usb3.o] Error 1
> make[1]: *** Waiting for unfinished jobs....
> make: *** [drivers/usb/phy/] Error 2
>

