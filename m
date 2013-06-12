Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861Ab3FLIc3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 04:32:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:36360 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280Ab3FLIc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 04:32:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,850,1363158000"; 
   d="scan'208";a="352146723"
Date: Wed, 12 Jun 2013 13:22:25 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        spear-devel <spear-devel@list.st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH v2 2/4] dma: move dw_dmac driver to an own directory
Message-ID: <20130612075225.GI4107@intel.com>
References: <1370435206-13474-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1370435206-13474-3-git-send-email-andriy.shevchenko@linux.intel.com>
 <20130612050829.GB4107@intel.com>
 <CAHp75Ver2xo2f9crQZkAmJcTF=5cZZa3NgvufPqQW3+uTXffJA@mail.gmail.com>
 <20130612073806.GG4107@intel.com>
 <CAHp75VfsSDdLa_uPULbhVGproxnD5mofYm62O75y4xRbPBJ7pQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VfsSDdLa_uPULbhVGproxnD5mofYm62O75y4xRbPBJ7pQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 11:27:51AM +0300, Andy Shevchenko wrote:
> On Wed, Jun 12, 2013 at 10:39 AM, Vinod Koul <vinod.koul@intel.com> wrote:
> > On Wed, Jun 12, 2013 at 10:43:29AM +0300, Andy Shevchenko wrote:
> >> On Wed, Jun 12, 2013 at 8:08 AM, Vinod Koul <vinod.koul@intel.com> wrote:
> >> > On Wed, Jun 05, 2013 at 03:26:44PM +0300, Andy Shevchenko wrote:
> 
> []
> 
> > Something like
> > config DW_DMAC_BIG_ENDIAN_IO
> >         tristate
> >
> > config DW_DMAC
> >         select DW_DMAC_BIG_ENDIAN_IO
> >
> > I belive DW_DMAC is for AVR support and the PCI ones is different right.
> > The point is that these things should be selected by the required symbols based
> > on what ARCH we are on and not be prompted for user to configure via menuconfig
> 
> DW_DMAC is a generic platform driver which supports AVR32, ARM and
> Intel (ACPI case) platforms.
> 
> We may do that option invisible to user
Yup
> 
> and then use
> 
> config DW_DMAC
>          select DW_DMAC_BIG_ENDIAN_IO if ARCH=AVR32
Thats would be the right way
> 
> I don't know if we will have any platform in future which has such
> difference in endianess between CPU and DMA IP block.
you never know what h/w designers would think!

--
~Vinod
