Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010Ab3JDXdV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 19:33:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39167 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab3JDXdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 19:33:19 -0400
Date: Fri, 4 Oct 2013 16:33:41 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: monstr@monstr.eu, Pavel Machek <pavel@denx.de>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Alan Tull <atull@altera.com>, Dinh Nguyen <dinguyen@altera.com>,
        Philip Balister <philip@balister.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
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
Message-ID: <20131004233341.GA4028@kroah.com>
References: <cover.1380727889.git.michal.simek@xilinx.com>
 <524C6D64.8080801@zytor.com>
 <20131003064915.GB17155@amd.pavel.ucw.cz>
 <524EC965.70701@monstr.eu>
 <20131004141646.GA9396@kroah.com>
 <d700a91e-1319-4c35-895d-55e323c40703@email.android.com>
 <524ED081.1040600@monstr.eu>
 <524EF0CE.4040002@zytor.com>
 <524EFE76.70200@monstr.eu>
 <524F04FD.5020804@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524F04FD.5020804@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 04, 2013 at 11:12:13AM -0700, H. Peter Anvin wrote:
> On 10/04/2013 10:44 AM, Michal Simek wrote:
> > 
> > If you look at it in general I believe that there is wide range of 
> > applications which just contain one bitstream per fpga and the 
> > bitstream is replaced by newer version in upgrade. For them 
> > firmware interface should be pretty useful. Just setup firmware 
> > name with bitstream and it will be automatically loaded in startup 
> > phase.
> > 
> > Then there is another set of applications especially in connection 
> > to partial reconfiguration where this can be done statically by 
> > pregenerated partial bitstreams or automatically generated on 
> > target cpu. For doing everything on the target firmware interface 
> > is not the best because everything can be handled by user 
> > application and it is easier just to push this bitstream to do 
> > device and not to save it to the fs.
> > 
> > I think the question here is if this subsystem could have several 
> > interfaces. For example Alan is asking for adding char support. 
> > Does it even make sense to have more interfaces with the same 
> > backend driver? When this is answered then we can talk which one 
> > make sense to have. In v2 is sysfs and firmware one. Adding char
> > is also easy to do.
> > 
> 
> Greg, what do you think?
> 
> I agree that the firmware interface makes sense when the use of the
> FPGA is an implementation detail in a fixed hardware configuration,
> but that is a fairly restricted use case all things considered.

Ideally I thought this would be just like "firmware", you dump the file
to the FPGA, it validates it and away you go with a new image running in
the chip.

But, it sounds like this is much more complicated, so much so that
configfs might be the correct interface for it, as you can do lots of
things there, and it is very flexible (some say too flexible...)

A char device, with a zillion different custom ioctls is also a way to
do it, but one that I really want to avoid as that gets messy really
quickly.

thanks,

greg k-h
