Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161826AbaDPPnD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 11:43:03 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:37385 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161615AbaDPPnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 11:43:00 -0400
MIME-Version: 1.0
In-Reply-To: <20140416095229.GF4754@lee--X1>
References: <1397592876-5741-1-git-send-email-dianders@chromium.org>
	<1397592876-5741-2-git-send-email-dianders@chromium.org>
	<20140416095229.GF4754@lee--X1>
Date: Wed, 16 Apr 2014 08:42:59 -0700
X-Google-Sender-Auth: 3uq03teCCw1TWhY_CZMsyK4fwB4
Message-ID: <CAD=FV=VjmXGjDHTcm=E2eEPtkOa5DxKG70jXj22RbbN1VfeGjw@mail.gmail.com>
Subject: Re: [PATCH 1/3] mfd: tps65090: Allow charger module to be used when
 no irq
From: Doug Anderson <dianders@chromium.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Anton Vorontsov <anton@enomsg.org>, Olof Johansson <olof@lixom.net>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        AJAY KUMAR RAMAKRISHNA SHYMALAMMA <ajaykumar.rs@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lee

On Wed, Apr 16, 2014 at 2:52 AM, Lee Jones <lee.jones@linaro.org> wrote:
>> On the ARM Chromebook tps65090 has two masters: the AP (the main
>> processor running linux) and the EC (the embedded controller).  The AP
>> is allowed to mess with FETs but the EC is in charge of charge control.
>>
>> The tps65090 interupt line is routed to both the AP and the EC, which
>> can cause quite a headache.  Having two people adjusting masks and
>> acking interrupts is a recipe for disaster.
>>
>> In the shipping kernel we had a hack to have the AP pay attention to
>> the IRQ but not to ack it.  It also wasn't supposed to configure the
>> IRQ in any way.  That hack allowed us to detect when the device was
>> charging without messing with the EC's state.
>>
>> The current tps65090 infrastructure makes the above difficult, and it
>> was a bit of a hack to begin with.  Rather than uglify the driver to
>> support it, just extend the driver's existing notion of "no irq" to
>> the charger.  This makes the charger code poll every 2 seconds for AC
>> detect, which is sufficient.
>>
>> Signed-off-by: Doug Anderson <dianders@chromium.org>
>> ---
>>  drivers/mfd/tps65090.c           | 14 ++++++--
>>  drivers/power/tps65090-charger.c | 76 +++++++++++++++++++++++++++++++---------
>>  2 files changed, 70 insertions(+), 20 deletions(-)
>
> For the MFD part:
>   Acked-by: Lee Jones <lee.jones@linaro.org>
>
> Anton,
>   If you are okay with this patch I'd be happy to create an immutable
> branch for you to pull from?
>
> Doug,
>   What is the relationship (dependencies) between this and the other
> patches in the set?

This patch can be applied irrespective of other others in the series.

-Doug
