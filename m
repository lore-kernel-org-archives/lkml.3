Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751278AbaKFOJp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 09:09:45 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42330 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750828AbaKFOJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 09:09:42 -0500
Date: Thu, 6 Nov 2014 14:09:40 +0000
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: "Stam, Michel [FINT]" <M.Stam@fugro.nl>
Cc: Riku Voipio <riku.voipio@iki.fi>, freddy@asix.com.tw, davem@davemloft.net,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Subject: Re: "asix: Don't reset PHY on if_up for ASIX 88772" breaks net
	onarndale platform
Message-ID: <20141106140940.GW23178@opensource.wolfsonmicro.com>
References: <C89EFD3CD56F64468D3D206D683A8D2203985FA9@ldam-msx2.fugro-nl.local> <20141104200914.GN23178@opensource.wolfsonmicro.com> <C89EFD3CD56F64468D3D206D683A8D22039FFC5F@ldam-msx2.fugro-nl.local> <20141105150258.GR23178@opensource.wolfsonmicro.com> <20141106090651.GA19109@afflict.kos.to> <20141106100104.GS23178@opensource.wolfsonmicro.com> <20141106120416.GA20162@afflict.kos.to> <C89EFD3CD56F64468D3D206D683A8D22039FFE16@ldam-msx2.fugro-nl.local> <20141106124653.GV23178@opensource.wolfsonmicro.com> <C89EFD3CD56F64468D3D206D683A8D22039FFE39@ldam-msx2.fugro-nl.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C89EFD3CD56F64468D3D206D683A8D22039FFE39@ldam-msx2.fugro-nl.local>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 03:01:56PM +0100, Stam, Michel [FINT] wrote:
> Hello Charles and Riku,
> 
> I've quickly tested this on a 3.10 kernel i had around;
> I enabled CONFIG_PM, CONFIG_PM_RUNTIME, CONFIG_PM_AUTOSLEEP,
> CONFIG_SUSPEND, CONFIG_SUSPEND_FREEZER, CONFIG_FREEZER in the kernel (by
> default they are disabled for our setup, I enabled anything regarded to
> runtime powermanagement to be sure I would trigger suspend/resume).
> 
> Then:
> cd /sys/bus/usb/devices/1-2/power
> echo auto > control
> echo 1 > autosuspend
> echo 0 > autosuspend_delay_ms
> echo enabled > wakeup
> 
> # make sure there's no processes routing traffic over the eth1 interface
> 
> ifconfig eth1 down
> sleep 4 # sleep some arbitrary long time
> ifconfig eth1 up
> 
> check dmesg; it will reset back to 100 Mbps/full duplex.
> 
> This confirms that the suspend / resume does not work well. So long as
> the suspend is not triggered, it does seem to work, though. I cannot say
> whether the original issue that triggered this is still around; the ASIX
> chip setup we use is soldered to the PCB and hooked up to a fixed device
> on-board. 
> I also tried to ping the device on the other side of the ASIX chip after
> the suspend/resume cycle, I could not ping it. I cannot conclusively say
> that this is due to the ASIX driver, as the device on the other side
> does not like switching PHY speeds (it may go into a non-responsive
> state). It is for this reason that we run it at half duplex/ 10Mbps at
> all times.
> 
> As said; we are not using this kind of power management, so it does not
> raise any issues for us. I am merely pointing out that this may need
> work (in the future?).

Cool thanks for checking this I will make a note in the commit
message that suspend/resume might need some more work.

Thanks,
Charles
