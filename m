Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbaKUWpN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 17:45:13 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:49059 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750820AbaKUWpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 17:45:11 -0500
Date: Fri, 21 Nov 2014 17:45:00 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Don Zickus <dzickus@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141121174500.3facb44a@gandalf.local.home>
In-Reply-To: <20141121215040.GC9198@lerouge>
References: <alpine.DEB.2.11.1411202204030.3950@nanos>
	<20141120221122.GA25393@htj.dyndns.org>
	<alpine.DEB.2.11.1411202315230.3950@nanos>
	<20141120230514.GB25393@htj.dyndns.org>
	<alpine.DEB.2.11.1411210109460.6439@nanos>
	<20141121141332.GA8808@lerouge>
	<20141121162506.GA15461@htj.dyndns.org>
	<20141121170151.GC30603@home.goodmis.org>
	<20141121213204.GA9198@lerouge>
	<CALCETrV9dNVS=OgDW3eO=ztNCQ6UAzYZvzwDBqd-BqmVpg7EHA@mail.gmail.com>
	<20141121215040.GC9198@lerouge>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Nov 2014 22:50:41 +0100
Frederic Weisbecker <fweisbec@gmail.com> wrote:
\
> > Otherwise if we have a page fault inside do_page_fault, it's just a
> > nested page fault.
> 
> Oh ok!
> 
> But we still have the cr2 issue that Steve talked about.
>

Nope, as I looked at the code, I noticed that do_page_fault isn't traced
which is the wrapper for __do_page_fault which is. And do_page_fault()
saves off the cr2 before calling anything else.

So we are ok in this respect as well.

-- Steve
