Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965121AbaFRFUC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 01:20:02 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:36453 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965073AbaFRFT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 01:19:59 -0400
MIME-Version: 1.0
In-Reply-To: <53A0D651.20605@codeaurora.org>
References: <1402944372-31901-1-git-send-email-bjorn.andersson@sonymobile.com>
	<1402944372-31901-2-git-send-email-bjorn.andersson@sonymobile.com>
	<53A0D651.20605@codeaurora.org>
Date: Tue, 17 Jun 2014 22:19:58 -0700
Message-ID: <CAJAp7Oi6gqbrVOBnB8YvpR7YtQ_DDdWOAYeEU2j2Mt_=FboNoA@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] soc: devicetree: bindings: Add Qualcomm RPM DT binding
From: Bjorn Andersson <bjorn@kryo.se>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Kumar Gala <galak@codeaurora.org>, Lee Jones <lee.jones@linaro.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 4:59 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
[...]
>
> because ipc is actually a register inside the Krait complex's global
> clock control/distribution hardware block (it's located at 0x2011000).
> From what I can tell, this is the only non-clock/power register inside
> there. I plan to send out a driver for this hardware block so that I can
> switch the L2 aux source mux over to PLL8 instead of PXO (done with a
> single register write to 0x2011028) and this mapping/use here is going
> to conflict with that unless I only map the single register like is done
> here.
>
> I wonder if we'd be better off making this region a separate node and
> having some phandle to it here in the RPM node? That way we have a
> driver that provides a clock and some IPC handle the RPM driver can get.
> The SMD driver also uses the same register to kick other processors so
> having some generic IPC handle may be useful there too.

Thanks Stephen,

I never connected the dots here but now that I found the right pieces of
documentation I can only agree with you. This would better be some sort of
reverse interrupt chip.

Another such use case would be the smsm and smp2p, which in the codeaurora tree
are modelled with a custom "state change" api and as gpios respectively. Both
of these seems like they should better just be modelled as incoming virtual
interrupts and then some sort of outgoing "interrupts" or "signals".

Maybe I'm over optimistic regarding the reusability here, but I definitely
agree with you that having a "ipc = <&apcs 0>;" does look like a better
solution.

Regards,
Bjorn
