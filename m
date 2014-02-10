Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492AbaBJI6V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 03:58:21 -0500
Received: from www.linutronix.de ([62.245.132.108]:56092 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbaBJI6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 03:58:20 -0500
Date: Mon, 10 Feb 2014 09:58:25 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chuansheng Liu <chuansheng.liu@intel.com>
cc: linux-kernel@vger.kernel.org, xiaoming wang <xiaoming.wang@intel.com>
Subject: Re: [PATCH 1/2] genirq: Fix the possible synchronize_irq()
 wait-forever
In-Reply-To: <1392020037-5484-1-git-send-email-chuansheng.liu@intel.com>
Message-ID: <alpine.DEB.2.02.1402100951290.21991@ionos.tec.linutronix.de>
References: <y> <1392020037-5484-1-git-send-email-chuansheng.liu@intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Feb 2014, Chuansheng Liu wrote:
> There is below race between irq handler and irq thread:
> irq handler                             irq thread
> 
> irq_wake_thread()                       irq_thread()
>   set bit RUNTHREAD
>   ...                                    clear bit RUNTHREAD
>                                          thread_fn()
>                                          [A]test_and_decrease
>                                                thread_active
>   [B]increase thread_active
> 
> If action A is before action B, after that the thread_active
> will be always > 0, and for synchronize_irq() calling, which
> will be waiting there forever.

No. thread_active is 0, simply because after the atomic_dec_and_test()
it is -1 and the atomic_inc on the other side will bring it back to 0.

Thanks,

	tglx
