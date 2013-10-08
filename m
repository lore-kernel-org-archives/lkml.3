Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104Ab3JHQuD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 12:50:03 -0400
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:7909
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751926Ab3JHQt7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 12:49:59 -0400
X-Forefront-Antispam-Report: CIP:66.35.236.232;KIP:(null);UIP:(null);IPV:NLI;H:SJ-ITEXEDGE02.altera.priv.altera.com;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VS-5(z551bizbb2dI98dI9371I936eI1432I4015Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2fh2a8h839h93fhd24hd2bhf0ah107ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1e23h1fe8h1ff5h1155h)
Message-ID: <1381250986.6062.3.camel@atx-linux-37>
Subject: Re: [RFC PATCH v2 0/1] FPGA subsystem core
From: Alan Tull <atull@altera.com>
To: Michal Simek <monstr@monstr.eu>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Machek <pavel@denx.de>, Michal Simek <michal.simek@xilinx.com>,
        <linux-kernel@vger.kernel.org>, Dinh Nguyen <dinguyen@altera.com>,
        Philip Balister <philip@balister.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Yves Vandervennet <rocket.yvanderv@gmail.com>,
        Kyle Teske <kyle.teske@ni.com>, Josh Cartwright <joshc@eso.teric.us>,
        Nicolas Pitre <nico@linaro.org>,
        Mark Langsdorf <mark.langsdorf@calxeda.com>,
        Felipe Balbi <balbi@ti.com>, <linux-doc@vger.kernel.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        David Brown <davidb@codeaurora.org>, Rob Landley <rob@landley.net>,
        "David S. Miller" <davem@davemloft.net>, Joe Perches <joe@perches.com>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 8 Oct 2013 11:49:46 -0500
In-Reply-To: <52540208.3090406@monstr.eu>
References: <524EC965.70701@monstr.eu> <20131004141646.GA9396@kroah.com>
	 <d700a91e-1319-4c35-895d-55e323c40703@email.android.com>
	 <524ED081.1040600@monstr.eu> <524EF0CE.4040002@zytor.com>
	 <524EFE76.70200@monstr.eu> <524F04FD.5020804@zytor.com>
	 <20131004233341.GA4028@kroah.com>
	 <20131004234929.GB3652@obsidianresearch.com>
	 <875b2a01-be5a-47d1-b89a-9385d54b9b64@email.android.com>
	 <20131005051056.GA7698@obsidianresearch.com>
	 <1c9db96e-7a36-4ec9-ab16-885780ce6de5@email.android.com>
	 <524FB756.3040203@monstr.eu>
	 <c59c68b8-2565-45c5-bfe9-574b76f3f9bc@email.android.com>
	 <5252B2F4.7050600@monstr.eu>
	 <ea858a91-1149-44cc-b2e1-bab1f579915e@email.android.com>
	 <5252CD30.3070305@monstr.eu>
	 <708b6f80-97a7-41a7-9d5c-fa8bd2a8e0c5@email.android.com>
	 <52540208.3090406@monstr.eu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-OriginatorOrg: altera.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-08 at 15:00 +0200, Michal Simek wrote:
> On 10/07/2013 05:07 PM, H. Peter Anvin wrote:
> > Special soft IP presenting a PCI device to the host.
> 
> ok. It means that you should need just different backend for this device
> which is able to communicate over PCI.
> 
> I still can't see why this case should be problematic for this fpga
> manager.
> As Jason pointed if this is just about JTAG emulation and your
> data is in different format then you have to create your backend
> which will support this configuration.
> I will want to look at gpio jtag emulation to be able to program
> different board. We have this support for u-boot and doing in Linux
> should be also possible.
> 
> I think the question is if we can live with 2/3 user interfaces.
> I tend to keep firmware one because it is covering a lot of common
> use cases and it can be easily to use.
> And then I don't have any preference if sysfs or char device

The sysfs and char device interface are equal, except I don't think it
is right to write binary data to a sysfs attribute.

The difference between these 3 options is that firmware will work for
some fixed use cases, but either the sysfs or char interface will work
for all the use cases.

Alan


> is better.
> 
> Thanks,
> Michal
> 


