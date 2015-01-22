Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867AbbAVFqx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 00:46:53 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:61356 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbbAVFqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 00:46:45 -0500
Date: Wed, 21 Jan 2015 21:46:37 -0800
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: Zidan Wang <b50113@freescale.com>
Cc: Zidan Wang <zidan.wang@freescale.com>, timur@tabi.org, Xiubo.Lee@gmail.com,
        lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz, tiwai@suse.de,
        alsa-devel@alsa-project.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel][PATCH 3/3] ASoC: fsl_sai: Add support for Right-J
 mode
Message-ID: <20150122054636.GB7748@Asurada>
References: <1421756480-7055-1-git-send-email-zidan.wang@freescale.com>
 <1421756480-7055-4-git-send-email-zidan.wang@freescale.com>
 <20150121185319.GA4238@Alpha>
 <20150122051344.GA6907@b50113>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150122051344.GA6907@b50113>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 01:13:46PM +0800, Zidan Wang wrote:
> On Wed, Jan 21, 2015 at 10:53:20AM -0800, Nicolin Chen wrote:
> > On Tue, Jan 20, 2015 at 08:21:20PM +0800, Zidan Wang wrote:
> > > Add Right-J mode and set TCR5 FBT bit to let data right justify.
> > > 
> > > Signed-off-by: Zidan Wang <zidan.wang@freescale.com>
> > 
> > > -	if (sai->is_lsb_first)
> > > +	if (sai->is_lsb_first && sai->is_right_j_mode)
> > >  		val_cr5 |= FSL_SAI_CR5_FBT(0);
> > 
> > Are you sure that FBT(0) is correct for right justified mode?
> > Because the original code is using FBT(0) for the lsb_first
> > situation and it shouldn't be right justified mode as default.
> >
> I am not sure about that. 
> 
> I assume lsb_first as big endian data.

Correct.

> For 16 bit data format, the 2 bytes data will in high address of 4 bytes
> fifo. So the FBT is 16 for left-j and 0 for right-j. But big endian is
> bytes convert not bits convert. It makes me confuse. And send to
> community for help.

Either waiting for Xiubo to test it or asking IC owner for help.

Nicolin
