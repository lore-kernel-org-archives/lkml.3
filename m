Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414AbaCLNze (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 09:55:34 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:55378 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939AbaCLNzd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 09:55:33 -0400
MIME-Version: 1.0
In-Reply-To: <1394047988-14081-1-git-send-email-joshc@codeaurora.org>
References: <1394047988-14081-1-git-send-email-joshc@codeaurora.org>
Date: Wed, 12 Mar 2014 14:55:32 +0100
Message-ID: <CACRpkdYaD4-aBWd9Agr3d6AbdX5Ldo2OfwzqU1btEuBpdXQu5w@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: msm: drop wake_irqs bitmap
From: Linus Walleij <linus.walleij@linaro.org>
To: Josh Cartwright <joshc@codeaurora.org>
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 5, 2014 at 8:33 PM, Josh Cartwright <joshc@codeaurora.org> wrote:

> Currently, the wake_irqs bitmap is used to track whether there are any
> gpio's which are configured as wake irqs, and uses this to determine
> whether or not to call enable_irq_wake()/disable_irq_wake() on the
> summary interrupt.
>
> However, the genirq core already handles this case, by maintaining a
> 'wake_count' per irq_desc, and only calling into the controlling
> irq_chip when wake_count transitions 0 <-> 1.
>
> Drop this bitmap, and unconditionally call irq_set_irq_wake() on the
> summary interrupt.
>
> Signed-off-by: Josh Cartwright <joshc@codeaurora.org>

Delighted to see you folks working on this driver.
Patch applied with Björn's ACK.

Yours,
Linus Walleij
