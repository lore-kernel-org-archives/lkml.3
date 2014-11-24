Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616AbaKXK6e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 05:58:34 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:62345 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592AbaKXK6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 05:58:31 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, jeffrey.t.kirsher@intel.com, rpao@paonet.org,
        linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org
Subject: Re: [PATCH 1/2] net/am2150: fix nmclan_cs.c shared interrupt handling
Date: Mon, 24 Nov 2014 11:57:55 +0100
Message-ID: <2416727.91yS5gqAdt@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141121.151735.1432199551923486515.davem@davemloft.net>
References: <4353896.15JnC91eLO@wuerfel> <20141121.151735.1432199551923486515.davem@davemloft.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Z6xyVI1p9Uoy6KizON+nzdmesBUTKB5eWa2a3l0NDFy
 fesjRIMUOOG17ckL1rBDjIYtoxWCFlJJfHIEkZr8Ykg97Ss/Os
 YW0m0VPQH94kbG5Sk0BsHxH+uhKZuo9u03/QUJNHjWpQZKNm9T
 LxpIFJZ07AHAlP+q5xqHA/AkOdmadymEzlSNmmRT/TpGy6428J
 lroAUuyyit/7uJBZb3JdOkUOv4U4o6NxrhdFy1XuqbjKVrs24t
 o9MwqUvc++0o9qWLOswTglZrZtvOpckQqc4wwT4aFlLvQFfeBb
 wKKE5I/yvR+PZUu5upQxDZ5ZFWghfa+HpQ0FwuuuLxN5u9y2/S
 8L23Wx/d0QzBimQo8if0=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 November 2014 15:17:35 David Miller wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> Date: Thu, 20 Nov 2014 16:11:14 +0100
> 
> > A recent patch tried to work around a valid warning for the use of a
> > deprecated interface by blindly changing from the old
> > pcmcia_request_exclusive_irq() interface to pcmcia_request_irq().
> > 
> > This driver has an interrupt handler that is not currently aware
> > of shared interrupts, but can be easily converted to be.
> > At the moment, the driver reads the interrupt status register
> > repeatedly until it contains only zeroes in the interesting bits,
> > and handles each bit individually.
> > 
> > This patch adds the missing part of returning IRQ_NONE in case none
> > of the bits are set to start with, so we can move on to the next
> > interrupt source.
> > 
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > Fixes: 5f5316fcd08ef7 ("am2150: Update nmclan_cs.c to use update PCMCIA API")
> > ---
> > I had this patch in my queue of things to submit and noticed that
> > the warning had gone away upstream but my patch was still there.
> > 
> > For all I can tell, the driver is broken without this, although it
> > would rarely be a problem.
> 
> I'm happy for this to go alongside patch #2 via another tree:
> 
> Acked-by: David S. Miller <davem@davemloft.net>

I was hoping you could take at least this one, possibly both.
Since you already had Jeff's patch in it, the first patch now
fixes a (mostly harmless) 3.18 regression, and the second patch
is just a cosmetic cleanup, but there is no longer any dependency
between the two.

It looks like Greg is now handling most of the PCMCIA patches
in the absence of a subsystem maintainer, so I'll send him the
second one for 3.19, let me know if you still want me to send
him the first one too.

	Arnd
