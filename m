Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124Ab3JHIos (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 04:44:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44521 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751725Ab3JHIoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 04:44:46 -0400
Message-ID: <1381221672.5823.30.camel@nilsson.home.kraxel.org>
Subject: Re: [PATCH 1/2] hyperv-fb: add pci stub
From: Gerd Hoffmann <kraxel@redhat.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        "open list:Hyper-V CORE AND..." <devel@linuxdriverproject.org>,
        "open list:FRAMEBUFFER LAYER" <linux-fbdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Date: Tue, 08 Oct 2013 10:41:12 +0200
In-Reply-To: <f5746838b7654aac98a5753d669196b4@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1380714911-6254-1-git-send-email-kraxel@redhat.com>
	 <465ef0cb45e04bcc94c4788c0d930c4d@SN2PR03MB061.namprd03.prod.outlook.com>
	 <1381128633.13574.3.camel@nilsson.home.kraxel.org>
	 <f5746838b7654aac98a5753d669196b4@SN2PR03MB061.namprd03.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mo, 2013-10-07 at 17:12 +0000, KY Srinivasan wrote:
> 
> > -----Original Message-----
> > From: Gerd Hoffmann [mailto:kraxel@redhat.com]
> > Sent: Sunday, October 06, 2013 11:51 PM
> > To: KY Srinivasan
> > Cc: Haiyang Zhang; Jean-Christophe Plagniol-Villard; Tomi Valkeinen; open
> > list:Hyper-V CORE AND...; open list:FRAMEBUFFER LAYER; open list
> > Subject: Re: [PATCH 1/2] hyperv-fb: add pci stub
> > 
> > On Mi, 2013-10-02 at 14:29 +0000, KY Srinivasan wrote:
> > >
> > > > This patch adds a pci stub driver to hyper-fb.  The hyperv framebuffer
> > > > driver will bind to the pci device then, so linux kernel and userspace
> > > > know there is a proper kernel driver for the device active.  lspci shows
> > > > this for example:
> > 
> > > Gerd,
> > >
> > > Thanks for doing this. This certainly will address some of the issues that are
> > reported. I do have a question though - how would this work if we don't have PCI
> > bus in the guest.
> > 
> > The hyperv framebuffer driver wouldn't work in the first place then as
> > it looks up the framebuffer address in pci config space (see hvfb_getmem
> > function).
> 
> We are going to fix this as we move this code to run on our UEFI firmware. 

Hmm, windows server 2012 seems to have no option to enable uefi.  So I
guess this is still in development?  How this is going to look like?

Probably you are going for pure uefi firmware, without csm, to be able
to leave all the legacy bios stuff behind in uefi mode.  Therefore no
vesa bios support.  efi drivers for vmbus network/storage/display/input
in the firmware.  No legacy ide/vga pci devices.  Correct?

The linux kernel will come up with efifb then, switching over to
hyperv-fb once the driver is loaded.  The hyperv-fb pci stub driver will
not bind to the hyperv vga pci device if it isn't present in the guest.
hyperv-fb will load just fine nevertheless (once hvfb_getmem is fixed to
not depend on the pci device config space).  The pci stub added by the
patch and the vmbus driver in hyperv-fb are completely independent.

cheers,
  Gerd


