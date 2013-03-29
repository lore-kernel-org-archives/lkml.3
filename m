Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711Ab3C2LbP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 07:31:15 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:46221 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283Ab3C2LbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 07:31:14 -0400
Message-ID: <1364556661.3559.63.camel@thor.lan>
Subject: Re: [PATCH] firewire: Enable physical DMA above 4GB
From: Peter Hurley <peter@hurleysoftware.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Date: Fri, 29 Mar 2013 07:31:01 -0400
In-Reply-To: <515578D0.9090701@ladisch.de>
References: <1364307734-27709-1-git-send-email-peter@hurleysoftware.com>
		 <20130326195653.470b09d6@stein> <1364324929.3866.13.camel@thor.lan>
		 <20130326213532.38a7bd4c@stein> <20130329114409.3634676e@stein>
	 <1364554250.3559.61.camel@thor.lan> <515578D0.9090701@ladisch.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-29 at 12:19 +0100, Clemens Ladisch wrote:
> Peter Hurley wrote:
> > On Fri, 2013-03-29 at 11:44 +0100, Stefan Richter wrote:
> >>> On Mar 26 Peter Hurley wrote:
> >>>> The FW643e-2 is natively PCIe (not behind a bridge) and supports phys
> >>>> DMA past 4GB (the datasheet says all 48 bits but I can only test it out
> >>>> to 10GB).
> >>>>
> >>>> I thought the FW643e was as well? You'll have to test that out :)
> >>
> >> Does lspci or something similar show which PCI devices are capable of 64 bit
> >> wide addressing?
> >
> > Not definitively.
> >
> > Usually (but not always), if the host registers are 64-bit addressable,
> > then the device supports DAC.
> 
> DACs are a feature of conventional PCI.
> 
> All PCI Express devices are 64-bit addressable.  In the lspci output, PCIe
> devices have the "Express" capability.

The "device" could be sitting behind a PCIe-PCI bridge that _only_
supports the host window for 64-bit. All other 64-bit decodes could
return garbage.

> However, whether a device can *generate* 64-bit DMA requests is completely
> device-specific.


