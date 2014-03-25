Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976AbaCYVGd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 17:06:33 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:38672 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754785AbaCYVGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 17:06:30 -0400
Date: Tue, 25 Mar 2014 14:06:27 -0700
From: Simon Horman <horms@verge.net.au>
To: Tejun Heo <tj@kernel.org>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Magnus Damm <magnus.damm@gmail.com>, linux-ide@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: limit sata_rcar host driver to ARCH_SHMOBILE
Message-ID: <20140325210627.GF27673@verge.net.au>
References: <9835622.nRa3VdL61G@amdc1032>
 <20140325191324.GA3279@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140325191324.GA3279@htj.dyndns.org>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2014 at 03:13:24PM -0400, Tejun Heo wrote:
> On Tue, Mar 25, 2014 at 08:10:27PM +0100, Bartlomiej Zolnierkiewicz wrote:
> > Limit sata_rcar host driver to ARCH_SHMOBILE as Renesas R-Car SATA
> > support is specific to Renesas SoCs and the driver to work requires
> > suitable device tree node (or platform device) to be defined.
> > 
> > Cc: Simon Horman <horms@verge.net.au>
> > Cc: Magnus Damm <magnus.damm@gmail.com>
> > Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > ---
> >  drivers/ata/Kconfig |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > Index: b/drivers/ata/Kconfig
> > ===================================================================
> > --- a/drivers/ata/Kconfig	2014-03-25 19:52:31.952327027 +0100
> > +++ b/drivers/ata/Kconfig	2014-03-25 19:57:21.104322097 +0100
> > @@ -298,6 +298,7 @@ config SATA_PROMISE
> >  
> >  config SATA_RCAR
> >  	tristate "Renesas R-Car SATA support"
> > +	depends on ARCH_SHMOBILE
> 
> COMPILE_TEST?

I think the following would make sense:

	depends on ARCH_SHMOBILE || COMPILE_TEST
