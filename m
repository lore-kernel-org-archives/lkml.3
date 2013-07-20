Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595Ab3GTC4T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 22:56:19 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:47403 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501Ab3GTC4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 22:56:17 -0400
Date: Sat, 20 Jul 2013 05:55:44 +0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Borislav Petkov <bp@alien8.de>
Cc: "Luck, Tony" <tony.luck@intel.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Ming Lei <tom.leiming@gmail.com>, Linda Walsh <lkml@tlinx.org>,
        Linux-Kernel <linux-kernel@vger.kernel.org>,
        Doug Thompson <dougthompson@xmission.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>
Subject: Re: BUG: key ffff880c1148c478 not in .data! (V3.10.0)
Message-ID: <20130720055544.73a7315d.mchehab@infradead.org>
In-Reply-To: <20130718232718.GA14824@pd.tnic>
References: <51D9EAF3.4050804@tlinx.org>
	<CACVXFVPRwakzB6vtqRqL49StHKdugCpxDyNvx3VzcDC7GggFMQ@mail.gmail.com>
	<20130712080428.GB359@x4>
	<20130712134115.GI24008@pd.tnic>
	<51E00B55.5070003@infradead.org>
	<20130712142106.GJ24008@pd.tnic>
	<20130712131340.1a371662.mchehab@infradead.org>
	<3908561D78D1C84285E8C5FCA982C28F31C7D83C@ORSMSX106.amr.corp.intel.com>
	<20130718164215.GC15992@pd.tnic>
	<3908561D78D1C84285E8C5FCA982C28F31C92B23@ORSMSX106.amr.corp.intel.com>
	<20130718232718.GA14824@pd.tnic>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.19; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, 19 Jul 2013 01:27:18 +0200
Borislav Petkov <bp@alien8.de> escreveu:

> On Thu, Jul 18, 2013 at 04:51:48PM +0000, Luck, Tony wrote:
> > +	BUG_ON(mci->mc_idx >= EDAC_MAX_MCS);
> > 
> > Do we have to "BUG_ON()" here?  Couldn't we be gentler with something like:
> > 
> > 	if (mci->mc_idx >= EDAC_MAX_MCS) {
> > 		printk_once(KERN_WARNING "Too many memory controllers\n");
> > 		return; /* probably need to make sure caller copes with this ... so more stuff there */
> 
> Yeah, we can do something like this:

With this change, the patch looks ok for me.

Acked-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> 
> diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
> index 429e971e02d7..c55ad285c285 100644
> --- a/drivers/edac/edac_mc.c
> +++ b/drivers/edac/edac_mc.c
> @@ -725,6 +725,11 @@ int edac_mc_add_mc(struct mem_ctl_info *mci)
>  	int ret = -EINVAL;
>  	edac_dbg(0, "\n");
>  
> +	if (mci->mc_idx >= EDAC_MAX_MCS) {
> +		pr_warn_once("Too many memory controllers: %d\n", mci->mc_idx);
> +		return ret;
> +	}
> +
>  #ifdef CONFIG_EDAC_DEBUG
>  	if (edac_debug_level >= 3)
>  		edac_mc_dump_mci(mci);
> --
> 
> right near the beginning of the function so that we can save us the
> unwinding.
> 




Cheers,
Mauro
