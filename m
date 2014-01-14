Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162AbaANHYC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 02:24:02 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:22735 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbaANHYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 02:24:00 -0500
Date: Tue, 14 Jan 2014 10:23:44 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: Chase Southwood <chase.southwood@yahoo.com>, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, abbotti@mev.co.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: comedi: move trailing statement to next line in
 ni_mio_common.c
Message-ID: <20140114072344.GL7444@mwanda>
References: <1389669228-15090-1-git-send-email-chase.southwood@yahoo.com>
 <1389669374.24849.30.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389669374.24849.30.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 07:16:14PM -0800, Joe Perches wrote:
> On Mon, 2014-01-13 at 21:13 -0600, Chase Southwood wrote:
> > This patch for ni_mio_common.c silences a checkpatch error due to a
> > trailing statement.
> []
> > diff --git a/drivers/staging/comedi/drivers/ni_mio_common.c b/drivers/staging/comedi/drivers/ni_mio_common.c
> []
> > @@ -692,7 +692,8 @@ static void ni_clear_ai_fifo(struct comedi_device *dev)
> >  		/*  Flush the 6143 data FIFO */
> >  		ni_writel(0x10, AIFIFO_Control_6143);	/*  Flush fifo */
> >  		ni_writel(0x00, AIFIFO_Control_6143);	/*  Flush fifo */
> > -		while (ni_readl(AIFIFO_Status_6143) & 0x10) ;	/*  Wait for complete */
> > +		while (ni_readl(AIFIFO_Status_6143) & 0x10)
> > +			;	/*  Wait for complete */
> 
> It's generally better to use timeouts too.

Just to clarify what Joe is saying do:

		/*  Wait for complete */
		while (timemout < TIMEOUT) {
			if (ni_readl(AIFIFO_Status_6143) & 0x10)
				break;
			udelay(1);
		}

I added in a delay...  The problem is that you'd probably have to look
at the hardware spec to know what timeout to use or if the delay is
needed.

regards,
dan carpenter

