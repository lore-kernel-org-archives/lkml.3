Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039Ab3JKM32 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 08:29:28 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:50518 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757759Ab3JKM3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 08:29:24 -0400
Date: Fri, 11 Oct 2013 13:28:46 +0100
From: Will Deacon <will.deacon@arm.com>
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: Chen Gang <gang.chen@asianux.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux390@de.ibm.com" <linux390@de.ibm.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm/arm64: remove atomic_clear_mask() in
 "include/asm/atomic.h"
Message-ID: <20131011122846.GK14732@mudshark.cambridge.arm.com>
References: <5256121A.9030504@asianux.com>
 <52561269.60900@asianux.com>
 <20131010100733.GH3817@mudshark.cambridge.arm.com>
 <52568998.2080108@asianux.com>
 <20131010142305.GG6199@mudshark.cambridge.arm.com>
 <525751E2.3020207@asianux.com>
 <20131011104419.GE14732@mudshark.cambridge.arm.com>
 <5257E033.3090607@asianux.com>
 <5257E539.9080902@asianux.com>
 <CAFLxGvwsx2YfNHiGtjWsANfVW74PT3KneLA-T6SpY4NEp_OSUA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFLxGvwsx2YfNHiGtjWsANfVW74PT3KneLA-T6SpY4NEp_OSUA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 01:08:17PM +0100, Richard Weinberger wrote:
> On Fri, Oct 11, 2013 at 1:47 PM, Chen Gang <gang.chen@asianux.com> wrote:
> > In current kernel wide source code, except other architectures, only
> > s390 scsi drivers use atomic_clear_mask(), and arm/arm64 need not
> > support s390 drivers.
> >
> > So remove atomic_clear_mask() from "arm[64]/include/asm/atomic.h".
> 
> Is it really worth removing such a primitive?
> If someone needs it later he has to implement it from scratch and
> introduces bugs...

The version we have (on ARM64 anyway) already has bugs. Given the choice
between fixing code that has no callers and simply removing it, I'd go for
the latter.

Will
