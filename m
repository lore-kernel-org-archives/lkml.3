Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234Ab3AYQyz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 11:54:55 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:44949 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756137Ab3AYQyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 11:54:52 -0500
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmztM8TOFGji0LFus=
X-RZG-CLASS-ID: mo00
Date: Fri, 25 Jan 2013 17:54:44 +0100
From: Olaf Hering <olaf@aepfle.de>
To: KY Srinivasan <kys@microsoft.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] x86: Hyper-V: register clocksource only if its advertised
Message-ID: <20130125165443.GA15833@aepfle.de>
References: <1359121036-16309-1-git-send-email-olaf@aepfle.de>
 <761b736ff1854810bfe272961248e6d2@BLUPR03MB050.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <761b736ff1854810bfe272961248e6d2@BLUPR03MB050.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21.rev5632 (2013-01-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, KY Srinivasan wrote:

> 
> 
> > -----Original Message-----
> > From: Olaf Hering [mailto:olaf@aepfle.de]
> > Sent: Friday, January 25, 2013 8:37 AM
> > To: linux-kernel@vger.kernel.org
> > Cc: Olaf Hering; stable@kernel.org; KY Srinivasan; Greg KH
> > Subject: [PATCH] x86: Hyper-V: register clocksource only if its advertised
> > 
> > Enable hyperv_clocksource only if its advertised as a feature.
> > XenServer 6 returns the signature which is checked in
> > ms_hyperv_platform(), but it does not offer all features. Currently the
> > clocksource is enabled unconditionally in ms_hyperv_init_platform(), and
> > the result is a hanging guest.
> > 
> > Hyper-V spec Bit 1 indicates the availability of Partition Reference
> > Counter.  Register the clocksource only if this bit is set.
> > 
> > The guest in question prints this in dmesg:
> >  [    0.000000] Hypervisor detected: Microsoft HyperV
> >  [    0.000000] HyperV: features 0x70, hints 0x0
> > 
> > This bug can be reproduced easily be setting 'viridian=1' in a HVM domU
> > .cfg file. A workaround without this patch is to boot the HVM guest with
> > 'clocksource=jiffies'.
> 
> I am curious why you are setting viridian=1 for a Linux HVM guest. Initially when
> I did the Hyper-V emulation work on Xen, this configuration flag would be set only
> for Windows guests since the idea was to run the "enlightened" Windows on Xen.
> While the current Xen emulation code does not emulate "Partition Reference Counter"
> there is no guarantee that Xen would not do this in the future. Perhaps dealing with this issue
> by identifying the guest (via the viridian domain or not) may be a safer approach?

I'm not sure if XenServer does that per default, but I used the
viridian= flag to reproduce the report.
If Xen starts to emulate the "Partition Reference Counter" it should
also advertise this emulation with the feature flag. Are you saying that
checking for features is not the right approach?

Olaf
