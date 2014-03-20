Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758902AbaCTPgt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 11:36:49 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:51637 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758452AbaCTPgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 11:36:40 -0400
Date: Thu, 20 Mar 2014 08:36:34 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Michael Brunner <michael.brunner@kontron.com>
Subject: Re: [PATCH] mfd: kempld-core: Fix potential hang-up during boot
Message-ID: <20140320153634.GB18690@roeck-us.net>
References: <1395328348-20661-1-git-send-email-linux@roeck-us.net>
 <20140320152812.GB8207@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140320152812.GB8207@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2014 at 03:28:12PM +0000, Lee Jones wrote:
> > On PXT and COMe-cPC2 boards it is observed that the hardware
> > mutex is acquired but not being released during initialization.
> > This can result in a hang-up during boot if the driver is built
> > into the kernel.
> > 
> > Releasing the mutex twice if it was acquired fixes the problem.
> > Subsequent request/release cycles work as expected, so the fix is
> > only needed during initialization.
> > 
> > Reviewed-by: Michael Brunner <michael.brunner@kontron.com>
> > Tested-by: Michael Brunner <michael.brunner@kontron.com>
> > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > ---
> >  drivers/mfd/kempld-core.c |    7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> I was going to stop taking patches for this cycle, but as this looks
> like a bugfix I'll apply it, thanks.
> 

Hi Lee,

Great.

I should have added a note - the patch will also be needed in -stable;
the driver is used in both 3.12 and 3.13.

Thanks,
Guenter
