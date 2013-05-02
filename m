Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217Ab3EBDj4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 23:39:56 -0400
Received: from relay3.sgi.com ([192.48.152.1]:57401 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753087Ab3EBDjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 23:39:54 -0400
Date: Wed, 1 May 2013 22:39:52 -0500
From: Robin Holt <holt@sgi.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Robin Holt <holt@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Miguel Boton <mboton.lkml@gmail.com>, Russ Anderson <rja@sgi.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Arm Mailing List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH -v7 0/11] Shutdown from reboot_cpuid without stopping
 other cpus.
Message-ID: <20130502033952.GU3658@sgi.com>
References: <1367428011-17123-1-git-send-email-holt@sgi.com>
 <20130501231347.GT14496@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130501231347.GT14496@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 02, 2013 at 12:13:47AM +0100, Russell King - ARM Linux wrote:
> On Wed, May 01, 2013 at 12:06:40PM -0500, Robin Holt wrote:
> > Andrew, Please do _NOT_ take this patch series yet.  I am sending this
> > to you because you had comments on my -v6 submission.
> 
> Another reason for not applying this is that I believe it wilfully breaks
> a bunch of ARM platforms - such as removing the 'g' reboot mode (for gpio
> based reboot on PXA), and removing the 's' reboot mode off a bunch of ARM
> platforms which have no way to do a hard reboot.

I am not sure what your basis for this statement is.

First, let me look at the GPIO question.
 - The pxa_restart() function was changed to use REBOOT_GPIO instead of
   'g'.

 - The tosa_poweroff() and spitz_poweroff() functions were changed to
   pass REBOOT_GPIO instead of 'g' to pxa_restart().

 - The "SHARP Tosa" machine description was setting restart_mode to 'g',
   and setting the restart function to tosa_restart() which ignored the
   'g' so I eliminated setting restart_mode to 'g' in the first place.

 - The equivalent held true for the "SHARP Spitz", "SHARP Borzoi", and
   "SHARP Akita" machines.

 - I see no other uses of 'g' for a mode being passed to a restart
   function.

Second, the restart_mode = 's' cases:
 - The "EBSA110" machine was setting it, but ebsa110_restart does not use
   the reboot mode parameter so I eliminated it.

 - The "Chalice-CATS" machine was converted from setting restart_mode = 's'
   to setting reboot_mode = REBOOT_WARM and footbridge_restart was converted
   to checking for REBOOT_WARM.

 - The "MIO A701" machine was setting it, but the mioa701_restart() function
   does not use the parameter so I eliminated it.

Of the 418 machines with ".restart =" being set, there are 73 uniq
functions being utilized.  Here is the summary of those functions:
bcm2835_restart                 mode param not used.
clps711x_restart                mode param not used.
cns3xxx_restart                 mode param not used.
corgi_restart                   mode param not used.
cpu8815_restart                 mode param not used.
da8xx_restart                   mode param not used.
davinci_restart                 mode param not used.
dove_restart                    mode param not used.
ebsa110_restart                 mode param not used.
ep93xx_restart                  mode param not used.
eva_restart                     mode param not used.
exynos4_restart                 mode param not used.
exynos5_restart                 mode param not used.
footbridge_restart              Adapted to use REBOOT_WARM instead of 's'
h720x_restart                   mode param not used.
highbank_restart                Adapted to use REBOOT_COLD instead of 'h'
imx6q_restart                   mode param not used.
integrator_restar               mode param not used.
iop13xx_restart                 mode param not used.
iop3xx_restart                  mode param not used.
ixp4xx_restart                  Adapted to use REBOOT_WARM instead of 's'
kirkwood_restart                mode param not used.
ks8695_restart                  Adapted to use REBOOT_WARM instead of 's'
kzm9g_restart                   mode param not used.
lpc23xx_restart                 Adapted to use REBOOT_WARM and REBOOT_COLD
mioa701_restart                 mode param not used.
mmp_restart                     mode param not used.
mv78xx0_restart                 mode param not used.
mvebu_restart                   mode param not used.
mxc_restart                     mode param not used.
mxs_restart                     mode param not used.
n2100_restart                   mode param not used.
netwinder_restart               Adapted to use REBOOT_WARM instead of 's'
netx_restart                    mode param not used.
nuc9xx_restart                  Adapted to use REBOOT_WARM instead of 's'
omap1_restart                   mode param not used.
omap2xxx_restart                mode param not used.
omap3xxx_restart                mode param not used.
omap44xx_restart                mode param not used.
orion5x_restart                 mode param not used.
picoxcell_wdt_restart           mode param not used.
pxa168_restart                  mode param not used.
pxa_restart                     Adapted to use REBOOT_WARM, REBOOT_COLD, and REBOOT_GPIO.
realview_eb_restart             mode param not used.
realview_pb1176_restart         mode param not used.
realview_pb11mp_restart         mode param not used.
realview_pba8_restart           mode param not used.
realview_pbx_restart            mode param not used.
rpc_restart                     mode param not used.
s3c2410_restart                 Adapted to use REBOOT_WARM instead of 's'
s3c2412_restart                 Adapted to use REBOOT_WARM instead of 's'
s3c2416_restart                 Adapted to use REBOOT_WARM instead of 's'
s3c2443_restart                 Adapted to use REBOOT_WARM instead of 's'
s3c244x_restart                 Adapted to use REBOOT_WARM instead of 's'
s3c64xx_restart                 Adapted to use REBOOT_WARM instead of 's'
s5p64x0_restart                 Adapted to use REBOOT_WARM instead of 's'
s5pc100_restart                 Adapted to use REBOOT_WARM instead of 's'
s5pv210_restart                 mode param not used.
sa11x0_restart                  Adapted to use REBOOT_WARM instead of 's'
shark_restart                   mode param not used.
sirfsoc_restart                 mode param not used.
socfpga_cyclone5_restart        mode param not used.
spear_restart                   Adapted to use REBOOT_WARM instead of 's'
spitz_restart                   mode param not used.
sunxi_restart                   mode param not used.
tegra_assert_system_reset       mode param not used.
tnetv107x_restart               mode param not used.
tosa_restart                    mode param not used.
u300_restart                    Adapted to use REBOOT_WARM and REBOOT_COLD
versatile_restart               mode param not used.
voiceblue_restart               mode param not used.
vt8500_restart                  mode param not used.

Callers to pxa_restart were converted as follows:
 - corgi_poweroff(), corgi_restart(), and poodle_poweroff() were converted
   from passing 'h' to passing REBOOT_COLD.

 - mioa701_poweroff() and mioa701_restart() were converted from passing
   's' to passing REBOOT_WARM.

 - As discussed above, tosa_poweroff() and spitz_poweroff() were converted
  from using 'g' to passing REBOOT_GPIO.

>From the above list, no other functions which utilized the mode
parameter were found being called from anything other than their machine
desription's .restart callout.

I _THOUGHT_ I had checked each and every one fairly thoroughly to
ensure all callers were converted as appropriate to pass in REBOOT_COLD,
REBOOT_WARM, or REBOOT_GPIO instead of 'h', 's', or 'g'.  It was a lot of
code to look over with no strong familiarity so I likely missed something,
but I did put an honest effort into doing this right.  If you could point
to a specific problem, I will address it.

Thanks,
Robin
