Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757922Ab3BBRuN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 12:50:13 -0500
Received: from www.linutronix.de ([62.245.132.108]:37520 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757137Ab3BBRuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 12:50:10 -0500
Message-ID: <510D51CD.6020506@linutronix.de>
Date: Sat, 02 Feb 2013 18:50:05 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20121122 Icedove/10.0.11
MIME-Version: 1.0
To: Michael Wang <wangyun@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        tglx@linutronix.de
Subject: Re: [RFC 2/2] sched/fair: prefer a CPU in the "lowest" idle state
References: <1359580757-4121-1-git-send-email-bigeasy@linutronix.de> <1359580757-4121-3-git-send-email-bigeasy@linutronix.de> <5109D313.1020409@linux.vnet.ibm.com>
In-Reply-To: <5109D313.1020409@linux.vnet.ibm.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2013 03:12 AM, Michael Wang wrote:
> I'm not sure, but just concern about this case:
> 
> 	group 0		cpu 0			cpu 1
> 			least idle		4 task
> 
> 	group 1		cpu 2			cpu 3
> 			1 task			1 task
> 
> The previous logical will pick group 1 and now it will take group 0, and
> that cause more imbalance, doesn't it?

That depends on load of CPU 0 + 1 vs CPU 2 + 3. If the four tasks on
CPU1 are idle then the previous code should return group 0.
If the four tasks are running at 100% each then two of them should be
migrated to CPU0 and this point the idle state does not matter :)

> May be check that state in find_idlest_cpu() will be better?

You say to move this from find_idlest_group() to find_idlest_cpu()?

> Regards,
> Michael Wang

Sebastian
