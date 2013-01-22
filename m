Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454Ab3AVH3L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 02:29:11 -0500
Received: from mail-da0-f43.google.com ([209.85.210.43]:52176 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496Ab3AVH3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 02:29:08 -0500
Date: Mon, 21 Jan 2013 23:29:12 -0800
From: Olof Johansson <olof@lixom.net>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] ARM: shmobile: sh73a0: Use generic irqchip_init()
Message-ID: <20130122072912.GD25783@quad.lixom.net>
References: <1358493373-28722-1-git-send-email-thierry.reding@avionic-design.de>
 <20130121005439.GF19062@verge.net.au>
 <20130121070301.GB15508@avionic-0098.adnet.avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130121070301.GB15508@avionic-0098.adnet.avionic-design.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 08:03:01AM +0100, Thierry Reding wrote:
> On Mon, Jan 21, 2013 at 09:54:39AM +0900, Simon Horman wrote:
> > On Fri, Jan 18, 2013 at 08:16:12AM +0100, Thierry Reding wrote:
> > > The asm/hardware/gic.h header does no longer exist and the corresponding
> > > functionality was moved to linux/irqchip.h and linux/irqchip/arm-gic.h
> > > respectively. gic_handle_irq() and of_irq_init() are no longer available
> > > either and have been replaced by irqchip_init().
> > 
> > asm/hardware/gic.h Seems to still exist in Linus's tree.
> > Could you let me know which tree of which branch I should depend on
> > in order to apply this change?
> 
> I found this when doing an automated build over all ARM defconfigs on
> linux-next.
> 
> Commit 520f7bd73354f003a9a59937b28e4903d985c420 "irqchip: Move ARM gic.h
> to include/linux/irqchip/arm-gic.h" moved the file and was merged
> through Olof Johansson's next/cleanup and for-next branches.
> 
> Adding Olof on Cc since I'm not quite sure myself about how this is
> handled.

The way to handle this is to base the branch you are adding new shmobile code
in, on top of the cleanup branches that changes the underlying infrastructure.
This is why we merge it early during the release, so that new code for various
platforms can be based on it to avoid a bunch of conflicts in the end.

In this case, you might need to base your branch onto a merge of both
the irqchip/gic-vic-move and timer/cleanup branches from arm-soc.


-Olof

