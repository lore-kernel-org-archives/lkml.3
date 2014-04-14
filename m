Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbaDNWLk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 18:11:40 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:63951 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755577AbaDNWLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 18:11:36 -0400
MIME-Version: 1.0
In-Reply-To: <20140414220804.GB22800@saruman.home>
References: <1396186455-3276-1-git-send-email-minipli@googlemail.com>
	<1396186455-3276-3-git-send-email-minipli@googlemail.com>
	<20140414213504.GB22607@saruman.home>
	<CA+rthh__aRaY+DQ7drj_MPB3Gb35RFFUCd50ZN_pQR3OGr2GEw@mail.gmail.com>
	<20140414220804.GB22800@saruman.home>
Date: Tue, 15 Apr 2014 00:11:34 +0200
Message-ID: <CA+rthh-kbPJndH8xkF6NSS6BHSFecKtu3vR8xPbK1N_kTiN9Qw@mail.gmail.com>
Subject: Re: [PATCH 2/2] pda_power: Unregister USB notifier in pda_power_remove()
From: Mathias Krause <minipli@googlemail.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        PaX Team <pageexec@freemail.hu>, Anton Vorontsov <anton@enomsg.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 April 2014 00:08, Felipe Balbi <balbi@ti.com> wrote:
> On Tue, Apr 15, 2014 at 12:07:13AM +0200, Mathias Krause wrote:
>> On 14 April 2014 23:35, Felipe Balbi <balbi@ti.com> wrote:
>> > On Sun, Mar 30, 2014 at 03:34:15PM +0200, Mathias Krause wrote:
>> >> If we've registered a notifier in pda_power_probe() we must deregister
>> >> it in pda_power_remove() to not let it work on stale data like, e.g.,
>> >> the charger timer.
>> >>
>> >> Cc: Felipe Balbi <balbi@ti.com>
>> >> Cc: Anton Vorontsov <anton@enomsg.org>
>> >> Signed-off-by: Mathias Krause <minipli@googlemail.com>
>> >> ---
>> >>  drivers/power/pda_power.c |    5 +++++
>> >>  1 file changed, 5 insertions(+)
>> >>
>> >> diff --git a/drivers/power/pda_power.c b/drivers/power/pda_power.c
>> >> index 87a963d0a8..aba23d6848 100644
>> >> --- a/drivers/power/pda_power.c
>> >> +++ b/drivers/power/pda_power.c
>> >> @@ -430,6 +430,11 @@ static int pda_power_remove(struct platform_device *pdev)
>> >>       if (pdata->is_ac_online && ac_irq)
>> >>               free_irq(ac_irq->start, &pda_psy_ac);
>> >>
>> >> +#if IS_ENABLED(CONFIG_USB_PHY)
>> >> +     if (!IS_ERR_OR_NULL(transceiver) && pdata->use_otg_notifier)
>> >
>> > IS_ERR() should be enough here.
>>
>> That's true! The usb_get_phy() call in pda_power_probe() will always
>> return a valid pointer or an ERR_PTR() -- never NULL. Albeit, looking
>> at usb_get_phy(), it contains another bug, returning a valid pointer,
>> even when the try_module_get() call fails. *sigh* It should set ptr to
>> an ERR_PTR() in this case.
>
> good catch, can you send a patch for that ?

Sure, will do it tomorrow.

>
>> Anyway, probably all the transceiver checks in pda_power.c can be
>> changed to IS_ERR() checks. The reason I am using IS_ERR_OR_NULL() in
>> my patch is that I just copied the test from a few lines below. I'll
>> create a follow up patch in case somebody cares about this series in
>> the first place.
>
> awesome, thanks
>
> --
> balbi


Cheers,
Mathias
