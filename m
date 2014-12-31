Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529AbaLaUzM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 15:55:12 -0500
Received: from mail-ig0-f180.google.com ([209.85.213.180]:58408 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbaLaUzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 15:55:09 -0500
MIME-Version: 1.0
In-Reply-To: <1418302951-9309-2-git-send-email-octavian.purdila@intel.com>
References: <1418302951-9309-1-git-send-email-octavian.purdila@intel.com>
	<1418302951-9309-2-git-send-email-octavian.purdila@intel.com>
Date: Wed, 31 Dec 2014 21:55:08 +0100
Message-ID: <CACRpkdYM_Bg_jH_sDuSsdJ1LWKYyj2LURAKRZ8FYODG5Soqa6Q@mail.gmail.com>
Subject: Re: [PATCH 1/3] gpio: dln2: fix issue when an IRQ is unmasked then enabled
From: Linus Walleij <linus.walleij@linaro.org>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: Lee Jones <lee.jones@linaro.org>, Johan Hovold <johan@kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 2:02 PM, Octavian Purdila
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

Patch applied for fixes.

Yours,
Linus Walleij
