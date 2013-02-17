Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305Ab3BQPpg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 10:45:36 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:42311 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078Ab3BQPpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 10:45:35 -0500
MIME-Version: 1.0
In-Reply-To: <201302151416.18121.arnd@arndb.de>
References: <1360880818-4071454-1-git-send-email-arnd@arndb.de>
	<1360880818-4071454-8-git-send-email-arnd@arndb.de>
	<20130214230501.GA30269@kroah.com>
	<201302151416.18121.arnd@arndb.de>
Date: Sun, 17 Feb 2013 23:45:33 +0800
Message-ID: <CAN1soZwfykw8A3EPoBzvxhxFk7N1PN=b8Fz4LYps9yAWD6W0Eg@mail.gmail.com>
Subject: Re: fb: mmp: include linux/platform_device.h
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Zhou Zhu <zzhu3@marvell.com>, Lisa Du <cldu@marvell.com>,
        Guoqing Li <ligq@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 10:16 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> Patch 16559ae "kgdb: remove #include <linux/serial_8250.h> from kgdb.h"
> changes the kgdb.h file so that drivers including it do not implicitly
> include linux/platform_device.h. The mmp framebuffer driver is new,
> so Greg did not have a chance to fix it up when introducing his change.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> On Thursday 14 February 2013, Greg Kroah-Hartman wrote:
>> On Thu, Feb 14, 2013 at 11:26:56PM +0100, Arnd Bergmann wrote:
>> > Patch 16559ae "kgdb: remove #include <linux/serial_8250.h> from kgdb.h"
>> > removed an implicit inclusion of linux/platform_device.h
>> > In a number of places. This adds back explicit inclusions in a few
>> > more places I found.
>>
>> >  drivers/video/mmp/fb/mmpfb.c             | 1 +
>>
>> This file isn't my tty tree, so I can't apply that part of the patch,
>> but I've applied the rest of the patch, and the 2 others you sent me to
>> fix this issue.
>
> Right. It seems the driver is only in Andrew's tree. Andrew, can you
> add this hunk on top?
>
> diff --git a/drivers/video/mmp/fb/mmpfb.c b/drivers/video/mmp/fb/mmpfb.c
> index f34a3a9..6d1fa96 100644
> --- a/drivers/video/mmp/fb/mmpfb.c
> +++ b/drivers/video/mmp/fb/mmpfb.c
> @@ -21,6 +21,7 @@
>   */
>  #include <linux/module.h>
>  #include <linux/dma-mapping.h>
> +#include <linux/platform_device.h>
>  #include "mmpfb.h"
>
>  static int var_to_pixfmt(struct fb_var_screeninfo *var)

Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>
