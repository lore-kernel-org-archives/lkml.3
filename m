Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbbAOLjm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 06:39:42 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:45990 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259AbbAOLjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 06:39:11 -0500
Date: Thu, 15 Jan 2015 11:36:17 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: atull <atull@opensource.altera.com>, Pavel Machek <pavel@denx.de>,
        gregkh@linuxfoundation.org, hpa@zytor.com, monstr@monstr.eu,
        michal.simek@xilinx.com, rdunlap@infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        pantelis.antoniou@konsulko.com, robh+dt@kernel.org,
        grant.likely@linaro.org, iws@ovro.caltech.edu,
        linux-doc@vger.kernel.org, broonie@kernel.org, philip@balister.org,
        rubini@gnudd.com, s.trumtrar@pengutronix.de, jason@lakedaemon.net,
        kyle.teske@ni.com, nico@linaro.org, balbi@ti.com, m.chehab@samsung.com,
        davidb@codeaurora.org, rob@landley.net, davem@davemloft.net,
        cesarb@cesarb.net, sameo@linux.intel.com, akpm@linux-foundation.org,
        linus.walleij@linaro.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        devel@driverdev.osuosl.org, delicious.quinoa@gmail.com,
        dinguyen@opensource.altera.com, yvanderv@opensource.altera.com
Subject: Re: [PATCH v8 2/4] fpga manager: add sysfs interface document
Message-ID: <20150115113617.537965b3@lxorguk.ukuu.org.uk>
In-Reply-To: <20150114181258.GB16392@obsidianresearch.com>
References: <20150107084819.GA1887@amd>
	<alpine.DEB.2.02.1501091302370.30067@linuxheads99>
	<20150109205643.GA5761@amd>
	<20150112210134.687176ed@lxorguk.ukuu.org.uk>
	<20150112214314.GA18610@obsidianresearch.com>
	<20150113162847.2778b5a5@lxorguk.ukuu.org.uk>
	<20150113200032.GA16205@obsidianresearch.com>
	<alpine.DEB.2.02.1501131455130.30192@linuxheads99>
	<20150113222450.GA17475@obsidianresearch.com>
	<20150114160617.02fb9135@lxorguk.ukuu.org.uk>
	<20150114181258.GB16392@obsidianresearch.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2015 11:12:58 -0700
Jason Gunthorpe <jgunthorpe@obsidianresearch.com> wrote:

> On Wed, Jan 14, 2015 at 04:06:17PM +0000, One Thousand Gnomes wrote:
> 
> > and I think you effectively have the user usage covered here for such
> > things. It much like GPIO pins - we can describe them but we can also
> > declare they are not visible to the user.
> 
> A missing element in mainline is a kind of VFIO scheme to let user
> space access the FPGA registers designated for user space use.

Agreed entirely.

> A fixed bus interface block and dynamic reconfiguration for the
> remainder is probably the way to manage that. But, that implies that
> even a family of swappable FPGAs will have a DT overlay associated
> with it.

Or some other resource, it could be described by PCI but something is
going to need to describe it when we get to that state and something
will need to set up the IOMMU for it and potentially manage virtualising
it or assigning it to things like docker instances.
 
> Ideally, I could see wanting to have a file format that combines the
> overlay and FPGA bitfile. A loader tool would use the /dev/ interface
> to setup both elements. That would be much more robust than the
> current scheme I see (eg Xilinx) using where the bitfile and DT bit
> live in completely different places and have to be perfectly matched.

yes - there is a model for this in Linux already. Some of the audio
subsystems have "firmware" files distributed which are actually a
structured file that userspace parses to get a real set of firmware for
the controller and a set of descriptions for things like mixer controls.

They have the same basic problem - when you change firmware your control
interfaces may change so you need both descriptions together.

Alan
