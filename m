Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518AbaI3UH0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 16:07:26 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:54180 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaI3UHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 16:07:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        atheurer@redhat.com, srao@redhat.com, fweisbec@gmail.com,
        oleg@redhat.com, Ingo Molnar <mingo@kernel.org>,
        umgwanakikbuti@gmail.com, akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>, lwoodman@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] sched, time: fix build error with 64 bit cputime_t on 32 bit systems
Date: Tue, 30 Sep 2014 22:07:03 +0200
Message-ID: <56858913.p3zUxZnKZn@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140930155947.070cdb1f@annuminas.surriel.com>
References: <2547036.UshV4pXvhf@wuerfel> <20140930133749.GD4241@worktop.programming.kicks-ass.net> <20140930155947.070cdb1f@annuminas.surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:6FQwY9bzdzIJJkFcJsZnOd3yfDZVP1N8p5K+gxQUJit
 PzI/1y9WEySymIvg7Pbw/ZiAXE+utowJx5r0vvR4IrO25Ojxvw
 tpAS5YCcCEayzD/A6MGo2dTPaW7r4CPqgDL78V9DpmHIaCucqu
 P4sZ7FDXNlCAmW5r4h7A8Tl7wV7B3DqgP7iqHT1fdjFZjCtmX0
 CkXZ03ug1lCm/kMAMGjpz1OylCwtfg/jakbgNpI5lT/8EEWIC5
 5mteEP5A3QIcC5X40Bj3WKLpb0umpazkQH1bhsQa0mpmkHJ1O5
 +yYmz1LKPpiPoogiFNnP+WK7LYvzZyXC3PX3KZqQugyBhYBT9c
 ofiN79Fw5jjoYU3QBGU4=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 September 2014 15:59:47 Rik van Riel wrote:
> Subject: sched,time: fix build error with 64 bit cputime_t on 32 bit systems
> 
> On 32 bit systems cmpxchg cannot handle 64 bit values, so
> some additional magic is required to allow a 32 bit system
> with CONFIG_VIRT_CPU_ACCOUNTING_GEN enabled to build.
> 
> Make sure the correct cmpxchg function is used when doing
> an atomic swap of a cputime_t.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> Reported-by: Arnd Bergmann <arnd@arndb.de>
> 

Now builds without warnings on both 32-bit and 64-bit cputime_t configurations
on arm32.

Acked-by: Arnd Bergmann <arnd@arndb.de>

Thanks!

	Arnd
