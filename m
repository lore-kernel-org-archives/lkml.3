Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919AbaDPTDp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 15:03:45 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:53482 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbaDPTDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 15:03:43 -0400
Date: Wed, 16 Apr 2014 20:03:36 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Anton Vorontsov <anton@enomsg.org>, Olof Johansson <olof@lixom.net>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        AJAY KUMAR RAMAKRISHNA SHYMALAMMA <ajaykumar.rs@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] mfd: tps65090: Allow charger module to be used when
 no irq
Message-ID: <20140416190336.GB28725@lee--X1>
References: <1397592876-5741-1-git-send-email-dianders@chromium.org>
 <1397592876-5741-2-git-send-email-dianders@chromium.org>
 <20140416095229.GF4754@lee--X1>
 <CAD=FV=VjmXGjDHTcm=E2eEPtkOa5DxKG70jXj22RbbN1VfeGjw@mail.gmail.com>
 <20140416162621.GA28725@lee--X1>
 <CAD=FV=Vh=Ej3znMmQDfWyLbhhzZh424Kx8BA=86qcwp+AmMqBw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAD=FV=Vh=Ej3znMmQDfWyLbhhzZh424Kx8BA=86qcwp+AmMqBw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> >> >> On the ARM Chromebook tps65090 has two masters: the AP (the main
> >> >> processor running linux) and the EC (the embedded controller).  The AP
> >> >> is allowed to mess with FETs but the EC is in charge of charge control.
> >> >>
> >> >> The tps65090 interupt line is routed to both the AP and the EC, which
> >> >> can cause quite a headache.  Having two people adjusting masks and
> >> >> acking interrupts is a recipe for disaster.
> >> >>
> >> >> In the shipping kernel we had a hack to have the AP pay attention to
> >> >> the IRQ but not to ack it.  It also wasn't supposed to configure the
> >> >> IRQ in any way.  That hack allowed us to detect when the device was
> >> >> charging without messing with the EC's state.
> >> >>
> >> >> The current tps65090 infrastructure makes the above difficult, and it
> >> >> was a bit of a hack to begin with.  Rather than uglify the driver to
> >> >> support it, just extend the driver's existing notion of "no irq" to
> >> >> the charger.  This makes the charger code poll every 2 seconds for AC
> >> >> detect, which is sufficient.
> >> >>
> >> >> Signed-off-by: Doug Anderson <dianders@chromium.org>
> >> >> ---
> >> >>  drivers/mfd/tps65090.c           | 14 ++++++--
> >> >>  drivers/power/tps65090-charger.c | 76 +++++++++++++++++++++++++++++++---------
> >> >>  2 files changed, 70 insertions(+), 20 deletions(-)
> >> >
> >> > For the MFD part:
> >> >   Acked-by: Lee Jones <lee.jones@linaro.org>
> >> >
> >> > Anton,
> >> >   If you are okay with this patch I'd be happy to create an immutable
> >> > branch for you to pull from?
> >> >
> >> > Doug,
> >> >   What is the relationship (dependencies) between this and the other
> >> > patches in the set?
> >>
> >> This patch can be applied irrespective of other others in the series.
> >
> > What about the files in the patch? Could you make two separate patches
> > from this one patch and it would still compile okay? I'm _guessing_
> > the answer is yes?
> 
> Yes, they'll compile and even boot on their own.  I just tested it.
> 
> If I put only the MFD part in, then at boot I see:
>   tps65090-charger tps65090-charger: Unable to get charger irq = -6
> ...but otherwise the system functions.
> 
> If I put only the charger part in, then at boot:
>   tps65090-charger tps65090-charger: Unable to register irq 1 err -22
>   tps65090-charger: probe of tps65090-charger failed with error -22
> 
> ...so you need both patches in order to make things function, but they
> can be applied separately.  I'll assume it will make your life easier
> if I split this into two patches so I'll do that.

Yes please.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
