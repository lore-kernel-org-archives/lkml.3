Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751698AbaKFMrR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 07:47:17 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58352 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbaKFMrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 07:47:13 -0500
Date: Thu, 6 Nov 2014 13:47:11 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sebastian Reichel <sre@kernel.org>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, freemangordon@abv.bg
Subject: Re: N900 modem support in 3.18-rc1
Message-ID: <20141106124711.GA26944@amd>
References: <20141104205117.GA17606@amd>
 <201411052137.31452@pali>
 <20141105203918.GA29199@amd>
 <201411052206.05379@pali>
 <20141105220359.GA32052@amd>
 <20141105234555.GA7097@earth.universe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141105234555.GA7097@earth.universe>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> On Wed, Nov 05, 2014 at 11:03:59PM +0100, Pavel Machek wrote:
> > > Maybe you need to enable modem?
> > > 
> > > This is n900 init sequence from script: nokia-n900-configs.sh
> > 
> > From the dts, it looks like this should somehow work without this.
> 
> Right :) The n900-modem driver will take care of this if the "pm"
> parameter is set to 1 (which should be the default).

I actually had pm=0 on the command line, but I removed it now, and no
change:

root@n900:~# find /sys/bus/hsi/devices/n900-modem/
/sys/bus/hsi/devices/n900-modem/
/sys/bus/hsi/devices/n900-modem/power
/sys/bus/hsi/devices/n900-modem/power/control
/sys/bus/hsi/devices/n900-modem/power/runtime_active_time
/sys/bus/hsi/devices/n900-modem/power/autosuspend_delay_ms
/sys/bus/hsi/devices/n900-modem/power/runtime_status
/sys/bus/hsi/devices/n900-modem/power/runtime_suspended_time
/sys/bus/hsi/devices/n900-modem/modalias
/sys/bus/hsi/devices/n900-modem/driver
/sys/bus/hsi/devices/n900-modem/subsystem
/sys/bus/hsi/devices/n900-modem/uevent
root@n900:~# cat /proc/cmdline 
root=/dev/nfs nfsroot=192.168.1.6:/srv/nfs/n900 rw
ip=192.168.1.8::192.168.1.6:255.255.255.192::usb0:  no-omap-wd
no-ext-wd console=tty0
root@n900:~# 

Let me try with explicit =1. .. aha, that helps. Thanks!

Do you have an example client that can talk to ofonod?

What is needed to get voice calls to work?

Best regards,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
