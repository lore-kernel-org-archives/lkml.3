Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760597Ab3ICWbW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 18:31:22 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:56253 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754567Ab3ICWbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 18:31:21 -0400
MIME-Version: 1.0
In-Reply-To: <5224B499.4010600@infradead.org>
References: <5224B499.4010600@infradead.org>
Date: Tue, 3 Sep 2013 17:31:20 -0500
Message-ID: <CAL_Jsq+82vm_vt5EpcG1zvWmL_H4KY=91tB1WH5yUhHsiM11DA@mail.gmail.com>
Subject: Re: [PATCH] of_irq.h: fix build warnings when CONFIG_OF is not enabled
From: Rob Herring <robherring2@gmail.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 2, 2013 at 10:54 AM, Randy Dunlap <rdunlap@infradead.org> wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
>
> Fix build warnings when CONFIG_OF is not enabled:

It would be nice to know what arch/config you see this on.

> include/linux/of_irq.h:82:7: warning: 'struct device_node' declared inside parameter list [enabled by default]
> include/linux/of_irq.h:82:7: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]
> include/linux/of_irq.h:87:47: warning: 'struct device_node' declared inside parameter list [enabled by default]
>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc:     Grant Likely <grant.likely@linaro.org>
> Cc:     Rob Herring <rob.herring@calxeda.com>
> Cc:     devicetree@vger.kernel.org
> ---
>  include/linux/of_irq.h |    2 ++
>  1 file changed, 2 insertions(+)
>
> --- linux-next-20130830.orig/include/linux/of_irq.h
> +++ linux-next-20130830/include/linux/of_irq.h
> @@ -78,6 +78,8 @@ extern void of_irq_init(const struct of_
>  #endif /* CONFIG_OF_IRQ */
>
>  #else /* !CONFIG_OF */
> +struct device_node;

Can you move this outside of the ifdefs to minimize the amount of ifdef'ed code.

Rob
