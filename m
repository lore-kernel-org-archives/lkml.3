Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab3JERek (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 13:34:40 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:40002 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753189Ab3JEReh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 13:34:37 -0400
Date: Sat, 5 Oct 2013 11:33:42 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, monstr@monstr.eu,
        Pavel Machek <pavel@denx.de>, Michal Simek <michal.simek@xilinx.com>,
        linux-kernel@vger.kernel.org, Alan Tull <atull@altera.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        Philip Balister <philip@balister.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Yves Vandervennet <rocket.yvanderv@gmail.com>,
        Kyle Teske <kyle.teske@ni.com>, Josh Cartwright <joshc@eso.teric.us>,
        Nicolas Pitre <nico@linaro.org>,
        Mark Langsdorf <mark.langsdorf@calxeda.com>,
        Felipe Balbi <balbi@ti.com>, linux-doc@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        David Brown <davidb@codeaurora.org>, Rob Landley <rob@landley.net>,
        "David S. Miller" <davem@davemloft.net>, Joe Perches <joe@perches.com>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH v2 0/1] FPGA subsystem core
Message-ID: <20131005173342.GA32268@obsidianresearch.com>
References: <d700a91e-1319-4c35-895d-55e323c40703@email.android.com>
 <524ED081.1040600@monstr.eu>
 <524EF0CE.4040002@zytor.com>
 <524EFE76.70200@monstr.eu>
 <524F04FD.5020804@zytor.com>
 <20131004233341.GA4028@kroah.com>
 <20131004234929.GB3652@obsidianresearch.com>
 <875b2a01-be5a-47d1-b89a-9385d54b9b64@email.android.com>
 <20131005051056.GA7698@obsidianresearch.com>
 <1c9db96e-7a36-4ec9-ab16-885780ce6de5@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1c9db96e-7a36-4ec9-ab16-885780ce6de5@email.android.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 04, 2013 at 10:34:10PM -0700, H. Peter Anvin wrote:
> I do it all the time.
> 
> JAM/STAPL seems to me to be more used for exotic connections to
> serial flash for persistent programming.

The FPGA tools write two kinds of SVF/JAM/STAPL files, one is ment to
be replayed the to FPGA itself (what I was talking about), and one is
ment to be replayed to the vendor's family of configuration PROMS (aka
funky serial FLASH)

Programming the PROM in-ciruit/in-field via JTAG is normal, while
programming the FPGA via JTAG is uncommon. This proposed FPGA
susbsytem is about programming SRAM FPGAs, not FLASH ...

Fortunately these PROMs are on their way out, modern FPGAs can be
directly connected to normal NOR FLASH and you can program the NOR
via drivers/mtd :)

Regards,
Jason
