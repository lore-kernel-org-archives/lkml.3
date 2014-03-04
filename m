Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874AbaCDLFX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 06:05:23 -0500
Received: from www.linutronix.de ([62.245.132.108]:60647 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756650AbaCDLFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 06:05:22 -0500
Date: Tue, 4 Mar 2014 12:05:28 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alexander Shiyan <shc_work@mail.ru>
cc: linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH] irq: Export symbol no_action()
In-Reply-To: <1393656316-26757-1-git-send-email-shc_work@mail.ru>
Message-ID: <alpine.DEB.2.02.1403041203540.18573@ionos.tec.linutronix.de>
References: <1393656316-26757-1-git-send-email-shc_work@mail.ru>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Mar 2014, Alexander Shiyan wrote:

> This will allow to use dummy IRQ handler no_action() from
> drivers compiled as module. For example, dummy handler is could
> be used for drivers that use ARM FIQ interrupts.

And why exactly requires a driver which uses ARM FIQ interrupts the
no_action implementation?
 
> @@ -41,6 +41,7 @@ irqreturn_t no_action(int cpl, void *dev_id)
>  {
>  	return IRQ_NONE;
>  }
> +EXPORT_SYMBOL(no_action);

EXPORT_SYMBOL_GPL if at all.

Thanks,

	tglx
