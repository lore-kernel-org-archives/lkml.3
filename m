Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934329Ab3HILlr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 07:41:47 -0400
Received: from ni.piap.pl ([195.187.100.4]:50818 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934248Ab3HILlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 07:41:46 -0400
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, James Bottomley <JBottomley@Parallels.com>,
        "David S. Miller" <davem@davemloft.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <m3fvujgrcr.fsf@t19.piap.pl>
	<20130809093506.GN23006@n2100.arm.linux.org.uk>
	<m3bo57gnks.fsf@t19.piap.pl>
	<20130809104852.GQ23006@n2100.arm.linux.org.uk>
Date: Fri, 09 Aug 2013 13:38:21 +0200
In-Reply-To: <20130809104852.GQ23006@n2100.arm.linux.org.uk> (Russell King's
	message of "Fri, 9 Aug 2013 11:48:52 +0100")
MIME-Version: 1.0
Message-ID: <m338qjgklu.fsf@t19.piap.pl>
Content-Type: text/plain
Subject: Re: DMA masks
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE,
	 bases: 20130809 #10903734, check: 20130809 clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux <linux@arm.linux.org.uk> writes:

> No.  If dma_mask is NULL, then dma_set_mask() will return -EIO no matter
> what.  If dma_mask is non-NULL, dma_set_mask() will succeed if the mask
> is supported by the hardware.  For example, on x86:

> and this is the same pattern we implement on ARM.  So, a valid dma_mask
> pointer pointing at a variable holding zero can have a supported mask
> set.

Right. So is it a work around systems unable to provide DMA to devices,
whose drivers would try to use the DMA (not aware of the system
limitations)?

Do you know, by chance, of any particular case using this NULL pointer
trick to prevent (I suppose) a driver from doing DMA?

> Have you looked at my massive dma-masks patch series earlier this week?
> Obviously you haven't...

Right again, no time for basically anything here :-( Will look.

> The separate coherent and streaming masks are only required for a very
> small subset of devices (rather systems - non-ARM I add).  For the
> general case, especially on ARM where the above pattern seems to be
> very prevalent, this does not apply; the two masks are always the same.
> Many people took the above shortcut, and while not strictly correct, it
> is a work-around for the shortcoming in the core device code.

That's my impression, too. BTW I personally have a device (PCI card)
which have different masks (so it's also the case with devices). Old
story though.

> Greg has agreed to having stream_dma_mask in the struct device, but
> even so I think removing the direct initialization from drivers is a good
> idea.

Definitely. I'll take a look, Thanks.
-- 
Krzysztof Halasa

Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
