Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588Ab3ETSNL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 14:13:11 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:48092 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab3ETSNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 14:13:10 -0400
MIME-Version: 1.0
In-Reply-To: <1367881863-6025-1-git-send-email-david.a.cohen@intel.com>
References: <1367881863-6025-1-git-send-email-david.a.cohen@intel.com>
Date: Mon, 20 May 2013 20:13:09 +0200
Message-ID: <CACRpkdb0q1w+c9w6fFhE6LLxrh-44aZtYz0HpkWeAWMc-gdKLQ@mail.gmail.com>
Subject: Re: [PATCH] gpio-langwell: fix irq conflicts when DT is not used
From: Linus Walleij <linus.walleij@linaro.org>
To: David Cohen <david.a.cohen@intel.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 7, 2013 at 1:11 AM, David Cohen <david.a.cohen@intel.com> wrote:

> When DT is not used IOAPIC does not register irq domain. As result
> IOAPIC won't care about gpio-langwell's virq and may cause conflict if
> an irq number is equal to gpio-langwell's virq mapped beforehand.
>
> This patch tells gpio_langwell to not ignore irq_base if != 0 and
> preferably use it to avoid the conflict.
>
> If DT is used, irq_base can safely be 0.
>
> Signed-off-by: David Cohen <david.a.cohen@intel.com>

Looks correct. Applied for rc-fixes with Mika's ACK.

Thanks!
Linus Walleij
