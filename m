Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574AbbAGIsZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 03:48:25 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44281 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbbAGIsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 03:48:22 -0500
Date: Wed, 7 Jan 2015 09:48:19 +0100
From: Pavel Machek <pavel@denx.de>
To: atull@opensource.altera.com
Cc: gregkh@linuxfoundation.org, jgunthorpe@obsidianresearch.com, hpa@zytor.com,
        monstr@monstr.eu, michal.simek@xilinx.com, rdunlap@infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        pantelis.antoniou@konsulko.com, robh+dt@kernel.org,
        grant.likely@linaro.org, iws@ovro.caltech.edu,
        linux-doc@vger.kernel.org, broonie@kernel.org, philip@balister.org,
        rubini@gnudd.com, s.trumtrar@pengutronix.de, jason@lakedaemon.net,
        kyle.teske@ni.com, nico@linaro.org, balbi@ti.com, m.chehab@samsung.com,
        davidb@codeaurora.org, rob@landley.net, davem@davemloft.net,
        cesarb@cesarb.net, sameo@linux.intel.com, akpm@linux-foundation.org,
        linus.walleij@linaro.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        devel@driverdev.osuosl.org, delicious.quinoa@gmail.com,
        dinguyen@opensource.altera.com, yvanderv@opensource.altera.com
Subject: Re: [PATCH v8 2/4] fpga manager: add sysfs interface document
Message-ID: <20150107084819.GA1887@amd>
References: <1420575219-27061-1-git-send-email-atull@opensource.altera.com>
 <1420575219-27061-3-git-send-email-atull@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420575219-27061-3-git-send-email-atull@opensource.altera.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2015-01-06 14:13:37, atull@opensource.altera.com wrote:
> From: Alan Tull <atull@opensource.altera.com>
> 
> Add documentation under drivers/staging for new fpga manager's
> sysfs interface.
> 
> Signed-off-by: Alan Tull <atull@opensource.altera.com>
> ---
> v5  : (actually second version, but keeping version numbers
>       aligned with rest of patch series)
>       Move document to drivers/staging/fpga/Documentation/ABI
> 
> v6  : No change in this patch for v6 of the patch set
> 
> v7  : No change in this patch for v7 of the patch set
> 
> v8  : No change in this patch for v8 of the patch set
> ---
>  .../Documentation/ABI/sysfs-class-fpga-manager     |   38 ++++++++++++++++++++
>  1 file changed, 38 insertions(+)
>  create mode 100644 drivers/staging/fpga/Documentation/ABI/sysfs-class-fpga-manager
> 
> diff --git a/drivers/staging/fpga/Documentation/ABI/sysfs-class-fpga-manager b/drivers/staging/fpga/Documentation/ABI/sysfs-class-fpga-manager
> new file mode 100644
> index 0000000..eb600f2
> --- /dev/null
> +++ b/drivers/staging/fpga/Documentation/ABI/sysfs-class-fpga-manager
> @@ -0,0 +1,38 @@
> +What:		/sys/class/fpga_manager/<fpga>/name
> +Date:		October 2014
> +KernelVersion:	3.18
> +Contact:	Alan Tull <atull@opensource.altera.com>
> +Description:	Name of low level driver.
> +
> +What:		/sys/class/fpga_manager/<fpga>/firmware
> +Date:		October 2014
> +KernelVersion:	3.18
> +Contact:	Alan Tull <atull@opensource.altera.com>
> +Description:	Name of the FPGA image file to load using firmware
> class.

This one is ugly: it unneccessarily passes firmware name through the
kernel. Just make interface and code simpler by always passing
"socfpga-fpga-image" or something like that.

Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
