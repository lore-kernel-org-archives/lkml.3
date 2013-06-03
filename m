Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285Ab3FCJ6C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 05:58:02 -0400
Received: from mx1.b1-systems.de ([84.200.69.220]:34019 "EHLO
	mx1.b1-systems.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755562Ab3FCJ6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 05:58:00 -0400
X-Greylist: delayed 638 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Jun 2013 05:57:59 EDT
Message-ID: <51AC6625.3080000@message-id.invalid.com>
Date: Mon, 03 Jun 2013 11:47:17 +0200
From: Stefan Seyfried <stefan.seyfried@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 2/8] vtime: Use consistent clocks among nohz accounting
References: <1369065716-22801-1-git-send-email-fweisbec@gmail.com> <1369065716-22801-3-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1369065716-22801-3-git-send-email-fweisbec@gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 20.05.2013 18:01, schrieb Frederic Weisbecker:
> While computing the cputime delta of dynticks CPUs,
> we are mixing up clocks of differents natures:

[...]

> As a consequence, some strange behaviour with unstable tsc
> has been observed such as non progressing constant zero cputime.
> (The 'top' command showing no load).

This happens for example on my trusty ThinkPad X200s (family 6 model 23
stepping 10 Core 2 duo), seriously confusing its user (me :-).

> Fix this by only using local_clock(), or its irq safe/remote
> equivalent, in vtime code.
> 
> Reported-by: Mike Galbraith <efault@gmx.de>
> Suggested-by: Mike Galbraith <efault@gmx.de>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Li Zhong <zhong@linux.vnet.ibm.com>
> Cc: Mike Galbraith <efault@gmx.de>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

FWIW:
Tested-by: Stefan Seyfried <seife+dev@b1-systems.com>

This patch fixes the 0% CPU issue on openSUSE Factory kernels for me.

Best regards,

	Stefan
-- 
Stefan Seyfried
Linux Consultant & Developer -- GPG Key: 0x731B665B

B1 Systems GmbH
Osterfeldstraße 7 / 85088 Vohburg / http://www.b1-systems.de
GF: Ralph Dehner / Unternehmenssitz: Vohburg / AG: Ingolstadt,HRB 3537
