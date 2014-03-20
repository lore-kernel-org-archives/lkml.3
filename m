Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759281AbaCTPts (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 11:49:48 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:58182 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755533AbaCTPtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 11:49:47 -0400
Date: Thu, 20 Mar 2014 15:49:41 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Michael Brunner <michael.brunner@kontron.com>
Subject: Re: [PATCH] mfd: kempld-core: Fix potential hang-up during boot
Message-ID: <20140320154941.GF8207@lee--X1>
References: <1395328348-20661-1-git-send-email-linux@roeck-us.net>
 <20140320152812.GB8207@lee--X1>
 <20140320153634.GB18690@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140320153634.GB18690@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > On PXT and COMe-cPC2 boards it is observed that the hardware
> > > mutex is acquired but not being released during initialization.
> > > This can result in a hang-up during boot if the driver is built
> > > into the kernel.
> > > 
> > > Releasing the mutex twice if it was acquired fixes the problem.
> > > Subsequent request/release cycles work as expected, so the fix is
> > > only needed during initialization.
> > > 
> > > Reviewed-by: Michael Brunner <michael.brunner@kontron.com>
> > > Tested-by: Michael Brunner <michael.brunner@kontron.com>
> > > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > > ---
> > >  drivers/mfd/kempld-core.c |    7 +++++--
> > >  1 file changed, 5 insertions(+), 2 deletions(-)
> > 
> > I was going to stop taking patches for this cycle, but as this looks
> > like a bugfix I'll apply it, thanks.
> > 
> 
> Hi Lee,
> 
> Great.
> 
> I should have added a note - the patch will also be needed in -stable;
> the driver is used in both 3.12 and 3.13.

Very well. I'll add the Cc to the commit log.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
