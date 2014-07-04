Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759324AbaGDRAo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 13:00:44 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:36938 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754701AbaGDRAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 13:00:42 -0400
Date: Fri, 4 Jul 2014 11:00:28 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        Prabhakar Kushwaha <prabhakar@freescale.com>
Subject: Re: [PATCH] arm64: PCI(e) arch support
Message-ID: <20140704170028.GB1736@obsidianresearch.com>
References: <1404422876-1160-1-git-send-email-tinamdar@apm.com>
 <53B5F81B.8010801@freescale.com>
 <20140704094440.GC6501@e106497-lin.cambridge.arm.com>
 <4342569.JSAyWBcJn2@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4342569.JSAyWBcJn2@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2014 at 12:21:00PM +0200, Arnd Bergmann wrote:

> However, what do we do about PCI hosts that can be used with different
> kinds of systems? Do we assume that they all do PCI resource allocation?
> Can we decide this on a per host driver basis, or do we need to introduce
> an extension to the PCI DT binding to make that decision?

If the firmware sets everything up, and standard ECAM/CAM config space
is provided, then Will's simple generic driver should be selected. The
kernel shouldn't even be using code to manipulate the host
bridge. This is the x86 model.

If it is more embedded focused and firmware doesn't do much, then a
different compatible string and different driver can be used that does
have any special setup code..

The HW needs to be designed to support this, so it actually has to
imeplement configuration access properly, it can't split the config
space for the bridge with config space for the downstream, for
instance. It must implement something sensible for root port bridge
windows, and a few other common sense things.

Things are going to need to work like this anyhow on any HW that
expects to suport ACPI...

It is OK for the kernel to reconfigure the BARs and other things as it
likes, so long as the configuration access mechanism is working
properly according to the spec. IIRC it does a bit of a hybrid on x86
where it tries to leave things alone that are OK, and fix up things
that are not OK.

Jason
