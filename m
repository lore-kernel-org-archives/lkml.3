Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912Ab3BENUu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 08:20:50 -0500
Received: from 8bytes.org ([85.214.48.195]:35755 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751279Ab3BENUs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 08:20:48 -0500
Date: Tue, 5 Feb 2013 14:20:45 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Stuart Yoder <b08248@gmail.com>
Cc: Sethi Varun-B16395 <B16395@freescale.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] iommu: Add domain window handling functions
Message-ID: <20130205132044.GB2532@8bytes.org>
References: <1359983924-28952-1-git-send-email-joro@8bytes.org>
 <1359983924-28952-5-git-send-email-joro@8bytes.org>
 <CALRxmdCiSZgoqd8tp90kPCdA=s7SWZCTwKsFnWu7S5=U7+eRLQ@mail.gmail.com>
 <20130204185650.GP25591@8bytes.org>
 <CALRxmdD9Ock04AoUtF9FT_uY5C5Eb7cSPmtCM6WK=StNB_iYkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALRxmdD9Ock04AoUtF9FT_uY5C5Eb7cSPmtCM6WK=StNB_iYkQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Feb  5 14:20:47 2013
X-DSPAM-Confidence: 0.9995
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5111072f22971943321305
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2013 at 05:31:51PM -0600, Stuart Yoder wrote:
> On Mon, Feb 4, 2013 at 12:56 PM, Joerg Roedel <joro@8bytes.org> wrote:
> > On Mon, Feb 04, 2013 at 12:10:51PM -0600, Stuart Yoder wrote:
> >> On Mon, Feb 4, 2013 at 7:18 AM, Joerg Roedel <joro@8bytes.org> wrote:
> >> > +static inline int iommu_domain_window_enable(struct iommu_domain *domain,
> >> > +                                            u32 wnd_nr, phys_addr_t paddr,
> >> > +                                            size_t size)
> >> > +{
> >> > +       return -ENODEV;
> >> > +}
> >> > +
> >> > +static inline void iommu_domain_window_disable(struct iommu_domain *domain,
> >> > +                                              u32 wnd_nr)
> >> > +{
> >> > +}
> >> > +
> >> >  static inline phys_addr_t iommu_iova_to_phys(struct iommu_domain *domain,
> >> >                                              unsigned long iova)
> >> >  {
> >>
> >> This API looks workable.   The one change we need is that the size argument in
> >> the enable API needs to be 64 bits.   Our window sizes can exceed 4GB.
> >
> > Okay. So if your architecture supports sizes over 2^32 then size_t
> > probably is already 64bits, right?
> 
> No, on a 32-bit platform size_t would generally be 32-bits.  But the PAMU
> is independent of that.   I think we should just make it a u64.

Okay, I will change that. Will push the updated branch once Sethi agrees
on the interface changes.


	Joerg


