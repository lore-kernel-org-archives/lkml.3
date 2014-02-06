Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308AbaBFVVj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 16:21:39 -0500
Received: from mail-vc0-f182.google.com ([209.85.220.182]:51037 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbaBFVVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 16:21:38 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1402062213590.21991@ionos.tec.linutronix.de>
References: <1391721117-27446-1-git-send-email-carlo@caione.org>
	<alpine.DEB.2.02.1402062213590.21991@ionos.tec.linutronix.de>
Date: Thu, 6 Feb 2014 22:21:37 +0100
Message-ID: <CAOQ7t2Z0agZdDZ_OQZPtXWXoi5NMTcOOZz04q6wEVNy0rxn4AA@mail.gmail.com>
Subject: Re: [linux-sunxi] Re: [PATCH] irq: Add new flag to ack
 level-triggered interrupts before unmasking
From: Carlo Caione <carlo.caione@gmail.com>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Hans De Goede <hdegoede@redhat.com>, emilio@elopez.com.ar,
        linux-sunxi@googlegroups.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 6, 2014 at 10:14 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Thu, 6 Feb 2014, Carlo Caione wrote:
>
>> Several irqchip drivers require the level-triggered interrupt to be
>> acked before unmasking to avoid that a second interrupt is immediately
>> triggered. This small patch introduces a new irqchip flags that is used
>> to ack the IRQ line before it is unmasked.
>
> And why are you not doing this in the unmask function of the affected
> chip in the first place?

Because this is a common behavior of several irqchips (sunxi NMI
controller,  exynos, etc...) so I think it should be useful to have it
in the core instead of replicating the same code structure in all the
irqchip drivers.

Thanks,

-- 
Carlo Caione
