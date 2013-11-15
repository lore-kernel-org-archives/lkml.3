Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022Ab3KOVYz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 16:24:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36100 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385Ab3KOVYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 16:24:49 -0500
Date: Sat, 16 Nov 2013 06:24:55 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Prarit Bhargava <prarit@redhat.com>, Ming Lei <ming.lei@canonical.com>,
        Borislav Petkov <bp@suse.de>, x86@kernel.org,
        amd64-microcode@amd64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/4] Add request_firmware_direct() for microcode loader
Message-ID: <20131115212455.GA14897@kroah.com>
References: <1384257736-3647-1-git-send-email-tiwai@suse.de>
 <s5hk3g97k7i.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hk3g97k7i.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 04:34:09PM +0100, Takashi Iwai wrote:
> At Tue, 12 Nov 2013 13:02:12 +0100,
> Takashi Iwai wrote:
> > 
> > Hi,
> > 
> > this is a revised patch series to introduce request_firmware_direct()
> > helper for avoiding the lengthy udev issue on microcode loader.
> > The original problem was stated in Prarit's post:
> >    https://lkml.org/lkml/2013/10/28/221
> > 
> > In short, microcode loader probes non-existing firmware files (which
> > are cases with every new chip), and each probe takes 60 seconds,
> > resulting in too long time until completed.
> > 
> > This solution is simply avoiding the udev fallback in
> > request_firmware() explicitly for drivers like microcode.
> > 
> > Of course, this doesn't mean to throw away further optimizations like
> > Prarit's patch.  It can be implemented in parallel with this.
> > 
> > 
> >  [PATCH v3 1/4] firmware: Introduce request_firmware_direct()
> >  [PATCH v3 2/4] microcode: Use request_firmware_direct()
> >  [PATCH v3 3/4] firmware: Use bit flags instead of boolean combos
> >  [PATCH v3 4/4] firmware: Suppress fallback warnings when CONFIG_FW_LOADER_USER_HELPER=n
> > 
> > v1->v2: Rebased on linux-next, add a fix for a bogus warning message
> > v2->v3: Convert to bit flags, fix warning message differently
> > 
> > 
> > Greg, could you take these patches through your driver tree, as
> > most of fixes are about the firmware loader itself.
> 
> Greg, any chance to take a look at these patches?

I'm traveling at the moment, in Korea this week.  I'll take a look at
them after 3.13-rc1 is out, as I can't do anything with patches until
then.  Don't worry, they aren't lost.

thanks,

greg k-h
