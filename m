Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616Ab3CFAGa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 19:06:30 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:55575 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752888Ab3CFAG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 19:06:29 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Borislav Petkov <bp@alien8.de>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>, Jiri Slaby <jslaby@suse.cz>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>, e1000-devel@lists.sourceforge.net,
        Bruce Allan <bruce.w.allan@intel.com>
Subject: Re: Uhhuh. NMI received for unknown reason 2c on CPU 0.
Date: Wed, 06 Mar 2013 01:13:23 +0100
Message-ID: <1372053.VT5YxPEdsx@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc1+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130305112737.GE4881@pd.tnic>
References: <20130214191234.GH5700@pd.tnic> <1362479341.8626.18.camel@jtkirshe-mobl> <20130305112737.GE4881@pd.tnic>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 05, 2013 12:27:37 PM Borislav Petkov wrote:
> On Tue, Mar 05, 2013 at 02:29:01AM -0800, Jeff Kirsher wrote:
> > On Tue, 2013-03-05 at 11:14 +0100, Borislav Petkov wrote:
> > > 
> > > On Tue, Mar 05, 2013 at 02:02:48AM -0800, Jeff Kirsher wrote:
> > > > They are in my queue of e1000e patches for net and are being testing
> > > > currently. I should be able to push them upstream this week.
> > > 
> > > Right, if you'd like me to run them here too, let me know. 
> > 
> > Any additional testing is very much appreciated, so feel free to test
> > the patches with what hardware you have.
> 
> Yep, it looks good, machine suspends ok again. I'll watch it in the next
> couple of days.
> 
> The only problem that remains is this:
> 
> [  103.137024] xhci_hcd 0000:00:14.0: power state changed by ACPI to D3cold
> [  103.161032] ehci-pci 0000:00:1d.0: power state changed by ACPI to D3cold
> [  103.462328] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: Rx/Tx
> [  103.462342] e1000e 0000:00:19.0 eth0: 10/100 speed: disabling TSO
> [  108.472847] Uhhuh. NMI received for unknown reason 3c on CPU 0.	<---
> [  108.472850] Do you have a strange power saving mode enabled?
> [  108.472851] Dazed and confused, but trying to continue
> 
> AFAIR, Rafael said it had something to do with the suspend kernel not
> picking up settings done to the main kernel on time. Or something to
> that effect, my memory is hazy.

I suspected that during resume from hibernation the boot kernel (the one that
loaded the image) did something to hardware and the restored kernel didn't
handle that change properly.  It is hard do say what piece of hardware that
was, however (it might or might not be the NIC, it may be pure coincidence
that the NMI messages appear in the log at this point).

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
