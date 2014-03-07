Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751680AbaCGD1j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 22:27:39 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:6234 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751055AbaCGD1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 22:27:37 -0500
Date: Thu, 6 Mar 2014 19:26:49 -0800
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Josh Cartwright <joshc@codeaurora.org>
CC: Linus Walleij <linus.walleij@linaro.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pinctrl: msm: drop wake_irqs bitmap
Message-ID: <20140307032635.GF21801@sonymobile.com>
References: <1394047988-14081-1-git-send-email-joshc@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1394047988-14081-1-git-send-email-joshc@codeaurora.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 05 Mar 11:33 PST 2014, Josh Cartwright wrote:

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

I wasn't aware of that, change looks good!

Acked-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>

