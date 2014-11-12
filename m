Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342AbaKLSPp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 13:15:45 -0500
Received: from mout.web.de ([212.227.15.3]:59111 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753081AbaKLSPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 13:15:44 -0500
MIME-Version: 1.0
Message-ID: <trinity-d52531ba-b124-48d8-aba8-fd4dd881b953-1415816137634@3capp-webde-bs19>
From: devzero@web.de
To: "One Thousand Gnomes" <gnomes@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, rafael.j.wysocki@intel.com
Subject: Re: dmesg spam: "PnPBIOS: pnp_dock_thread: unexpected status 0x5
 flooding"
Content-Type: text/plain; charset=UTF-8
Date: Wed, 12 Nov 2014 19:15:37 +0100
Importance: normal
Sensitivity: Normal
In-Reply-To: <20141110135404.2de623a5@alan.etchedpixels.co.uk>
References: <trinity-0270e0ae-a135-4789-9ed2-f8fd1f7cff71-1415318071046@3capp-webde-bs13>,
 <20141110135404.2de623a5@alan.etchedpixels.co.uk>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K0:QPH8pSMuoigoXR/dCmvknTjfHt/M9RY9GP0FXZGY51W
 MDwn+swk4ya3bmsNv2YXccxYXK88RQ+AEBD43pKKwkaeUB8Spv
 e0xv6nTqp5c1D2U1absejIFHudhd1643pJ056iDWwQj5socbO+
 MIBMdQIzdBgDguUZAFm+JW4wZA67nS5Hgyr3+PwFHzNc1Ny3n4
 E2Yj2V9rVSabKkySQkQAyEpfelhDJsHOHPdK3FetBAoWxWj2e7
 mee4tlq7shlsQx8QLqzsGeLdgQ5jEXrdvyomvNrIFuappdDW9n
 NI0nqnIaAHJWcBc0TAUleeYeLir
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Change the default to
> 
>               default:
>                   pnpbios_print_status("pnp_dock..... etc)
> 	          printk(KERN_ERR "PnPBIOS: Disabling dock monitoring\n");
> 	          complete_and_exit(&unload_sem, 0);
> 
> that should produce you one error message, a warning that dock monitoring
> is being disabled and then it should stfu.
> 
> If you can let us know if that does the trick then I can push it upstream.

works perfectly - thanks very much !

[    9.712027] Switching to clocksource tsc
[    9.903305] udevd[42]: starting version 175
[   10.637309] natsemi dp8381x driver, version 2.1, Sept 11, 2006
[   10.637345]   originally by Donald Becker <becker@scyld.com>
[   10.637371]   2.4.x kernel port by Jeff Garzik, Tjeerd Mulder
[   10.700287] natsemi 0000:00:0f.0: setting latency timer to 64
[   10.880548] natsemi eth0: NatSemi DP8381[56] at 0x8010000 (0000:00:0f.0), 00:00:00:00:00:00, IRQ 10, port TP.
[   11.025143] PnPBIOS: pnp_dock_thread: unexpected status 0x5
>[  11.026800] PnPBIOS: Disabling dock monitoring
[   11.518269] SCSI subsystem initialized
[   11.550857] usbcore: registered new interface driver usbfs


> I've not seen other reports of pnp_dock_thread errors with a real dock.
> The only reports at all are a couple of old ones in google that seem to
> be similar and a Debian bug (294652) which appears to be your bug so I'd

indeed - seems a rather weird/rare/old one. 

glad that you fixed it, though. thanks again!

roland


> Gesendet: Montag, 10. November 2014 um 14:54 Uhr
> Von: "One Thousand Gnomes" <gnomes@lxorguk.ukuu.org.uk>
> An: devzero@web.de
> Cc: linux-kernel@vger.kernel.org, rafael.j.wysocki@intel.com
> Betreff: Re: dmesg spam: "PnPBIOS: pnp_dock_thread: unexpected status 0x5 flooding"
>
> On Fri, 7 Nov 2014 00:54:31 +0100
> devzero@web.de wrote:
> 
> > Hi, 
> > 
> > on an ancient GX1 Geode embedded board (Evo T20/Wyse wt3235le Thin Client, which are cheap (<$10) and low power x86 embeded platform) , dmesg is getting constantly spammed with "PnPBIOS: pnp_dock_thread: unexpected status 0x5" during and after boot. 
> > 
> > Any ideas what this means and how to stop that?
> > 
> > It seems it comes from drivers/pnp/pnpbios/bioscalls.c -> pnpbios_print_status()  
> > 
> > Tried adding pnpbios=off, but with that the system does not boot anymore.
> > 
> > Being curious, why a non-existing docking-station is being "polled at regular intervals" (i.e. every 2 seconds - see drivers/pnp/pnpbios/core.c )
> 
> We poll for a dock, and if the BIOS reports that the function is not
> supported we then exit the thread.
> 
> > 
> > >From http://books.google.de/books?id=ibLa4I5EnC4C&pg=PA231&lpg=PA231&dq=pnp+docking+bios&source=bl&ots=ekCFm34U_B&sig=9Z9L55IAL7_3NtuM10jT3serncM&hl=de&sa=X&ei=mAZcVILnJsviO-r5gNgI&ved=0CCsQ6AEwAQ#v=onepage&q=pnp%20docking%20bios&f=false   i read:  "Function 05h - Get Docking Status Information at page 251" 
> 
> The spec is available at:
> 
> http://download.intel.com/support/motherboards/desktop/sb/pnpbiosspecificationv10a.pdf
>  
> > it  seems this is being the result of a "docking event" ? Does this mean, my system is erroneusly generating such docking events, even if there is no docking station at all?
> 
> Your BIOS appears to be making strange replies. Any error ought to have
> the top bit set, so its reporting a nonsense value for some reason.
> 
> I've not seen other reports of pnp_dock_thread errors with a real dock.
> The only reports at all are a couple of old ones in google that seem to
> be similar and a Debian bug (294652) which appears to be your bug so I'd
> suggest testing the following
> 
> 
> Change the default to
> 
>               default:
>                   pnpbios_print_status("pnp_dock..... etc)
> 	          printk(KERN_ERR "PnPBIOS: Disabling dock monitoring\n");
> 	          complete_and_exit(&unload_sem, 0);
> 
> that should produce you one error message, a warning that dock monitoring
> is being disabled and then it should stfu.
> 
> If you can let us know if that does the trick then I can push it upstream.
> 
> Alan
> 
