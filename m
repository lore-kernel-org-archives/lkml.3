Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149Ab3EMJO2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 05:14:28 -0400
Received: from www.linutronix.de ([62.245.132.108]:46653 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab3EMJO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 05:14:27 -0400
Date: Mon, 13 May 2013 11:14:20 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: Re: [3.10-rc1] tick: NULL pointer dereference at
 tick_handle_oneshot_broadcast
In-Reply-To: <201305130722.r4D7MCPr004492@www262.sakura.ne.jp>
Message-ID: <alpine.LFD.2.02.1305131111420.2863@ionos>
References: <201305130722.r4D7MCPr004492@www262.sakura.ne.jp>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 May 2013, Tetsuo Handa wrote:

> I\'m hitting below bug on bootup.
> I don\'t know why but bisection reached commit b352bc1c
> \"tick: Convert broadcast cpu bitmaps to cpumask_var_t\".

Because I used alloc_cpumask_var instead of zalloc_cpumask_var :(

Fix is queued and will hit linus tree soon.

Thanks,

	tglx
