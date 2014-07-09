Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886AbaGIAYI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 20:24:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38367 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbaGIAYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 20:24:06 -0400
Date: Tue, 8 Jul 2014 17:24:05 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: Takashi Iwai <tiwai@suse.de>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, chunkeey@googlemail.com,
        leedom@chelsio.com, cocci@systeme.lip6.fr, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-firmware@kernel.org
Subject: Re: [PATCH 0/3] drivers: expand usage of request_firmware_direct()
Message-ID: <20140709002405.GA7025@kroah.com>
References: <1403649583-12707-1-git-send-email-mcgrof@do-not-panic.com>
 <s5hmwczve4i.wl%tiwai@suse.de>
 <20140708222536.GA7745@kroah.com>
 <20140708235244.GS27687@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140708235244.GS27687@wotan.suse.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 01:52:44AM +0200, Luis R. Rodriguez wrote:
> On Tue, Jul 08, 2014 at 03:25:36PM -0700, Greg KH wrote:
> > On Thu, Jun 26, 2014 at 06:18:05PM +0200, Takashi Iwai wrote:
> > > At Tue, 24 Jun 2014 15:39:40 -0700,
> > > Luis R. Rodriguez wrote:
> > > > 
> > > > From: "Luis R. Rodriguez" <mcgrof@suse.com>
> > > > 
> > > > Takashi added request_firmware_direct() via bba3a87e9 through v3.14-rc1
> > > > which avoids the unnecessary delay introduced by using the udev firmware
> > > > loader in case the first try failed when loading we know loading "firmware"
> > > > is optional. The first use case was for microcode update but if drivers are
> > > > using it for optional configuration updates, custom EEPROMs, and other
> > > > junk other than firmware that should apply as well as good use cases,
> > > > specially if the driver already had a first phase in which it loaded
> > > > the first required firmware. While reviewing one driver I figured it'd
> > > > be best to try to give formalizing a check with SmPL. This isn't perfect
> > > > it had 1 false possitive drivers/fmc/fmc-fakedev.c on the entire kernel
> > > > run but my hope is this can be extended a bit more to build more
> > > > confidence, and then perhaps stuff it as a coccicheck.
> > > > 
> > > > I suppose this will not be required once and if we remove
> > > > CONFIG_FW_LOADER_USER_HELPER. Is that ever going away for good? I know
> > > > there was a recent attempt to remove the udev loader support but
> > > > it was unclear if the special alternative helper support would be
> > > > removed upstream from the kernel.
> > > 
> > > Actually a few weeks ago I sent a patch to make request_firmware()
> > > with usermode helper explicitly to be used by some drivers (like
> > > dell-rbu).  I hope Greg took it for 3.17.  Once when this patch is in,
> > > distros can turn off the usermode helper fallback gracefully, so no
> > > ugly timeout issue shouldn't happen.
> > 
> > That patch is now merged, so this series should not be needed anymore,
> > right?
> 
> Now that it is merged, and another patch I posted which you also merged about
> printing differences, the main difference between request_firmware() and
> request_firmware_direct() for distributions that did not enable the fw
> loader helper is just a printk. That's all. While the difference is minor
> this series addresses a few drivers that we know have firmware that is
> optional, so a printk is indeed not really needed as otherwise it can confuse
> users in terms of expectations. The SmPL grammar for this series could
> likely be expanded to cover other uses cases but obviously this is not
> critical and at best best effort. For distributions that stay in the stone age
> and do not disable the fw loader helper this will speed up boot for a few use
> cases. This series still applies then.
> 
> Whether or not its required or optional for firmware to be loaded for a driver
> is an example small difference in specifications that I expect drivers /
> subsystems to be able to make, I suspect the differences might grow in the
> future so I rather keep these requirements well annonated for now. Another
> example difference I am looking into is whether or not firmware should be
> digitally signed. While it may be questionable whether or not this is needed
> for actual firmware that runs on microprocessors some subsystems might want to
> use this to abandon other udev helpers which simply throw data over, one of
> which I am looking into replacing is CRDA for the regulatory database. We
> recently ran into some snags when the internal regdb is used and we use a
> parser, having the ability to load it directly using request_firmware_direct()
> with digital signature support as an option would enable us to simplify how the
> redb is used/parsed on both embedded and non-embedded systems.

I'm confused, do you want me to review your patches or not?

If so, care to resend them, they are now purged from my patch queue...

thanks,

greg k-h
