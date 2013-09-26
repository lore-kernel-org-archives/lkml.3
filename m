Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354Ab3IZOl0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 10:41:26 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:32802 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab3IZOlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 10:41:21 -0400
Date: Thu, 26 Sep 2013 10:41:15 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: James Ralston <james.d.ralston@intel.com>,
        Seth Heasley <seth.heasley@intel.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] i2c-ismt: add Initialize DMA buffer code
 ismt_access()
Message-ID: <20130926144115.GB12301@hmsreliant.think-freely.org>
References: <1380066475-2119-1-git-send-email-james.d.ralston@intel.com>
 <20130926084032.GB3057@katana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130926084032.GB3057@katana>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 10:40:32AM +0200, Wolfram Sang wrote:
> On Tue, Sep 24, 2013 at 04:47:55PM -0700, James Ralston wrote:
> > This patch adds code to Initialize the DMA buffer to compensate for possible hardware data corruption.
> 
> Take care of the line width here.
> 
> > Signed-off-by: James Ralston <james.d.ralston@intel.com>
> > ---
> >  drivers/i2c/busses/i2c-ismt.c |    3 +++
> >  1 files changed, 3 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/i2c/busses/i2c-ismt.c b/drivers/i2c/busses/i2c-ismt.c
> > index 8ed79a0..d3f30ea 100644
> > --- a/drivers/i2c/busses/i2c-ismt.c
> > +++ b/drivers/i2c/busses/i2c-ismt.c
> > @@ -393,6 +393,9 @@ static int ismt_access(struct i2c_adapter *adap, u16 addr,
> >  
> >  	desc = &priv->hw[priv->head];
> >  
> > +	/* Initialize the DMA buffer */
> > +	memset(priv->dma_buffer, 0, (I2C_SMBUS_BLOCK_MAX+1));
> 
> sizeof()?
> 
Agreed.
Neil

> > +
> >  	/* Initialize the descriptor */
> >  	memset(desc, 0, sizeof(struct ismt_desc));
> >  	desc->tgtaddr_rw = ISMT_DESC_ADDR_RW(addr, read_write);
> > -- 
> > 1.7.7.6
> > 


