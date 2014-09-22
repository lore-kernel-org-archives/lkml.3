Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414AbaIVIKH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 04:10:07 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:46752 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbaIVIKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 04:10:03 -0400
Date: Mon, 22 Sep 2014 13:39:56 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/5] sound: pci: ctxfi: cthw20k2.c: sparse warning of
 incorrect type
Message-ID: <20140922080956.GB4870@sudip-PC>
References: <1411315421-24138-1-git-send-email-sudipm.mukherjee@gmail.com>
 <1411315421-24138-4-git-send-email-sudipm.mukherjee@gmail.com>
 <s5h38bk6shg.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h38bk6shg.wl-tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 09:10:03AM +0200, Takashi Iwai wrote:
> At Sun, 21 Sep 2014 21:33:40 +0530,
> Sudip Mukherjee wrote:
> > 
> > fixed sparse warning of incorrect type (different address spaces)
> 
> Better to rather fix the type of hw.base_mem field.
> 
> Last but not least, try to align the subject line with other commits
> to this driver.  See git log and compare with yours.
> 
ok .. will do likewise.

thanks
sudip

> 
> thanks,
> 
> Takashi
> 
> > 
> > Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> > ---
> >  sound/pci/ctxfi/cthw20k2.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/sound/pci/ctxfi/cthw20k2.c b/sound/pci/ctxfi/cthw20k2.c
> > index 665eeb2..25ef60b 100644
> > --- a/sound/pci/ctxfi/cthw20k2.c
> > +++ b/sound/pci/ctxfi/cthw20k2.c
> > @@ -2112,7 +2112,7 @@ static int hw_card_shutdown(struct hw *hw)
> >  	hw->irq	= -1;
> >  
> >  	if (hw->mem_base)
> > -		iounmap((void *)hw->mem_base);
> > +		iounmap((void __iomem *)hw->mem_base);
> >  
> >  	hw->mem_base = (unsigned long)NULL;
> >  
> > @@ -2234,12 +2234,12 @@ static int hw_resume(struct hw *hw, struct card_conf *info)
> >  
> >  static u32 hw_read_20kx(struct hw *hw, u32 reg)
> >  {
> > -	return readl((void *)(hw->mem_base + reg));
> > +	return readl((void __iomem *)(hw->mem_base + reg));
> >  }
> >  
> >  static void hw_write_20kx(struct hw *hw, u32 reg, u32 data)
> >  {
> > -	writel(data, (void *)(hw->mem_base + reg));
> > +	writel(data, (void __iomem *)(hw->mem_base + reg));
> >  }
> >  
> >  static struct hw ct20k2_preset = {
> > -- 
> > 1.8.1.2
> > 
