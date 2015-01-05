Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbbAEKmv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 05:42:51 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:60100 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbbAEKmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 05:42:49 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdagZrxVAjUtPf6+Eef_pGeReQijBtiR5cT2Yom3BS8qVw@mail.gmail.com>
References: <1418302951-9309-1-git-send-email-octavian.purdila@intel.com>
	<1418302951-9309-2-git-send-email-octavian.purdila@intel.com>
	<CACRpkdYM_Bg_jH_sDuSsdJ1LWKYyj2LURAKRZ8FYODG5Soqa6Q@mail.gmail.com>
	<CACRpkdagZrxVAjUtPf6+Eef_pGeReQijBtiR5cT2Yom3BS8qVw@mail.gmail.com>
Date: Mon, 5 Jan 2015 20:42:48 +1000
Message-ID: <CAE1zotLGqppViL730fCRpv8AFRTbr9q+DWaz4Roj7LWREB=y2Q@mail.gmail.com>
Subject: Re: [PATCH 1/3] gpio: dln2: fix issue when an IRQ is unmasked then enabled
From: Octavian Purdila <octavian.purdila@intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>, Johan Hovold <johan@kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 5, 2015 at 6:55 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
>
> On Wed, Dec 31, 2014 at 9:55 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> > On Thu, Dec 11, 2014 at 2:02 PM, Octavian Purdila
> > <octavian.purdila@intel.com> wrote:
> >
> >> As noticed during suspend/resume operations, the IRQ can be unmasked
> >> then disabled in suspend and eventually enabled in resume, but without
> >> being unmasked.
> >>
> >> The current implementation does not take into account interactions
> >> between mask/unmask and enable/disable interrupts, and thus in the
> >> above scenarios the IRQs remain unactive.
> >>
> >> To fix this we removed the enable/disable operations as they fallback
> >> to mask/unmask anyway.
> >>
> >> We also remove the pending bitmaks as it is already done in irq_data
> >> (i.e. IRQS_PENDING).
> >>
> >> Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
> >
> > Patch applied for fixes.
>
> Bah now that I see there are several versions of the patch set
> floating around and also MFD patches I don't quite understand
> how acute this is or how it's to be applied.

Hi Linus,

Oops I did not noticed you applied the first version. It should not
matter anyway since I did not make any modifications to the GPIO
patches in the second version - I just doubled checked it now.

>
> - Are these regression fixes or nice to have for next kernel
>  release?
>

The first patch is a fix. The second is more of a cleanup patch.

> - Are the GPIO patches independent of the MFD patch?
>

Yes, the GPIO patches are independent of the MFD patches.
