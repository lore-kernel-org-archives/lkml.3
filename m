Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504Ab3E3OHw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 10:07:52 -0400
Received: from www.linutronix.de ([62.245.132.108]:33560 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754666Ab3E3OHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 10:07:46 -0400
Date: Thu, 30 May 2013 16:07:43 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ivo Sieben <meltedpianoman@gmail.com>
cc: RT <linux-rt-users@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] RFC: Set irq thread to RT priority on creation
In-Reply-To: <1369915975-28797-1-git-send-email-meltedpianoman@gmail.com>
Message-ID: <alpine.LFD.2.02.1305301602490.2905@ionos>
References: <1369915975-28797-1-git-send-email-meltedpianoman@gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 May 2013, Ivo Sieben wrote:

> When a threaded irq handler is installed the irq thread is initially created
> on normal scheduling priority. Only after the the irq thread is woken up it
> sets its priority to RT_FIFO MAX_USER_RT_PRIO/2.
> 
> This means that interrupts that occur directly after the irq handler is
> installed will be handled on a normal scheduling priority instead of the
> realtime priority that you would expect. Fixed this by setting the RT
> priority on creation of the irq_thread.
> 
> Signed-off-by: Ivo Sieben <meltedpianoman@gmail.com>
> ---
> 
> RFC:
> Whas there a specific reason for the irq_thread to be created on normal
> scheduling and only set to RT priority when woken up?

No.

> This patch solves an issue for me where a device driver is expected to handle an
> interrupt immediatly after irq handlers are installed and interrupts enabled.

You miss to explain what kind of issue that is.

Thanks,

	tglx
