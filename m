Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849AbaLQHv1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 02:51:27 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:38473 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbaLQHvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 02:51:25 -0500
MIME-Version: 1.0
In-Reply-To: <1418745435-2851-2-git-send-email-octavian.purdila@intel.com>
References: <1418745435-2851-1-git-send-email-octavian.purdila@intel.com> <1418745435-2851-2-git-send-email-octavian.purdila@intel.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Wed, 17 Dec 2014 16:51:04 +0900
Message-ID: <CAAVeFu+m=A_1g=oE=9839Rv=+mNZkrJJdUL+fgjNQfgerS=4Ng@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] gpio: dln2: fix issue when an IRQ is unmasked then enabled
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        Johan Hovold <johan@kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 12:57 AM, Octavian Purdila
<octavian.purdila@intel.com> wrote:
> As noticed during suspend/resume operations, the IRQ can be unmasked
> then disabled in suspend and eventually enabled in resume, but without
> being unmasked.
>
> The current implementation does not take into account interactions
> between mask/unmask and enable/disable interrupts, and thus in the
> above scenarios the IRQs remain unactive.
>
> To fix this we removed the enable/disable operations as they fallback
> to mask/unmask anyway.
>
> We also remove the pending bitmaks as it is already done in irq_data
> (i.e. IRQS_PENDING).
>
> Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
> ---
>  drivers/gpio/gpio-dln2.c | 53 +++++++-----------------------------------------
>  1 file changed, 7 insertions(+), 46 deletions(-)

Yum, less code!

Acked-by: Alexandre Courbot <acourbot@nvidia.com>
