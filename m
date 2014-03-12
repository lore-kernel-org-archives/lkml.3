Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083AbaCLWQc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 18:16:32 -0400
Received: from www.linutronix.de ([62.245.132.108]:46228 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780AbaCLWQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 18:16:31 -0400
Date: Wed, 12 Mar 2014 23:16:38 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Hans de Goede <hdegoede@redhat.com>
cc: LKML <linux-kernel@vger.kernel.org>, Carlo Caione <carlo.caione@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH] irq: Add a new IRQF_ACK_BEFORE_UNMASK irq flag
In-Reply-To: <53209475.2040805@redhat.com>
Message-ID: <alpine.DEB.2.02.1403122313250.18573@ionos.tec.linutronix.de>
References: <1394579583-29316-1-git-send-email-hdegoede@redhat.com> <alpine.DEB.2.02.1403120944270.18573@ionos.tec.linutronix.de> <53209475.2040805@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2014, Hans de Goede wrote:
> This indeed seems the best solution. I'm going to send a v2
> of my sun4i irq patch-set with this patch included with 2 fixes added:
> 
> 1) Export the prototype for the new handle_fasteoi_late_irq function
> 2) Fix the minor issue Russell noticed
> 
> I've only one minor nitpick wrt this patch, for ONESHOT
> to work properly the irq_chip for an irq_desc using
> handle_fasteoi_late_irq must set the IRQCHIP_EOI_THREADED, but
> this is not enforced anywhere.
> 
> Maybe add a BUG_ON to the irq mapping code checking this ?

We want some info, but a BUG_ON is probably overkill. I'll think about
a good place to do this.

Thanks,

	tglx
