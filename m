Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455AbaF3V54 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 17:57:56 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:32862 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbaF3V5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 17:57:55 -0400
Date: Mon, 30 Jun 2014 14:57:52 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Keith Busch <keith.busch@intel.com>
cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org
Subject: Re: [PATCH] x86: ioapic: Fix irq_free_descs count
In-Reply-To: <1404142271-18311-1-git-send-email-keith.busch@intel.com>
Message-ID: <alpine.DEB.2.02.1406301452060.13545@chino.kir.corp.google.com>
References: <1404142271-18311-1-git-send-email-keith.busch@intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2014, Keith Busch wrote:

> Signed-off-by: Keith Busch <keith.busch@intel.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: x86@kernel.org

Acked-by: David Rientjes <rientjes@google.com>

This is definitely a fix for "genirq: Provide generic hwirq allocation 
facility", but the changelog doesn't describe what the problem is and the 
title that this somehow fixes irq_free_descs() doesn't make any sense.

It's the equivalent of just doing

-	irq_free_descs(from, cnt);
+	irq_free_descs(from, i - from);

I'd suggest the patch title be changed to

	genirq: Fix memory leak when calling irq_free_hwirqs()

and the changelog state

irq_free_hwirqs() always calls irq_free_descs() with a cnt == 0 which 
makes it a no-op since the interrupt count to free is decremented in 
itself.
