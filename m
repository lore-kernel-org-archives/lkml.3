Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752384AbaKJJJM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 04:09:12 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:59241 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208AbaKJJJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 04:09:10 -0500
Date: Mon, 10 Nov 2014 09:09:04 +0000
From: Lee Jones <lee.jones@linaro.org>
To: NeilBrown <neilb@suse.de>
Cc: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>,
        Tony Lindgren <tony@atomide.com>, Samuel Ortiz <sameo@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        List for communicating with real GTA04 owners 
	<gta04-owner@goldelico.com>
Subject: Re: [Gta04-owner] [PATCH] mfd: twl4030-power: Support compatible =
 "ti, twl4030-power" again.
Message-ID: <20141110090904.GB21424@x1>
References: <20141108112227.256f93ce@notabene.brown>
 <ABCF9D6C-DD71-4DE3-BF1E-3C41DC8086FF@goldelico.com>
 <20141110122722.34b27c4c@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141110122722.34b27c4c@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Nov 2014, NeilBrown wrote:

> On Sat, 8 Nov 2014 08:24:28 +0100 "Dr. H. Nikolaus Schaller"
> <hns@goldelico.com> wrote:
> 
> > 
> > Am 08.11.2014 um 01:22 schrieb NeilBrown <neilb@suse.de>:
> > 
> > > 
> > > commit e7cd1d1eb16fcdf53001b926187a82f1f3e1a7e6
> > >    mfd: twl4030-power: Add generic reset configuration
> > > 
> > > claims:
> > >    Let's add device tree support and configure things for warm reset
> > >    as the default when compatible = "ti,twl4030-power".
> > > and
> > >    Documentation/devicetree/bindings/mfd/twl4030-power.txt
> > > claims that "ti,twl4030-power" is still a valid "compatible" setting.
> > > 
> > > However the current driver fails to probe with that 'compatible'
> > > setting.
> > > Restore the old default.
> > 
> > I think this is a duplicate to 
> > 
> > 599a1ca80d1d8269d54fdc4abdec8e65141381fe
> > 
> > (in linux-next)
> 
> 
> Ahh, so it is.  Thanks.

Just read this.

Previous reply withdrawn.

> > > Signed-off-by: NeilBrown <neilb@suse.de>
> > > 
> > > diff --git a/drivers/mfd/twl4030-power.c b/drivers/mfd/twl4030-power.c
> > > index 4d3ff3771491..1a7794f6be15 100644
> > > --- a/drivers/mfd/twl4030-power.c
> > > +++ b/drivers/mfd/twl4030-power.c
> > > @@ -776,6 +776,10 @@ static struct twl4030_power_data osc_off_idle = {
> > > 
> > > static struct of_device_id twl4030_power_of_match[] = {
> > > 	{
> > > +		.compatible = "ti,twl4030-power",
> > > +		.data = NULL,
> > > +	},
> > > +	{
> > > 		.compatible = "ti,twl4030-power-reset",
> > > 		.data = &omap3_reset,
> > > 	},
> > > _______________________________________________
> > > Gta04-owner mailing list
> > > Gta04-owner@goldelico.com
> > > http://lists.goldelico.com/mailman/listinfo.cgi/gta04-owner
> 



-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
