Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174Ab3FLITA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 04:19:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:51807 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753022Ab3FLIS6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 04:18:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,850,1363158000"; 
   d="scan'208";a="328127088"
Date: Wed, 12 Jun 2013 13:09:08 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        spear-devel <spear-devel@list.st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH v2 2/4] dma: move dw_dmac driver to an own directory
Message-ID: <20130612073806.GG4107@intel.com>
References: <1370435206-13474-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1370435206-13474-3-git-send-email-andriy.shevchenko@linux.intel.com>
 <20130612050829.GB4107@intel.com>
 <CAHp75Ver2xo2f9crQZkAmJcTF=5cZZa3NgvufPqQW3+uTXffJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75Ver2xo2f9crQZkAmJcTF=5cZZa3NgvufPqQW3+uTXffJA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 10:43:29AM +0300, Andy Shevchenko wrote:
> On Wed, Jun 12, 2013 at 8:08 AM, Vinod Koul <vinod.koul@intel.com> wrote:
> > On Wed, Jun 05, 2013 at 03:26:44PM +0300, Andy Shevchenko wrote:
> >> The dw_dmac driver is going to be split into multiple files. To make this more
> >> convenient move it to an own directory.
> >>
> >> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> >> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> >> Acked-by: Arnd Bergmann <arnd@arndb.de>
> >> ---
> >> +config DW_DMAC
> >> +     tristate "Synopsys DesignWare AHB DMA support"
> >> +     depends on GENERIC_HARDIRQS
> >> +     select DMA_ENGINE
> >> +     default y if CPU_AT32AP7000
> >> +     help
> >> +       Support the Synopsys DesignWare AHB DMA controller. This
> >> +       can be integrated in chips such as the Atmel AT32ap7000.
> >> +
> >> +config DW_DMAC_BIG_ENDIAN_IO
> >> +     bool "Use big endian I/O register access"
> >> +     default y if AVR32
> >> +     depends on DW_DMAC
> >> +     help
> >> +       Say yes here to use big endian I/O access when reading and writing
> >> +       to the DMA controller registers. This is needed on some platforms,
> >> +       like the Atmel AVR32 architecture.
> > I know this is derived but should it be selected if AVR32 is defined, this stuff
> > should be user configurable..
> 
> I'm not sure I get what you meant. User can choose that option via
> make menuconfig or editing plain .config file.
> Or you meant this should be run-time configurable?
Something like
config DW_DMAC_BIG_ENDIAN_IO
	tristate

config DW_DMAC
	select DW_DMAC_BIG_ENDIAN_IO

I belive DW_DMAC is for AVR support and the PCI ones is different right.
The point is that these things should be selected by the required symbols based
on what ARCH we are on and not be prompted for user to configure via menuconfig

--
~Vinod
-- 
