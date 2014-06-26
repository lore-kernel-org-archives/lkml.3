Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567AbaFZTVm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 15:21:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58863 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbaFZTVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 15:21:36 -0400
Date: Thu, 26 Jun 2014 15:21:07 -0400
From: Greg KH <gregkh@linuxfoundation.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, chunkeey@googlemail.com,
        leedom@chelsio.com, cocci@systeme.lip6.fr, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: [PATCH 0/3] drivers: expand usage of request_firmware_direct()
Message-ID: <20140626192107.GB24337@kroah.com>
References: <1403649583-12707-1-git-send-email-mcgrof@do-not-panic.com>
 <s5hmwczve4i.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hmwczve4i.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 06:18:05PM +0200, Takashi Iwai wrote:
> At Tue, 24 Jun 2014 15:39:40 -0700,
> Luis R. Rodriguez wrote:
> > 
> > From: "Luis R. Rodriguez" <mcgrof@suse.com>
> > 
> > Takashi added request_firmware_direct() via bba3a87e9 through v3.14-rc1
> > which avoids the unnecessary delay introduced by using the udev firmware
> > loader in case the first try failed when loading we know loading "firmware"
> > is optional. The first use case was for microcode update but if drivers are
> > using it for optional configuration updates, custom EEPROMs, and other
> > junk other than firmware that should apply as well as good use cases,
> > specially if the driver already had a first phase in which it loaded
> > the first required firmware. While reviewing one driver I figured it'd
> > be best to try to give formalizing a check with SmPL. This isn't perfect
> > it had 1 false possitive drivers/fmc/fmc-fakedev.c on the entire kernel
> > run but my hope is this can be extended a bit more to build more
> > confidence, and then perhaps stuff it as a coccicheck.
> > 
> > I suppose this will not be required once and if we remove
> > CONFIG_FW_LOADER_USER_HELPER. Is that ever going away for good? I know
> > there was a recent attempt to remove the udev loader support but
> > it was unclear if the special alternative helper support would be
> > removed upstream from the kernel.
> 
> Actually a few weeks ago I sent a patch to make request_firmware()
> with usermode helper explicitly to be used by some drivers (like
> dell-rbu).  I hope Greg took it for 3.17.  Once when this patch is in,
> distros can turn off the usermode helper fallback gracefully, so no
> ugly timeout issue shouldn't happen.

I'll take that in a few days, been traveling at the moment...

thanks,

greg k-h
