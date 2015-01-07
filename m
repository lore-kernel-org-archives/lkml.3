Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbbAGJic (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 04:38:32 -0500
Received: from mail-ig0-f173.google.com ([209.85.213.173]:41009 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337AbbAGJi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 04:38:28 -0500
MIME-Version: 1.0
In-Reply-To: <1418745435-2851-2-git-send-email-octavian.purdila@intel.com>
References: <1418745435-2851-1-git-send-email-octavian.purdila@intel.com>
	<1418745435-2851-2-git-send-email-octavian.purdila@intel.com>
Date: Wed, 7 Jan 2015 10:38:27 +0100
Message-ID: <CACRpkdZMPp3EY517F8_tViX3V1-zDPuFHEsXbPtwe+S9WW2Wmg@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] gpio: dln2: fix issue when an IRQ is unmasked then enabled
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

On Tue, Dec 16, 2014 at 4:57 PM, Octavian Purdila
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

This patch applied for fixes.

Yours,
Linus Walleij
