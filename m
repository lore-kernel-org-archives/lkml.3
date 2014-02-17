Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079AbaBQTyj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 14:54:39 -0500
Received: from imap.thunk.org ([74.207.234.97]:59123 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847AbaBQTyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 14:54:38 -0500
Date: Mon, 17 Feb 2014 14:54:32 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>, Peter Hurley <peter@hurleysoftware.com>,
        lkml <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@redhat.com>
Subject: Re: Lenovo X240 (haswell) suspend-to-ram hangs on 3-14.0-rc2
Message-ID: <20140217195432.GE16660@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Jeff Chua <jeff.chua.linux@gmail.com>, Takashi Iwai <tiwai@suse.de>,
	Peter Hurley <peter@hurleysoftware.com>,
	lkml <linux-kernel@vger.kernel.org>,
	Dave Airlie <airlied@redhat.com>
References: <CAAJw_ZvX2AfS8COiNdN9gi_1xJ4L_vL=ROCzcLL3u0h51kuX3Q@mail.gmail.com>
 <52FCFD92.7040109@hurleysoftware.com>
 <s5hiosi3osp.wl%tiwai@suse.de>
 <CAAJw_ZsoO=kd6cVM3HYrkim5K0RKrnDXYGgodNNQmHVYs19a8A@mail.gmail.com>
 <s5hha8123vu.wl%tiwai@suse.de>
 <CAAJw_ZtviRCtaC4-3_ubkYuEt+LYstwbi6qus-5GOoOLYhfecw@mail.gmail.com>
 <s5hk3cxzce0.wl%tiwai@suse.de>
 <CAAJw_ZtK+jTOhCPZKhCu_f2nHwUahE8jcR8G4+FbocEc66Ei4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAJw_ZtK+jTOhCPZKhCu_f2nHwUahE8jcR8G4+FbocEc66Ei4g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 01:54:40AM +0800, Jeff Chua wrote:
> Any suggestion on how to debug this? bisect? Ted, does your T540p work
> with CONFIG_SND_HDA_INTEL=y instead of "m" ?

I can give this a try on my next kernel rebuild.

BTW, I am noticing some other suspend-to-ram wierdnesses.  In
particular, in about 1 in 10 to 1 in 20 suspend, the led lights on the
ethernet port are stuck on after the suspend, which I suspect means
we're not shutting down the peripherals all the way, and thus wasting
battery while the laptop is suspended.

Also, I am using a password to secure my HDD, and in most cases, the
HDD is left powered on so I can still access the HDD.  However, about
10% of the time, the HDD seems to get completely powered down, such
that it needs to have the password sent again to unlock the drive.
Since I am using the BIOS to send the password to the HDD, it means I
have to force a reboot in order to regain access to the drive.

So this is either a S2R bug in that we're not powering down the HDD
sufficiently to maximize power savings most of the time, or that we
need to be able to reauthenticate the HDD to unlock it after a
suspend/resume cycle --- something which it sounds like Linux doesn't
support all that well.  (I only recently started using HDD/SSD
passwords because I now have devices with FDE, and I've been trying to
secure my computing environment as much as possible.)

       	  	    		   	- Ted
