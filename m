Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851Ab3LKPCz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 10:02:55 -0500
Received: from www.linutronix.de ([62.245.132.108]:34811 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350Ab3LKPCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 10:02:54 -0500
Date: Wed, 11 Dec 2013 16:02:41 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@kernel.org>
cc: Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <bitbucket@online.de>, Borislav Petkov <bp@alien8.de>,
        Len Brown <lenb@kernel.org>, Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Eder <jeder@redhat.com>, x86@kernel.org
Subject: Re: 50 Watt idle power regression bisected to Linux-3.10
In-Reply-To: <20131211144238.GA4510@gmail.com>
Message-ID: <alpine.DEB.2.02.1312111556390.28330@ionos.tec.linutronix.de>
References: <1386559014.4875.16.camel@marge.simpson.net> <1386652637.5374.72.camel@marge.simpson.net> <alpine.DEB.2.02.1312101458040.28330@ionos.tec.linutronix.de> <alpine.DEB.2.02.1312110030330.28330@ionos.tec.linutronix.de> <1386732093.5964.6.camel@marge.simpson.net>
 <alpine.DEB.2.02.1312111206200.28330@ionos.tec.linutronix.de> <20131211113839.GF21683@pd.tnic> <20131211115239.GA21999@twins.programming.kicks-ass.net> <1386764955.12005.60.camel@marge.simpson.net> <20131211124352.GB21999@twins.programming.kicks-ass.net>
 <20131211144238.GA4510@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Dec 2013, Ingo Molnar wrote:
> 
> Another thing that is required I think is to issue a write barrier 
> before CLFLUSH instruction. By my (possibly incorrect ...) reading of 
> the documentation CLFLUSH does not appear to be ordered (at all), so 
> it might execute before the modification to the affected memory?

We already have a write barrier in the code which modifies
current_thread_info()->flags.
 
Thanks,

	tglx
