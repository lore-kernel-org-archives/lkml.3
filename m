Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366Ab3KLTJH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 14:09:07 -0500
Received: from www.linutronix.de ([62.245.132.108]:49114 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756105Ab3KLTIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 14:08:37 -0500
Date: Tue, 12 Nov 2013 20:08:34 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Michael Schmitz <schmitzmic@gmail.com>
cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 09/17] [m68k] IRQ: add handle_polled_irq() for timer
 based soft interrupts
In-Reply-To: <753aef27d368410b1e5c5814b1e7c8a7@gmail.com>
Message-ID: <alpine.DEB.2.02.1311121956480.30673@ionos.tec.linutronix.de>
References: <20130131002344.1161E360095@xplor.waratah.dyndns.org> <CAMuHMdUFuNpiZzTr=86Yi2yx73xh_qv8S6PnT0hp9U8x86vskw@mail.gmail.com> <CAMuHMdXB1LNGXkz=_eCQ+i+tu18ffbCA9dP_LRrF1CUBv-q-uQ@mail.gmail.com> <alpine.DEB.2.02.1311061149250.23353@ionos.tec.linutronix.de>
 <753aef27d368410b1e5c5814b1e7c8a7@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Nov 2013, Michael Schmitz wrote:
> Your patch works just fine, thanks.
> 
> I suppose setting the flag can be done in the corresponding irq startup
> function, instead of when setting up the irq controller?

irq_startup() is called with irq_desc->lock held and
irq_set_status_flags() wants desc->lock as well. Deadlock

And no, you don't want to fiddle manually in the irq descriptor data
fields. See commit a6967caf00eb :)

> Geert - I will send the patch to ataints.c implementing this as soon as
> Thomas' fix is merged.

I'll expedite it for 3.13.

Thanks,

	tglx
