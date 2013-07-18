Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829Ab3GRLmk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 07:42:40 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:61359 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752398Ab3GRLmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 07:42:39 -0400
Message-ID: <1374147757.26384.49.camel@x61.thuisdomein>
Subject: Re: [PATCH] ioatdma: silence GCC warnings
From: Paul Bolle <pebolle@tiscali.nl>
To: Dan Williams <djbw@fb.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        "dave.jiang" <dave.jiang@intel.com>
Date: Thu, 18 Jul 2013 13:42:37 +0200
In-Reply-To: <CAA9_cmc9XWCvU=d2qu6rMaV+_sxBeMgrreZWU5ofzAd3dANT9w@mail.gmail.com>
References: <1371465315.26299.17.camel@x61.thuisdomein>
	 <CAA9_cmc9XWCvU=d2qu6rMaV+_sxBeMgrreZWU5ofzAd3dANT9w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Jul 2013 11:42:37.0781 (UTC) FILETIME=[E6F56050:01CE83AB]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-17 at 15:39 -0700, Dan Williams wrote:
> On Mon, Jun 17, 2013 at 3:35 AM, Paul Bolle <pebolle@tiscali.nl> wrote:
> Seems this is fixed in gcc as of 4.7.2, but we can make things quieter
> for build testers on older compilers.

Well, I'm currently using
    gcc (GCC) 4.7.2 20121109 (Red Hat 4.7.2-8)

as shipped for Fedora 18.

> > diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
> > index ca6ea9b..b5102da 100644
> > --- a/drivers/dma/ioat/dma_v3.c
> > +++ b/drivers/dma/ioat/dma_v3.c
> > @@ -251,7 +251,7 @@ static bool is_bwd_noraid(struct pci_dev *pdev)
> >  }
> >
> >  static void pq16_set_src(struct ioat_raw_descriptor *desc[3],
> > -                       dma_addr_t addr, u32 offset, u8 coef, int idx)
> > +                       dma_addr_t addr, u32 offset, u8 coef, unsigned int idx)
> 
> "unsigned int" --> "unsigned"

Fine with me, but it does introduce a second form in this file (it
already uses "unsigned int" a few times).

> >  {
> >         struct ioat_pq_descriptor *pq = (struct ioat_pq_descriptor *)desc[0];
> >         struct ioat_pq16a_descriptor *pq16 =
> 
> Just do this hunk as the minimal one line change.

You're right. Just this hunk is enough. I'll try to send a v2 shortly.


Paul Bolle

