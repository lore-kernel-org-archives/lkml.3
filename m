Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964925AbaFTHJk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 03:09:40 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:46315 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934353AbaFTHJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 03:09:38 -0400
MIME-Version: 1.0
In-Reply-To: <20140619212713.923306179@linutronix.de>
References: <20140619212606.431750473@linutronix.de>
	<20140619212713.923306179@linutronix.de>
Date: Fri, 20 Jun 2014 12:39:36 +0530
X-Google-Sender-Auth: jT9nyty3jHIRGnLlL4jusjjkaH0
Message-ID: <CAOh2x==7awAgx0idqjauYJZk9-aoBEvDWneMksbyYH38c6+OSg@mail.gmail.com>
Subject: Re: [patch 13/13] irqchip: spear_shirq: Simplify register access code
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Shiraz Hashim <shiraz.linux.kernel@gmail.com>,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 3:04 AM, Thomas Gleixner <tglx@linutronix.de> wrote:

> Index: linux/drivers/irqchip/spear-shirq.c
> -struct shirq_regs {
> -       u32 enb_reg;
> -       u32 reset_to_enb;

I don't see something similar to 'reset_to_enb' is added again.
AFAICT, this field is being used by two blocks:

spear300_shirq_ras1: writes 0 to this. i.e. we need to write 0 to
mask the interrupt

and

spear320_shirq_ras3: writes 1 to this. i.e. we need to write 1 to
mask the interrupt.

And so the new code you have added breaks it for SPEAr300 ?

> -       u32 status_reg;
> -};
