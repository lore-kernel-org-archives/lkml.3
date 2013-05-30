Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030291Ab3E3JM5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 05:12:57 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:32852 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030209Ab3E3JMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 05:12:50 -0400
Date: Thu, 30 May 2013 10:12:05 +0100
From: Will Deacon <will.deacon@arm.com>
To: Po-Yu Chuang <ratbert.chuang@gmail.com>
Cc: Sricharan R <r.sricharan@ti.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "nico@linaro.org" <nico@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: map_init_section flushes incorrect pmd
Message-ID: <20130530091205.GD7483@mudshark.cambridge.arm.com>
References: <1369738100-11152-1-git-send-email-ratbert.chuang@gmail.com>
 <20130528130502.GA28971@mudshark.cambridge.arm.com>
 <51A4B938.7080708@ti.com>
 <20130528140705.GE28971@mudshark.cambridge.arm.com>
 <51A4FC08.3060906@ti.com>
 <CANutaR-2gTP7ubiEdgjFyzVMc6=4t5GPjLkH8pkup=O882Hb-Q@mail.gmail.com>
 <20130529085426.GA13095@mudshark.cambridge.arm.com>
 <CANutaR_8jNDzPeyJ8PLZPS=yiZ8Ywmk08dR9vLcB2CpxuJac3A@mail.gmail.com>
 <CANutaR-e4L+wvfu6Fq7_Q_z9Ynwg8zZcEwzFhH5VxMGfkicYQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANutaR-e4L+wvfu6Fq7_Q_z9Ynwg8zZcEwzFhH5VxMGfkicYQw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 09:15:26AM +0100, Po-Yu Chuang wrote:
> On Wed, May 29, 2013 at 5:34 PM, Po-Yu Chuang <ratbert.chuang@gmail.com> wrote:
> > Hi Will,
> >
> > On Wed, May 29, 2013 at 4:54 PM, Will Deacon <will.deacon@arm.com> wrote:
> >> On Wed, May 29, 2013 at 03:14:58AM +0100, Po-Yu Chuang wrote:
> >>> Will,
> >>> I guess nobody noticed this because the MMU of later v7 processors
> >>> fetches page table
> >>> from D-cache. It even doesn't need to clean pmd to PoU.
> >>
> >> It does if it's UP. The walker is only guaranteed to read from L1 if you
> >> have the multiprocessing extensions.
> >
> > Ya, I see.
> >>
> >> As for this function, looks like it's ok because it has precisely one
> >> caller, so it might be worth prefixing it with some underscores to make it
> >> clear that nobody else should be calling it!
> >
> > I am fine with that.
> > Should I create a new patch?
> 
> Hi,
> 
> Does anyone have more comment about this?

Sorry, I was snowed under yesterday. If you fancy adding the underscores to
__map_init_section, that would help preserve what little remains of my
sanity.

Your existing patch looks technically correct.

Will
