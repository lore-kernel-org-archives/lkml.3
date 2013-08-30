Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209Ab3H3NCR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 09:02:17 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:53042 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755882Ab3H3NCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 09:02:16 -0400
Date: Fri, 30 Aug 2013 14:02:10 +0100
From: Lee Jones <lee.jones@linaro.org>
To: "Hank.Peng" <Hank.Peng@advantech.com.tw>
Cc: "Louis.Lu" <Louis.Lu@advantech.com.tw>, "neo.lo" <neo.lo@advantech.com.tw>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: Advantech iManager2 driver for Linux Kernel
Message-ID: <20130830130210.GH23998@lee--X1>
References: <D03ECE401BD4844C85DC9D9C9CFF4FE301246137@TAIPEI01.ADVANTECH.CORP>
 <20130830121712.GI20329@zurbaran>
 <20130830125921.GG23998@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130830125921.GG23998@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC'ing the list (you must always do that when submitting patches).

> > Thanks for the patchset. For Lee or/and myself to properly review (and
> > potentially merge it upstream) it, you have to split it into smaller
> > chunks, and generate the patches with git (e.g. git-format-patch).
> > The patches should be as independent as possible, e.g. you could split
> > that one into an MFD one, and i2c one and a hwmon one.
> > 
> > Now, about the code itself, from a very quick first glance:
> > 
> > - No cross-compilation stuff, this is going to be a Linux driver.
> > - Put the i2c and hwmon part away from drivers/mfd/, they're not MFD
> >   drivers. They could have build time dependencies against the MFD
> >   driver (for the I/O API for example).
> > - No one liners wrappers (imanager2_ec_lock for example).
> > - Try to use managed resources (devm_*) if possible. 
> > - Where is the sio_inb() API coming from ?
> > - ARRAY_SIZE is your friend.
> 
> Just to add a few things of my own:
> 
>  - Read: Documentation/[SubmittingPatches|email-clients.txt|CodingStyle]
>    and pay particular attention to code formatting and comments.
>  - The print messages are too many and the formatting is pretty
>    ugly. You want to be striving for really simple, easy to ready code.
>    There is a time and a place for obfuscated C, this isn't it. :) If
>    it's impossible to, or makes sound sense not to make a particular
>    piece of code simple then you need to add a suitable comment.
>  - You use (!variable) and (variable == NULL), just standardise to the
>    former.
>  - Don't return -1, use proper Linux error codes [1].
>  - The DRVNAME and DRV_NAME name stuff is pretty ugly.
>  - Magic numbers are never acceptable, swap them out for #defines.
>  - Don't call probe() from init(), set them up as platform devices.
>  - You need to support Device Tree.
>    - Hmmm... there doesn't appear to be any platform side code in this
>      driver at all. I don't think that's right. Does this driver run
>      on multiple platforms?
>  - Using sizeof() to allocate the size of an array is ugly.
>  - You've defined your own version of sprintf() and it's not even
>    static! Why can't you use the one in the kernel? Same goes for
>    udelay().
>  - Variable names need to be descriptive, things like 'v' and 'f'
>    won't do.
>  - No need to comment the end of switch(), if(), for() etc.
>  - You can clean up set_temp_min() et. al by setting 'count' to
>    -EINVAL just once at the top instead of for all error conditions
>    throughout the function.
> 
> I think that's enough for now. :)
> 
> Good luck!
> 
> [1] http://www-numi.fnal.gov/offline_software/srt_public_context/WebDocs/Errors/unix_system_errors.html
>   
> -- 
> Lee Jones
> Linaro STMicroelectronics Landing Team Lead
> Linaro.org │ Open source software for ARM SoCs
> Follow Linaro: Facebook | Twitter | Blog

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
