Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbaGKM1x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 08:27:53 -0400
Received: from guitar.tcltek.co.il ([192.115.133.116]:47787 "EHLO
	mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752406AbaGKM1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 08:27:51 -0400
Date: Fri, 11 Jul 2014 15:27:44 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: =?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Harini Katakam <harinik@xilinx.com>, Pawel Moll <pawel.moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Harini Katakam <harinikatakamlinux@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Rob Landley <rob@landley.net>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Harini Katakam <harini.katakam@xilinx.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 1/2] gpio: Add driver for Zynq GPIO controller
Message-ID: <20140711122744.GE3003@tarshish>
References: <1403091577-10232-1-git-send-email-harinik@xilinx.com>
 <5cc8b89b-20ff-4fa9-92dd-bb2f6d3512d8@BY2FFO11FD030.protection.gbl>
 <CACRpkdb1M3-hrSKLKWz21LCJ1sMvsq5E-aqkpmVhy0NwOS5HhA@mail.gmail.com>
 <20140707152309.GH4939@tarshish>
 <CACRpkdY+3hy5iw=uRdmu665NWsoGacTMgjUq97219kEcfn7Dqw@mail.gmail.com>
 <20140711062811.GC3003@tarshish>
 <CACRpkdYi_xbixsgvF0NMVdRmxbAgDVOnq-vzYVpDkLHTL8-12A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdYi_xbixsgvF0NMVdRmxbAgDVOnq-vzYVpDkLHTL8-12A@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Fri, Jul 11, 2014 at 02:06:29PM +0200, Linus Walleij wrote:
> On Fri, Jul 11, 2014 at 8:28 AM, Baruch Siach <baruch@tkos.co.il> wrote:
> > On Tue, Jul 08, 2014 at 11:27:57AM +0200, Linus Walleij wrote:
> 
> >> What is the usecase here?
> >
> > During boot I need to know, for example, when an FPGA is ready to be
> > programmed, and when said FPGA has finished its initialization. I also read
> > the sate of on-board DIP switches to determine the desired boot method. I find
> > the current sysfs interface quite convenient for these and similar tasks.
> 
> So given that an FPGA is a piece of hardware, it should have its firmware
> loaded from the kernel and a kernel driver communicating with it I guess?
> 
> I feel the smell of a huge bundle of userspace drivers for something that
> should be handled by the kernel.

The FPGA can be loaded using simple SPI bit-banging, for which I used the 
userspace SPI interface. Nothing fancy, just a few hundred LoC. Kernel driver 
along with a userspace interface to be maintained forever for this task seems 
an overkill to me.

baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
