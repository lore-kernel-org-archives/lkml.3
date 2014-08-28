Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965803AbaH1LDT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 07:03:19 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:33905 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936498AbaH1LDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 07:03:17 -0400
Date: Thu, 28 Aug 2014 12:03:00 +0100
From: Will Deacon <will.deacon@arm.com>
To: Jassi Brar <jassisinghbrar@gmail.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>,
        Konstantin Khlebnikov <k.khlebnikov@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vitaly Andrianov <vitalya@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/2] ARM: LPAE: load upper bits of early TTBR0/TTBR1
Message-ID: <20140828110300.GJ22580@arm.com>
References: <20140722153623.25088.37742.stgit@buzz>
 <20140728181224.GN15536@arm.com>
 <CALYGNiNrK1d32ecz4rw0sgn0GyN-M6hTBuTLGQV53Z4Br-bpYQ@mail.gmail.com>
 <20140728184741.GT15536@arm.com>
 <CALYGNiOd+Dy-2q_woZ9UDbMO24q58jN1Nsq7E8cJMMg_YBK9pA@mail.gmail.com>
 <CABb+yY17Y18oAivi_VxPJqDEGLTbEy_PfsdeK9jXWZ0iV3vZ=w@mail.gmail.com>
 <CALYGNiN-SHr6YJ53_deizb1VoXTBzD7dn8hcwqd4zLjx6utCDw@mail.gmail.com>
 <CABb+yY1VsEwDi5XCRkKbSNPW_+_MgL4gdAChKgX_NGHRzXq6qw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABb+yY1VsEwDi5XCRkKbSNPW_+_MgL4gdAChKgX_NGHRzXq6qw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 04:45:24PM +0100, Jassi Brar wrote:
> On Wed, Aug 27, 2014 at 9:01 PM, Konstantin Khlebnikov <koct9i@gmail.com> wrote:
> > On Wed, Aug 27, 2014 at 7:26 PM, Jassi Brar <jassisinghbrar@gmail.com> wrote:
> >> It seems the patch wasn't tested on any real platform, I did on my
> >> CA15 based platform - it breaks boot. Simply reverting the patch gets
> >> it going again. I am happy to try any fix.
> >>
> >
> > Please try to remove adcls line.
> > Seems like this affects only systems where PHYS_OFFSET == PAGE_OFFSET.
> >
> > --- a/arch/arm/mm/proc-v7-3level.S
> > +++ b/arch/arm/mm/proc-v7-3level.S
> > @@ -146,7 +146,6 @@ ENDPROC(cpu_v7_set_pte_ext)
> >         mov     \tmp, \ttbr1, lsr #(32 - ARCH_PGD_SHIFT)        @ upper bits
> >         mov     \ttbr1, \ttbr1, lsl #ARCH_PGD_SHIFT             @ lower bits
> >         addls   \ttbr1, \ttbr1, #TTBR1_OFFSET
> > -       adcls   \tmp, \tmp, #0
> >         mcrr    p15, 1, \ttbr1, \tmp, c2                        @ load TTBR1
> >         mov     \tmp, \ttbr0, lsr #(32 - ARCH_PGD_SHIFT)        @ upper bits
> >         mov     \ttbr0, \ttbr0, lsl #ARCH_PGD_SHIFT             @ lower bits
> >
> Yup, restores boot.

Can somebody write this up as a proper patch and put it in the patch system
please?

Will
