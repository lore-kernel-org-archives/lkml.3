Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592Ab3JDFpF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 01:45:05 -0400
Received: from gw.cm.dream.jp ([59.157.128.2]:59996 "EHLO vsmtp02.cm.dti.ne.jp"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751199Ab3JDFpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 01:45:03 -0400
Date: Fri, 4 Oct 2013 14:44:43 +0900
From: takasi-y@ops.dti.ne.jp
To: Magnus Damm <magnus.damm@gmail.com>
Cc: SH-Linux <linux-sh@vger.kernel.org>, Ben Dooks <ben.dooks@codethink.co.uk>,
        Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>,
        devicetree@vger.kernel.org, linux-serial@vger.kernel.org,
        Simon Horman <horms@verge.net.au>, Paul Mundt <lethal@linux-sh.org>,
        Mike Turquette <mturquette@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/6] clk: emev2: Add support for emev2 SMU clocks with
 DT
Message-Id: <20131004144443.a7590dd81b8901ef264e488f@ops.dti.ne.jp>
In-Reply-To: <CANqRtoRD35Ei31PK8a_TOp=2uiYPCoaJuDb6tyZtQL8s0PavNw@mail.gmail.com>
References: <52410F86.4040301@renesas.com>
	<20130924131542.f865fad4dec98e024c0d4676@ops.dti.ne.jp>
	<CANqRtoRD35Ei31PK8a_TOp=2uiYPCoaJuDb6tyZtQL8s0PavNw@mail.gmail.com>
X-Mailer: Sylpheed 3.4.0beta3 (GTK+ 2.24.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Magnus,
Thank you for your commnets.

> > +obj-$(CONFIG_ARCH_SHMOBILE)    += shmobile/
> > +obj-$(CONFIG_ARCH_SHMOBILE_MULTI)      += shmobile/
> 
> Here I believe it is enough that you only use
> CONFIG_ARCH_SHMOBILE_MULTI. ...

That is because it supports three configuration,
1. MULTI + KZM9D_REFERENCE + COMMON_CLK
2. KZM9D_REFERENCE + COMMON_CLK
3. KZM9D
but,

> ... Building common clocks to coexist with the
> old legacy board code does not make any sense IMO. ...
I think so, too.
And from the view of testing, having smaller variants is better.
# easier :)

> > +ifeq ($(CONFIG_COMMON_CLK), y)
> > +obj-$(CONFIG_ARCH_EMEV2)       += clk-emev2.o
> > +endif
> 
> I don't think you would need the above ifeq/endif wrapper if you only
> used CONFIG_ARCH_SHMOBILE_MULTI above.
Right.

Anyway, because you have make kzm9d-reference things simpler,
now we don't need to worry about it.

Thanks,
/yoshii
