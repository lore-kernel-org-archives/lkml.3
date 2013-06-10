Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab3FJONG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 10:13:06 -0400
Received: from www.linutronix.de ([62.245.132.108]:56637 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab3FJONE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 10:13:04 -0400
Date: Mon, 10 Jun 2013 16:12:09 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chen Gang <gang.chen@asianux.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel: timer: looping issue, need reset variable
 'found'
In-Reply-To: <51B4A408.4050909@asianux.com>
Message-ID: <alpine.LFD.2.02.1306101501160.22970@ionos>
References: <51B4A408.4050909@asianux.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Jun 2013, Chen Gang wrote:

> 
> According to __internal_add_timer(), in _next_timer_interrupt(), when
> 'tv1.vec' find one, but need 'cascade bucket(s)', we still need find
> each slot of 'tv*.vec'.

No, we do not. We only need to scan the first cascade array after the
enqueued timer. If there is nothing in tv2 which might come before the
found timer, then any timer in tv3 will be later than the one we found
in the primary wheel.

> So need reset variable 'found', so can fully scan ''do {...} while()''
> for 'tv*.vec'.

And thereby lose the information, that we already found a timer in the
scan of the primary array.

Thanks,

	tglx
