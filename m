Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240AbaIQUFi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 16:05:38 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:53824 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756805AbaIQUFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 16:05:36 -0400
From: Dmitry Torokhov <dtor@google.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Eric Caruso <ejcaruso@google.com>, rjw@rjwysocki.net,
        linux-kernel@vger.kernel.org, Benson Leung <bleung@google.com>
Subject: Re: irq mask swapping during suspend/resume
Date: Wed, 17 Sep 2014 13:05:33 -0700
Message-ID: <30052021.2q1IqLHYpU@dtor-glaptop>
Organization: Google, Inc.
User-Agent: KMail/4.13.3 (Linux/3.13.0-34-generic; KDE/4.13.3; x86_64; ; )
In-Reply-To: <alpine.DEB.2.10.1409171200350.21313@nanos>
References: <CAA9CXT07f01KW4UeoPPy4k1NM6qfxdtsOQXXSPjTKx7mG_v7Rw@mail.gmail.com> <alpine.DEB.2.10.1409171200350.21313@nanos>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Wednesday, September 17, 2014 12:05:42 PM Thomas Gleixner wrote:
> On Tue, 16 Sep 2014, Eric Caruso wrote:
> > We would like to be able to set different irq masks for triggers during
> > normal operation and for waking up the system. For example, while a laptop
> > is awake, closing the lid and opening the lid should both fire an
> > interrupt, but when the system is asleep, we would like to stay asleep
> > when
> > closing the lid.
> > 
> > We are thinking about stashing the irq mask used specifically for waking
> > the system up in the irq_desc struct, and then swapping it during
> > enable_irq_wake and disable_irq_wake calls. Devices that do not specify a
> > different wake mask will use their normal trigger mask for both
> > situations.
> > 
> > Is this acceptable?
> 
> Not really. Why should irq_desc provide storage for random
> configurations and bind them to some random system state?
> 
> What's wrong with calling
> 
>        irq_set_type(irq, B);
>        enable_irq_wake(irq);
> 
>        disable_irq_wake(irq);
>        irq_set_type(irq, A);

The desire is to avoid doing it in [every] driver but rather have it done
centrally by device/PM core. It does not have to be irq_desc though,
maybe you can suggest a better place for it (aside of the individual driver
code that is)?

Thanks,
Dmitry
