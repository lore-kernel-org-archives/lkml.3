Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004AbbAGNJg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 08:09:36 -0500
Received: from hofr.at ([212.69.189.236]:43569 "EHLO mail.hofr.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630AbbAGNJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 08:09:35 -0500
Date: Wed, 7 Jan 2015 14:09:32 +0100
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Prarit Bhargava <prarit@redhat.com>
Cc: "Jiang, Dave" <dave.jiang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rashika.kheria@gmail.com" <rashika.kheria@gmail.com>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>
Subject: Re: [PATCH] ioat: fail self-test if wait_for_completion times out
Message-ID: <20150107130932.GA3891@opentech.at>
References: <1419763047-15414-1-git-send-email-der.herr@hofr.at> <1420476711.7745.2.camel@djiang5-desk2.amr.corp.intel.com> <20150106004246.GA31803@opentech.at> <1420558682.62574.2.camel@djiang5-desk2.amr.corp.intel.com> <54AD2AB3.9030801@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54AD2AB3.9030801@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Jan 2015, Prarit Bhargava wrote:

> 
> 
> On 01/06/2015 10:38 AM, Jiang, Dave wrote:
> >>>> -	if (dma->device_tx_status(dma_chan, cookie, NULL) != DMA_COMPLETE) {
> >>>> +	if (tmo == 0 || dma->device_tx_status(dma_chan, cookie, NULL)
> >>>> +			!= DMA_COMPLETE) {
> >>>
> >>> Can you please do: 
> >>> +	if (tmo == 0 ||
> >>> +	    dma->device_tx_status(dma_chan, cookie, NULL) != DMA_COMPLETE) {
> >>
> >> Documentation/CodingStyle:Chapter 2
> >>
> >> "Statements longer than 80 columns will be broken into sensible chunks, unless
> >> exceeding 80 columns significantly increases readability and does not hide
> >> information. Descendants are always substantially shorter than the parent and
> >> are placed substantially to the right. The same applies to function headers..."
> >>
> >> am I misreading the CodingStyle here ?
> > 
> > I'm not sure what the issue is here.... What I proposed is still the
> > same length as the original code. And what I suggested complies with the
> > existing coding style that's already there.
> 
> Ugh ... I missed this obvious CodingStyle error.
> 
> What Dave is trying to say is that he (and I'm pretty sure everyone else
> for that matter) disagree with you style change because you have not broken
> the columns into "sensible chunks".
> 
> IOW ... this,
> 
> 	if (tmo == 0 ||
> 	    dma->device_tx_status(dma_chan, cookie, NULL) != DMA_COMPLETE) {
> 
> is much easier to comprehend than this,
> 
> 	if (tmo == 0 || dma->device_tx_status(dma_chan, cookie, NULL)
> 			!= DMA_COMPLETE) {
>
agreed - it was just not clear to me how strict things should
be applied - e.g. the indentation with spaces - will cleanup and
resend.

thx!
hofrat 
