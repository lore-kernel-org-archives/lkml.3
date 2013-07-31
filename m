Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758692Ab3GaAwV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 20:52:21 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:40778 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755730Ab3GaAwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 20:52:19 -0400
Date: Wed, 31 Jul 2013 09:52:16 +0900
From: Simon Horman <horms@verge.net.au>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Olof Johansson <olof@lixom.net>, Linux-SH <linux-sh@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>
Subject: Re: [PATCH resend] shdma: fixup sh_dmae_get_partial() calculation
 error
Message-ID: <20130731005216.GI17209@verge.net.au>
References: <1373422152-29976-1-git-send-email-horms+renesas@verge.net.au>
 <20130716012041.GA942@verge.net.au>
 <20130723023907.GC14983@quad.lixom.net>
 <20130723041220.GA22253@verge.net.au>
 <87zjtddgtg.wl%kuninori.morimoto.gx@renesas.com>
 <20130724034009.GA18355@verge.net.au>
 <87d2q8v6fs.wl%kuninori.morimoto.gx@renesas.com>
 <87bo5sv63u.wl%kuninori.morimoto.gx@renesas.com>
 <20130730084957.GA17209@verge.net.au>
 <Pine.LNX.4.64.1307301114020.25629@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1307301114020.25629@axis700.grange>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 11:22:31AM +0200, Guennadi Liakhovetski wrote:
> Hi Simon
> 
> On Tue, 30 Jul 2013, Simon Horman wrote:
> 
> > [ Cc Vinod ]
> > 
> > On Tue, Jul 23, 2013 at 11:12:41PM -0700, Kuninori Morimoto wrote:
> > > sh_desc->hw.tcr is controlling real data size,
> > > and, register TCR is controlling data transfer count
> > > which was xmit_shifted value of hw.tcr.
> > > Current sh_dmae_get_partial() is calculating in different unit.
> > > This patch fixes it.
> > > 
> > > Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
> > 
> > Can I confirm that this was a regression introduced by
> > 4f46f8ac80416b0e8fd3aba6a0d842205fb29140                   
> > ("dmaengine: shdma: restore partial transfer calculation") ?
> 
> No, don't think so. That patch only restores what was accidentally deleted 
> from the driver before. So, you cannot say, that before that patch the 
> calculation was correct. And even the way it restores it was already wrong 
> before. The error goes back to the original implementation:
> 
> commit c014906a870ce70e009def0c9d170ccabeb0be63
> Author: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Date:   Thu Feb 18 16:30:02 2010 +0000
> 
>     dmaengine: shdma: extend .device_terminate_all() to record partial transfer

Thanks, I will add the following to the changelog:

This bug has been present since c014906a870ce70e009def0c9d170ccabeb0be63
("dmaengine: shdma: extend .device_terminate_all() to record partial
transfer"), which was added in 2.6.34-rc1.
