Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab3LJO3O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 09:29:14 -0500
Received: from www.linutronix.de ([62.245.132.108]:48482 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650Ab3LJO3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 09:29:12 -0500
Date: Tue, 10 Dec 2013 15:29:08 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mike Galbraith <bitbucket@online.de>
cc: Len Brown <lenb@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Eder <jeder@redhat.com>, x86@kernel.org
Subject: Re: 50 Watt idle power regression bisected to Linux-3.10
In-Reply-To: <1386652637.5374.72.camel@marge.simpson.net>
Message-ID: <alpine.DEB.2.02.1312101458040.28330@ionos.tec.linutronix.de>
References: <CAJvTdK=+aNN66mYpCGgbHGCHhYQAKx-vB0kJSWjVpsNb_hOAtQ@mail.gmail.com>  <1386478624.4748.19.camel@marge.simpson.net>  <CAJvTdKn_2mihtMLiQVNCOp_zokx8CsSr2c5NhbkbfJ-qvma-8Q@mail.gmail.com>  <1386559014.4875.16.camel@marge.simpson.net>
 <1386652637.5374.72.camel@marge.simpson.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Dec 2013, Mike Galbraith wrote:
> vogelweide:~/:[130]# turbostat -P -i 60
> pk cor CPU    %c0  GHz  TSC SMI    %c1    %c3    %c6 CTMP   %pc3   %pc6
>              0.02 2.12 2.26   0  43.40  56.57   0.00   53  33.81   0.00
>  0   0   0   0.23 2.10 2.26   5  65.47  34.30   0.00   52  10.69   0.00

...
 
> That, vs solid >99% pc3 for old 3.0 enterprise kernel.  What happened,
> dunno, kernel called itself master.  Whatever, I don't like test bogons,
> and this is one, so I thought I should let you know.  DL980 refuses to
> come close to the previous result.

Hmm, that's very similar to the issue Len is seing on his quad socket WM.

But I can't see it on my dual socket SNB, neither does PeterZ on his
dual socket WM machine. Heisenbugs ....

Can you offline all cpus except core 0, enable all trace events (nop
tracer), run "sleep 100" and stop and grab the trace? Please make sure
that your tracebuffer is big enough to cover the full thing.

Thanks,

	tglx
