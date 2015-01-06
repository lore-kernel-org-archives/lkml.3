Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111AbbAFAmw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 19:42:52 -0500
Received: from hofr.at ([212.69.189.236]:52411 "EHLO mail.hofr.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753300AbbAFAmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 19:42:49 -0500
Date: Tue, 6 Jan 2015 01:42:46 +0100
From: Nicholas Mc Guire <der.herr@hofr.at>
To: "Jiang, Dave" <dave.jiang@intel.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rashika.kheria@gmail.com" <rashika.kheria@gmail.com>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        "prarit@redhat.com" <prarit@redhat.com>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>
Subject: Re: [PATCH] ioat: fail self-test if wait_for_completion times out
Message-ID: <20150106004246.GA31803@opentech.at>
References: <1419763047-15414-1-git-send-email-der.herr@hofr.at> <1420476711.7745.2.camel@djiang5-desk2.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420476711.7745.2.camel@djiang5-desk2.amr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Jan 2015, Jiang, Dave wrote:

> 
> 
> 
> On Sun, 2014-12-28 at 10:37 +0000, Nicholas Mc Guire wrote:
> > wait_for_completion_timeout reaching timeout was being ignored,
> > fail the self-test if timeout condition occurs.
> > 
> > Not sure about the indentations used (CodingStyle:Chapter 2)
> > 
> > this was only compile tested with
> > x86_64_defconfig + CONFIG_DMA_ENGINE=y + CONFIG_INTEL_IOATDMA=y
> > 
> > patch is against linux-next 3.19.0-rc1 -next-20141226
> > 
> > Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
> > ---
> >  drivers/dma/ioat/dma_v3.c |    9 ++++++---
> >  1 file changed, 6 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
> > index be307182..0659215 100644
> > --- a/drivers/dma/ioat/dma_v3.c
> > +++ b/drivers/dma/ioat/dma_v3.c
> > @@ -1311,7 +1311,8 @@ static int ioat_xor_val_self_test(struct ioatdma_device *device)
> > 
> >  	tmo = wait_for_completion_timeout(&cmp, msecs_to_jiffies(3000));
> > 
> > -	if (dma->device_tx_status(dma_chan, cookie, NULL) != DMA_COMPLETE) {
> > +	if (tmo == 0 || dma->device_tx_status(dma_chan, cookie, NULL)
> > +			!= DMA_COMPLETE) {
> >  		dev_err(dev, "Self-test xor timed out\n");
> >  		err = -ENODEV;
> >  		goto dma_unmap;
> > @@ -1377,7 +1378,8 @@ static int ioat_xor_val_self_test(struct ioatdma_device *device)
> > 
> >  	tmo = wait_for_completion_timeout(&cmp, msecs_to_jiffies(3000));
> > 
> > -	if (dma->device_tx_status(dma_chan, cookie, NULL) != DMA_COMPLETE) {
> > +	if (tmo == 0 || dma->device_tx_status(dma_chan, cookie, NULL)
> > +			!= DMA_COMPLETE) {
> 
> Can you please do: 
> +	if (tmo == 0 ||
> +	    dma->device_tx_status(dma_chan, cookie, NULL) != DMA_COMPLETE) {

Documentation/CodingStyle:Chapter 2

"Statements longer than 80 columns will be broken into sensible chunks, unless
exceeding 80 columns significantly increases readability and does not hide
information. Descendants are always substantially shorter than the parent and
are placed substantially to the right. The same applies to function headers..."

am I misreading the CodingStyle here ?

> 
> Otherwise it looks good. Although I've never hit that error condition either. 
> 
> >  		dev_err(dev, "Self-test validate timed out\n");
> >  		err = -ENODEV;
> >  		goto dma_unmap;
> > @@ -1429,7 +1431,8 @@ static int ioat_xor_val_self_test(struct ioatdma_device *device)
> > 
> >  	tmo = wait_for_completion_timeout(&cmp, msecs_to_jiffies(3000));
> > 
> > -	if (dma->device_tx_status(dma_chan, cookie, NULL) != DMA_COMPLETE) {
> > +	if (tmo == 0 || dma->device_tx_status(dma_chan, cookie, NULL)
> > +			!= DMA_COMPLETE) {
> >  		dev_err(dev, "Self-test 2nd validate timed out\n");
> >  		err = -ENODEV;
> >  		goto dma_unmap;
> > --
> > 1.7.10.4
> > 

thx!
hofrat
