Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591AbaLSPib (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 10:38:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39209 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbaLSPi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 10:38:29 -0500
Date: Fri, 19 Dec 2014 07:38:28 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Michal Simek <michal.simek@xilinx.com>
Cc: atull@opensource.altera.com, jgunthorpe@obsidianresearch.com,
        hpa@zytor.com, monstr@monstr.eu, rdunlap@infradead.org,
        mark.rutland@arm.com, linux-doc@vger.kernel.org, rubini@gnudd.com,
        pantelis.antoniou@konsulko.com, s.trumtrar@pengutronix.de,
        devel@driverdev.osuosl.org, sameo@linux.intel.com, nico@linaro.org,
        ijc+devicetree@hellion.org.uk, kyle.teske@ni.com,
        grant.likely@linaro.org, davidb@codeaurora.org,
        linus.walleij@linaro.org, cesarb@cesarb.net,
        devicetree@vger.kernel.org, jason@lakedaemon.net, pawel.moll@arm.com,
        iws@ovro.caltech.edu, broonie@kernel.org, philip@balister.org,
        dinguyen@opensource.altera.com, pavel@denx.de,
        yvanderv@opensource.altera.com, linux-kernel@vger.kernel.org,
        balbi@ti.com, delicious.quinoa@gmail.com, robh+dt@kernel.org,
        rob@landley.net, galak@codeaurora.org, akpm@linux-foundation.org,
        davem@davemloft.net, m.chehab@samsung.com
Subject: Re: [PATCH v6 0/4] FPGA Manager Framework
Message-ID: <20141219153828.GA19077@kroah.com>
References: <1418941748-16111-1-git-send-email-atull@opensource.altera.com>
 <5901b1791e1c4b09b72cb22c5eca68ca@BL2FFO11FD047.protection.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5901b1791e1c4b09b72cb22c5eca68ca@BL2FFO11FD047.protection.gbl>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2014 at 03:20:59PM +0100, Michal Simek wrote:
> Hi Greg,
> 
> On 12/18/2014 11:29 PM, atull@opensource.altera.com wrote:
> > From: Alan Tull <atull@opensource.altera.com>
> > 
> > Dropping the changes to socfpga DTS and defconfig from this
> > patch set.
> > 
> > Kernel doc fixes and other minor fixes as listed in the patches.
> > 
> > Alan
> > 
> > Alan Tull (4):
> >   doc: add bindings document for altera fpga manager
> >   fpga manager: add sysfs interface document
> >   staging: fpga manager: framework core
> >   staging: fpga manager: add driver for socfpga fpga manager
> > 
> >  drivers/staging/Kconfig                            |    2 +
> >  drivers/staging/Makefile                           |    1 +
> >  .../Documentation/ABI/sysfs-class-fpga-manager     |   38 ++
> >  .../Documentation/bindings/altera-fpga-mgr.txt     |   17 +
> >  drivers/staging/fpga/Kconfig                       |   29 +
> >  drivers/staging/fpga/Makefile                      |    9 +
> >  drivers/staging/fpga/fpga-mgr.c                    |  551 ++++++++++++++++
> >  drivers/staging/fpga/socfpga.c                     |  694 ++++++++++++++++++++
> >  include/linux/fpga/fpga-mgr.h                      |  124 ++++
> >  9 files changed, 1465 insertions(+)
> >  create mode 100644 drivers/staging/fpga/Documentation/ABI/sysfs-class-fpga-manager
> >  create mode 100644 drivers/staging/fpga/Documentation/bindings/altera-fpga-mgr.txt
> >  create mode 100644 drivers/staging/fpga/Kconfig
> >  create mode 100644 drivers/staging/fpga/Makefile
> >  create mode 100644 drivers/staging/fpga/fpga-mgr.c
> >  create mode 100644 drivers/staging/fpga/socfpga.c
> >  create mode 100644 include/linux/fpga/fpga-mgr.h
> > 
> 
> I think we have reasonable number of patches which can go to the staging
> and we can work on it and extend it. I have xilinx zynq driver in my repository too.
> Also I would try to integrate staging/gs_fpgaboot/ because they do just the same
> thing. Also char/xilinx_hwicap should be added to this subfolder (and clean a lot).
> I am not aware about any other fpga driver in the tree but I didn't grep it
> (IRC xillybus targets a little bit different thing). Please let me know if you are
> aware about different one.
> 
> I was talking to Altera guys at ELCE and conclusion was that will be the best to
> maintain future drivers/fpga/ together.
> It means if there is no problem with this series. Do you want me to add these
> patches to any repository at kernel.org and send you pull request?
> Or you just prefer to take these patches directly to staging and we will use
> separate repository later?

We don't need a whole new repo just for a single driver or a few new
files, I'll take these after the new year (can't do anything until
3.19-rc1 is out, and then it is vacation time.)

So I'll just take them from patches, no need for a git tree at all.

greg k-h
