Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386AbaDVNpP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 09:45:15 -0400
Received: from moutng.kundenserver.de ([212.227.126.131]:55724 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756339AbaDVNok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 09:44:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ley Foon Tan <lftan@altera.com>
Subject: Re: [PATCH 20/28] nios2: Time keeping
Date: Tue, 22 Apr 2014 15:44:33 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, lftan.linux@gmail.com,
        cltang@codesourcery.com
References: <1397824031-4892-1-git-send-email-lftan@altera.com> <1397824031-4892-17-git-send-email-lftan@altera.com>
In-Reply-To: <1397824031-4892-17-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201404221544.33399.arnd@arndb.de>
X-Provags-ID: V02:K0:QUPvL6iMUr9LnpCQi+HFgCOzXeFLdUpfFiG8lmef1GQ
 SbP13qR7gSfiKOpsn5QmGZMvBcqHRV5RavLC+MllAvCw2JN0Gn
 eQsIplVj3+LS3ajJjSLm4nboLl0+0pGbcJmzLPtfLm4o3gtegI
 PD4VGUc/letILtgjNDKi2XfmObrXJqRZ9lFWt0keHVy0uJydPa
 A+0pLRbyJDPtJu124ov0+27zvTIcZGZiPqoCPx2/QJCMG/7JQn
 6h0IACzQB0n1epwgDVPOh14x9xoWyjsaBxIy4tDcRHg5bSDnpj
 M+fUlSflDVHV8LJmUy8VvnyVHeyH36iqo+wAlW7cr+9ElGEM93
 MBDODvTXqZGUYy7QCCDQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 April 2014, Ley Foon Tan wrote:
> +static inline unsigned long read_timersnapshot(void)
> +{
> +       unsigned long count;
> +
> +       outw(0, timer_membase + ALTERA_TIMER_SNAPL_REG);
> +       count =
> +               inw(timer_membase + ALTERA_TIMER_SNAPH_REG) << 16 |
> +               inw(timer_membase + ALTERA_TIMER_SNAPL_REG);
> +
> +       return count;
> +}
> +
> +static inline void write_timerperiod(unsigned long period)
> +{
> +       outw(period, timer_membase + ALTERA_TIMER_PERIODL_REG);
> +       outw(period >> 16, timer_membase + ALTERA_TIMER_PERIODH_REG);
> +}

It's wrong to use 'outw' if this device is not on an PC-style ISA bus,
which I assume it is not. Since timer_membase is an __iomem pointer,
I'm sure you want to use writew() instead.

	Arnd
