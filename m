Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260Ab3BPNnt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 08:43:49 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:49239 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165Ab3BPNnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 08:43:49 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH 2/4] dmaengine: dw_dmac: move to generic DMA binding
Date: Sat, 16 Feb 2013 13:43:43 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-6-generic; KDE/4.3.2; x86_64; ; )
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Vinod Koul <vinod.koul@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Dan Williams <djbw@fb.com>,
        Olof Johansson <olof@lixom.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org
References: <1360952512-971558-1-git-send-email-arnd@arndb.de> <201302161007.39657.arnd@arndb.de> <20130216105159.GN17833@n2100.arm.linux.org.uk>
In-Reply-To: <20130216105159.GN17833@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302161343.43434.arnd@arndb.de>
X-Provags-ID: V02:K0:OXgf6mQn3f6/0XjvLEQnqIBm0dqgUtCNaZTApCJCY0O
 QMuQPcNFjNEikQILPgEXyrxEWTf3BIoCgID/B1ji4EGu5A7zl3
 FVDLo9vcd7r2cZiO0Ws73S7UQiks5QzqW146Zaq7Xx1W+1zdie
 R4qk0njB+yQpdbxDhtZnTy3H4bianPpyV5pd08XFA+AJouY89Q
 jDGj96xC0K+h7SfGfiFOnch2e09c3wGiYNEMhfycjJX7GnkMR7
 QMhkx/iCu2KTaIYziNvpNSsd0JpJwdUVyrtcbBpf5aZDa388c1
 DNtuWpa4JqyXZ0yb8fOF3LmmEwkrPaResBA5LWyqGZQYfuI73l
 FAHQL7pyQfAcxRqGuI/I=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 16 February 2013, Russell King - ARM Linux wrote:
> On Sat, Feb 16, 2013 at 10:07:39AM +0000, Arnd Bergmann wrote:
> > On Saturday 16 February 2013, Viresh Kumar wrote:
> > > On 15 February 2013 23:51, Arnd Bergmann <arnd@arndb.de> wrote:
> > > > +static bool dw_dma_generic_filter(struct dma_chan *chan, void *param)
> > > >  {
> > > 
> > > > +       dws->cfg_hi     = 0xffffffff;
> > > > +       dws->cfg_lo     = 0xffffffff;
> > > 
> > > s/0xffffffff/-1 ?
> > 
> > It's an 'unsigned int'. While -1 would work here, I always find it a little
> > odd to rely on that feature of the C language.
> 
> However, relying on an 'int' being 32-bits is also rather odd, and
> probably much more dubious too.  If you want to set all bits in an
> int, the portable way to do that is ~0.

Right, I can do that, too. All I really need here though is to make sure
I use the same value in this place and when comparing it in dwc_initialize,
and it needs to be something that cannot be a valid register setting.

Thanks,

	Arnd
