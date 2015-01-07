Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896AbbAGQWh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 11:22:37 -0500
Received: from mga03.intel.com ([134.134.136.65]:2662 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752474AbbAGQWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 11:22:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="437586330"
From: "Jiang, Dave" <dave.jiang@intel.com>
To: "der.herr@hofr.at" <der.herr@hofr.at>
CC: "Williams, Dan J" <dan.j.williams@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rashika.kheria@gmail.com" <rashika.kheria@gmail.com>,
        "prarit@redhat.com" <prarit@redhat.com>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>
Subject: Re: [PATCH] ioat: fail self-test if wait_for_completion times out
Thread-Topic: [PATCH] ioat: fail self-test if wait_for_completion times out
Thread-Index: AQHQIorOSaVKzf9bt063KEMfjRC+jpyyUNSAgACDkwCAAPoiAIABYneAgAAGYACAADXugA==
Date: Wed, 7 Jan 2015 16:22:33 +0000
Message-ID: <1420647753.28773.1.camel@djiang5-desk2.amr.corp.intel.com>
References: <1419763047-15414-1-git-send-email-der.herr@hofr.at>
	 <1420476711.7745.2.camel@djiang5-desk2.amr.corp.intel.com>
	 <20150106004246.GA31803@opentech.at>
	 <1420558682.62574.2.camel@djiang5-desk2.amr.corp.intel.com>
	 <54AD2AB3.9030801@redhat.com> <20150107130932.GA3891@opentech.at>
In-Reply-To: <20150107130932.GA3891@opentech.at>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.2.105.66]
Content-Type: text/plain; charset="utf-8"
Content-ID: <5469A89C73EDDA45B837A11D0110E587@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t07GMhlB024552

On Wed, 2015-01-07 at 13:09 +0000, Nicholas Mc Guire wrote:
> On Wed, 07 Jan 2015, Prarit Bhargava wrote:
> 
> > 
> > 
> > On 01/06/2015 10:38 AM, Jiang, Dave wrote:
> > >>>> -	if (dma->device_tx_status(dma_chan, cookie, NULL) != DMA_COMPLETE) {
> > >>>> +	if (tmo == 0 || dma->device_tx_status(dma_chan, cookie, NULL)
> > >>>> +			!= DMA_COMPLETE) {
> > >>>
> > >>> Can you please do: 
> > >>> +	if (tmo == 0 ||
> > >>> +	    dma->device_tx_status(dma_chan, cookie, NULL) != DMA_COMPLETE) {
> > >>
> > >> Documentation/CodingStyle:Chapter 2
> > >>
> > >> "Statements longer than 80 columns will be broken into sensible chunks, unless
> > >> exceeding 80 columns significantly increases readability and does not hide
> > >> information. Descendants are always substantially shorter than the parent and
> > >> are placed substantially to the right. The same applies to function headers..."
> > >>
> > >> am I misreading the CodingStyle here ?
> > > 
> > > I'm not sure what the issue is here.... What I proposed is still the
> > > same length as the original code. And what I suggested complies with the
> > > existing coding style that's already there.
> > 
> > Ugh ... I missed this obvious CodingStyle error.
> > 
> > What Dave is trying to say is that he (and I'm pretty sure everyone else
> > for that matter) disagree with you style change because you have not broken
> > the columns into "sensible chunks".
> > 
> > IOW ... this,
> > 
> > 	if (tmo == 0 ||
> > 	    dma->device_tx_status(dma_chan, cookie, NULL) != DMA_COMPLETE) {
> > 
> > is much easier to comprehend than this,
> > 
> > 	if (tmo == 0 || dma->device_tx_status(dma_chan, cookie, NULL)
> > 			!= DMA_COMPLETE) {
> >
> agreed - it was just not clear to me how strict things should
> be applied - e.g. the indentation with spaces - will cleanup and
> resend.

Thank you. In general as a rule of thumb, apply coding style that's
consistent with the code that's already there. That makes it easy for
readability because it does not deviate from the whole. 
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
