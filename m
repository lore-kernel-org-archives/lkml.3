Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484AbaJJGRQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 02:17:16 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:56890 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbaJJGRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 02:17:13 -0400
Date: Fri, 10 Oct 2014 11:47:02 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ALSA: au88x0: pr_* replaced with dev_*
Message-ID: <20141010061702.GA4431@sudip-PC>
References: <1412847397-4292-1-git-send-email-sudipm.mukherjee@gmail.com>
 <1412847397-4292-2-git-send-email-sudipm.mukherjee@gmail.com>
 <s5hd2a1tlb2.wl-tiwai@suse.de>
 <1412864283.3438.43.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412864283.3438.43.camel@joe-AO725>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2014 at 07:18:03AM -0700, Joe Perches wrote:
> On Thu, 2014-10-09 at 15:38 +0200, Takashi Iwai wrote:
> > At Thu,  9 Oct 2014 15:06:37 +0530,
> > Sudip Mukherjee wrote:
<snip>
> > > diff --git a/sound/pci/au88x0/au88x0.c b/sound/pci/au88x0/au88x0.c
> []
> > > @@ -48,10 +48,10 @@ static void vortex_fix_latency(struct pci_dev *vortex)
> > >  {
> > >  	int rc;
> > >  	if (!(rc = pci_write_config_byte(vortex, 0x40, 0xff))) {
> > > -			pr_info( CARD_NAME
> > > +			dev_info(&vortex->dev, CARD_NAME
> > >  			       ": vortex latency is 0xff\n");
> > 
> > Omit the superfluous prefix when converting to dev_info() & co.
> > Other than that, looks good to me.
> 
> Hi Sudip.
> 
> Probably all the uses of CARD_NAME and "vortex" singly and
> in combination should be removed in all these conversions.
> 
Hi Takashi and Joe,
I knew Takashi will ask to remove the CARD_NAME , so i have looked at the possibility while modifying the code.
CARD_NAME will be "Aureal Advantage" or "Aureal Vortex" or "Aureal Vortex 2" based on which chip is defined.
So I thought, if we remove the prefix then we will not get the exact card name. dev_* will print the device name as
CARD_NAME_SHORT which will be au8810 or au8820 or au8830.
so, now waiting for your suggestion ..

thanks
sudip



> 
