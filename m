Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab3GJOlH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 10:41:07 -0400
Received: from mail-qe0-f49.google.com ([209.85.128.49]:61708 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210Ab3GJOlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 10:41:04 -0400
MIME-Version: 1.0
In-Reply-To: <20130710122023.GN11908@titan.lakedaemon.net>
References: <1373352166-10064-1-git-send-email-zhangwm@marvell.com>
	<1373352166-10064-2-git-send-email-zhangwm@marvell.com>
	<20130709124900.GG11908@titan.lakedaemon.net>
	<175CCF5F49938B4D99B2E3EF7F558EBE3DBC97FA8F@SC-VEXCH4.marvell.com>
	<20130710122023.GN11908@titan.lakedaemon.net>
Date: Wed, 10 Jul 2013 08:41:03 -0600
X-Google-Sender-Auth: zWSDaCEFsiX4SjkPYZ706ebNuxA
Message-ID: <CAMLZHHQre=juBmWJ2ZouLJGUW0owJd4GrOVur=ea2BPvMWjMbA@mail.gmail.com>
Subject: Re: [PATCH V3 1/3] dts: change Marvell prefix to 'marvell'
From: Daniel Drake <dsd@laptop.org>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Neil Zhang <zhangwm@marvell.com>, "arnd@arndb.de" <arnd@arndb.de>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "haojian.zhuang@gmail.com" <haojian.zhuang@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 6:20 AM, Jason Cooper <jason@lakedaemon.net> wrote:
> Please keep in mind that the DT is supposed to be tied to the hardware,
> *not* the kernel.  iow, a dtb comes with a board, and the user/OS
> upgrades the kernel as needed w/o upgrading or changing the dtb.

Thank you for making this position clear to those trying to break
compatibility...

This will affect OLPC where the dtb comes from the firmware
(OpenFirmware), which is similar to the dtb coming "with the board" as
you describe. We run on Marvell SoCs.

> So the question you need to ask yourself is: Are there any users (since
> v3.5) that are doing this?  If so, they have "mrvl,..." compatible
> strings in their dtbs.  You don't want to break their systems on kernel
> upgrade, right?

In the OLPC case, the devicetree currently exported from the firmware
is unfortunately quite insufficient to boot mainline kernels. So we
are currently in a state of flux where we must break firmware/OS
compatibility in significant ways in order to support mainline
kernels. We are heading in this direction despite the pains.

Therefore right now its OK for us if we break compatibility during our
in-flux major firmware/DT restructuring, as this patch does.

However, once we have stabilised in the near future, it will no longer
be possible to break compatibility like this.

My vote would be to maintain the old names (in addition to the new) in
case there are people that will be affected by this that haven't seen
this thread. We were recently hit by another backwards-incompatible
change in Marvell's Linux gpio drivers where the compatible strings
recognised were changed (f87311743eaf85). This is not a big problem in
our current state however it cost me about 3 hours of changelog
skimming, glancing around in the code, and finally running a git
bisect, before I managed to figure out why things had suddenly stopped
working. That was irritating.

Thanks
Daniel
