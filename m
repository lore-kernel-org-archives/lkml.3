Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236AbaHUKFU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 06:05:20 -0400
Received: from 80-229-23-162.plus.com ([80.229.23.162]:48427 "EHLO
	mail.einon.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbaHUKFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 06:05:18 -0400
Date: Thu, 21 Aug 2014 11:05:14 +0100
From: Mark Einon <mark.einon@gmail.com>
To: David Laight <David.Laight@ACULAB.COM>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 4/8] staging: et131x: Use for loop to initialise
 contiguous macstat registers to zero
Message-ID: <20140821100514.GD2230@msilap.einon.net>
References: <1408573078-9320-1-git-send-email-mark.einon@gmail.com>
 <1408573078-9320-5-git-send-email-mark.einon@gmail.com>
 <063D6719AE5E284EB5DD2968C1650D6D1747D483@AcuExch.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D1747D483@AcuExch.aculab.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2014 at 08:40:20AM +0000, David Laight wrote:
> From: Mark Einon
> > Replace a long list of contiguous writel() calls with a for loop iterating
> > over the same address values.
> > 
> > Also remove redundant comments on the macstat registers, the variable names
> > are good enough.
> ...
> > -	writel(0, &macstat->txrx_0_64_byte_frames);
> ...
> > -	writel(0, &macstat->carry_reg2);
> > +	/* initialize all the macstat registers to zero on the device  */
> > +	for (reg = &macstat->txrx_0_64_byte_frames;
> > +	     reg <= &macstat->carry_reg2; reg++)
> > +		writel(0, reg);
> ...
> >  struct macstat_regs {			/* Location: */
> >  	u32 pad[32];			/*  0x6000 - 607C */
> > 
> > -	/* Tx/Rx 0-64 Byte Frame Counter */
> > +	/* counters */
> >  	u32 txrx_0_64_byte_frames;	/*  0x6080 */
> > -
> > -	/* Tx/Rx 65-127 Byte Frame Counter */
> >  	u32 txrx_65_127_byte_frames;	/*  0x6084 */
> 
> I think it would be best to also convert the stats counters to an array.

Hi David, thanks for the review.

There's other code that accesses these registers individually, taking into
account carries - so I don't think using an array would change much, as
we'd still need a way of identifying individual indices.

Cheers,

Mark
