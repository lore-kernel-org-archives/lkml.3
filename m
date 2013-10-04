Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354Ab3JDS0o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 14:26:44 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:18779 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753791Ab3JDS0m convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 14:26:42 -0400
X-Forefront-Antispam-Report: CIP:66.35.236.232;KIP:(null);UIP:(null);IPV:NLI;H:SJ-ITEXEDGE02.altera.priv.altera.com;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VS-5(z551bizbb2dI98dI9371I936eI1432I4015Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275dhz2fh2a8h839h93fhd24hd2bhf0ah107ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1e23h1fe8h1ff5h1155h)
Message-ID: <1380911194.2920.14.camel@atx-linux-37>
Subject: Re: [RFC PATCH v2 0/1] FPGA subsystem core
From: Alan Tull <atull@altera.com>
To: Michal Simek <monstr@monstr.eu>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Machek <pavel@denx.de>, Michal Simek <michal.simek@xilinx.com>,
        <linux-kernel@vger.kernel.org>, Dinh Nguyen <dinguyen@altera.com>,
        Philip Balister <philip@balister.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
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
Date: Fri, 4 Oct 2013 13:26:34 -0500
In-Reply-To: <524EFE76.70200@monstr.eu>
References: <cover.1380727889.git.michal.simek@xilinx.com>
	 <524C6D64.8080801@zytor.com> <20131003064915.GB17155@amd.pavel.ucw.cz>
	 <524EC965.70701@monstr.eu> <20131004141646.GA9396@kroah.com>
	 <d700a91e-1319-4c35-895d-55e323c40703@email.android.com>
	 <524ED081.1040600@monstr.eu> <524EF0CE.4040002@zytor.com>
	 <524EFE76.70200@monstr.eu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-OriginatorOrg: altera.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-10-04 at 19:44 +0200, Michal Simek wrote:
> On 10/04/2013 06:46 PM, H. Peter Anvin wrote:
> > On 10/04/2013 07:28 AM, Michal Simek wrote:
> >> On 10/04/2013 04:21 PM, H. Peter Anvin wrote:
> >>> Yes; I never got too corner Greg ;)
> >>>
> >>> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> >>>> On Fri, Oct 04, 2013 at 03:57:57PM +0200, Michal Simek wrote:
> >>>>> But anyway what was resolution from that meeting?
> >>>>
> >>>> It never happened, we got distracted by lunch :)
> >>
> >> Then why not to have it here?
> >>
> > 
> > The essential question is if the firmware interface really is
> > appropriate for FPGAs.  It definitely has a feel of a "square peg in a
> > round hole", especially when you consider the myriad ways FPGAs can be
> > configured (some persistent, some not, some which takes effect now,
> > some which come later, some which involve bytecode interpreters...)
> > and considering reconfiguration and partial reconfiguration.
> 
> If you look at it in general I believe that there is wide range
> of applications which just contain one bitstream per fpga and the bitstream is replaced
> by newer version in upgrade. For them firmware interface should be pretty useful.
> Just setup firmware name with bitstream and it will be automatically loaded in
> startup phase.
> 
> Then there is another set of applications especially in connection to partial reconfiguration
> where this can be done statically by pregenerated partial bitstreams
> or automatically generated on target cpu. For doing everything on the target
> firmware interface is not the best because everything can be handled by user application
> and it is easier just to push this bitstream to do device and not to save it
> to the fs.
> 
> I think the question here is if this subsystem could have several interfaces.
> For example Alan is asking for adding char support.
> Does it even make sense to have more interfaces with the same backend driver?

Just for clarification, I'm asking for just one way to write the fpga
image data, not two or three.

I like being able to directly write the fpga image buffer from
userspace; that will support the superset of use cases.  v2 accepts the
binary image data from a sysfs attribute (cat image.bin
> /sys/class/fpga_manager/fpga0/fpga_config_data).  My original fpga
manager framework allowed writing the image data to the device node (cat
image.bin > /dev/fpga0) rather than sysfs. My point is that it that if
you are writing data, that goes to the file ops, not to sysfs
attributes.  sysfs is for text communication (Documentation/sysfs.txt:
"Attributes should be ASCII text files...")

> When this is answered then we can talk which one make sense to have.
> In v2 is sysfs and firmware one. Adding char is also easy to do.

Please, not three ways to do the same thing.  If you change from having
the fpga_config_data attribute to having a file_operations' write, that
would be what I think is more standard for char drivers in the kernel,
if I'm not mistaken.


> 
> Thanks,
> Michal
> 


