Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbaCaNsR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 09:48:17 -0400
Received: from www.linutronix.de ([62.245.132.108]:60564 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755051AbaCaNry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 09:47:54 -0400
Date: Mon, 31 Mar 2014 15:48:01 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Vince Weaver <vincent.weaver@maine.edu>
cc: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Greg KH <greg@kroah.com>
Subject: Re: rb tree hrtimer lockup bug (found by perf_fuzzer)
In-Reply-To: <alpine.DEB.2.10.1403310926060.7985@vincent-weaver-1.um.maine.edu>
Message-ID: <alpine.DEB.2.02.1403311545150.14882@ionos.tec.linutronix.de>
References: <alpine.DEB.2.10.1403031526210.11945@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1403201724430.23339@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1403210956000.18573@ionos.tec.linutronix.de> <alpine.DEB.2.10.1403211610430.30801@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.02.1403221118060.18573@ionos.tec.linutronix.de> <alpine.DEB.2.02.1403221419000.18573@ionos.tec.linutronix.de> <alpine.DEB.2.02.1403231613230.18573@ionos.tec.linutronix.de> <alpine.DEB.2.02.1403240017430.18573@ionos.tec.linutronix.de>
 <alpine.DEB.2.10.1403251702110.19541@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1403252220110.4094@ionos.tec.linutronix.de> <alpine.DEB.2.10.1403261731390.26530@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1403262248170.31401@ionos.tec.linutronix.de>
 <alpine.DEB.2.10.1403270940250.27563@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1403311201520.14882@ionos.tec.linutronix.de> <alpine.DEB.2.10.1403310926060.7985@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Mar 2014, Vince Weaver wrote:

> On Mon, 31 Mar 2014, Thomas Gleixner wrote:
> > 
> > Vince, can you please disable CONFIG_DEBUG_KOBJECT_RELEASE and remove
> > all the debug patches to see whether the issue goes away?
> 
> It makes the crash on boot go away, but it is still possible to trigger

Ok. So we can leave that issue to the tty folks.

> a similar crash (hrtimer oopsing due to corrupt rbtree) using the 
> perf_fuzzer.

I did not expect that it goes away.
 
> This all started because when trying to debug the perf_fuzzer crash I 
> was told to turn on the extra debugging, and then that caused the crash at 
> boot.

I know. Thanks for the patience in decoding this nastiness.

> The fuzzer related crash happens on both a core2 and a haswell machine
> and it triggers pretty quickly when fuzzing, I'll have to go back and see 
> how repeatable it is.

Can you please reenable CONFIG_DEBUG_OBJECTS and check whether they
catch something?

Thanks,

	tglx


