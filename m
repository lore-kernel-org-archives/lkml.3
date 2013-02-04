Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab3BDXbx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 18:31:53 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:52179 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755197Ab3BDXbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 18:31:51 -0500
MIME-Version: 1.0
In-Reply-To: <20130204185650.GP25591@8bytes.org>
References: <1359983924-28952-1-git-send-email-joro@8bytes.org>
	<1359983924-28952-5-git-send-email-joro@8bytes.org>
	<CALRxmdCiSZgoqd8tp90kPCdA=s7SWZCTwKsFnWu7S5=U7+eRLQ@mail.gmail.com>
	<20130204185650.GP25591@8bytes.org>
Date: Mon, 4 Feb 2013 17:31:51 -0600
Message-ID: <CALRxmdD9Ock04AoUtF9FT_uY5C5Eb7cSPmtCM6WK=StNB_iYkQ@mail.gmail.com>
Subject: Re: [PATCH 4/5] iommu: Add domain window handling functions
From: Stuart Yoder <b08248@gmail.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Sethi Varun-B16395 <B16395@freescale.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 4, 2013 at 12:56 PM, Joerg Roedel <joro@8bytes.org> wrote:
> On Mon, Feb 04, 2013 at 12:10:51PM -0600, Stuart Yoder wrote:
>> On Mon, Feb 4, 2013 at 7:18 AM, Joerg Roedel <joro@8bytes.org> wrote:
>> > +static inline int iommu_domain_window_enable(struct iommu_domain *domain,
>> > +                                            u32 wnd_nr, phys_addr_t paddr,
>> > +                                            size_t size)
>> > +{
>> > +       return -ENODEV;
>> > +}
>> > +
>> > +static inline void iommu_domain_window_disable(struct iommu_domain *domain,
>> > +                                              u32 wnd_nr)
>> > +{
>> > +}
>> > +
>> >  static inline phys_addr_t iommu_iova_to_phys(struct iommu_domain *domain,
>> >                                              unsigned long iova)
>> >  {
>>
>> This API looks workable.   The one change we need is that the size argument in
>> the enable API needs to be 64 bits.   Our window sizes can exceed 4GB.
>
> Okay. So if your architecture supports sizes over 2^32 then size_t
> probably is already 64bits, right?

No, on a 32-bit platform size_t would generally be 32-bits.  But the PAMU
is independent of that.   I think we should just make it a u64.

Stuart
