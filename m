Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984Ab3BPKwk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 05:52:40 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44349 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660Ab3BPKwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 05:52:39 -0500
Date: Sat, 16 Feb 2013 10:51:59 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Vinod Koul <vinod.koul@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Dan Williams <djbw@fb.com>,
        Olof Johansson <olof@lixom.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/4] dmaengine: dw_dmac: move to generic DMA binding
Message-ID: <20130216105159.GN17833@n2100.arm.linux.org.uk>
References: <1360952512-971558-1-git-send-email-arnd@arndb.de> <1360952512-971558-3-git-send-email-arnd@arndb.de> <CAKohpo=u_b9u1=78+tm-rhVR14P0=2XbLrZEDJrQBY5W8LXiCw@mail.gmail.com> <201302161007.39657.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201302161007.39657.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 16, 2013 at 10:07:39AM +0000, Arnd Bergmann wrote:
> On Saturday 16 February 2013, Viresh Kumar wrote:
> > On 15 February 2013 23:51, Arnd Bergmann <arnd@arndb.de> wrote:
> > > +static bool dw_dma_generic_filter(struct dma_chan *chan, void *param)
> > >  {
> > 
> > > +       dws->cfg_hi     = 0xffffffff;
> > > +       dws->cfg_lo     = 0xffffffff;
> > 
> > s/0xffffffff/-1 ?
> 
> It's an 'unsigned int'. While -1 would work here, I always find it a little
> odd to rely on that feature of the C language.

However, relying on an 'int' being 32-bits is also rather odd, and
probably much more dubious too.  If you want to set all bits in an
int, the portable way to do that is ~0.
