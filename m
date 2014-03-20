Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759056AbaCTPMQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 11:12:16 -0400
Received: from www.linutronix.de ([62.245.132.108]:42886 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451AbaCTPMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 11:12:15 -0400
Date: Thu, 20 Mar 2014 16:12:21 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Vince Weaver <vincent.weaver@maine.edu>
cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: rb tree hrtimer lockup bug (found by perf_fuzzer)
In-Reply-To: <alpine.DEB.2.10.1403201045560.21603@vincent-weaver-1.um.maine.edu>
Message-ID: <alpine.DEB.2.02.1403201609540.18573@ionos.tec.linutronix.de>
References: <alpine.DEB.2.10.1403031526210.11945@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1403181250110.14816@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1403181921010.18573@ionos.tec.linutronix.de> <alpine.DEB.2.10.1403181523360.15687@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.02.1403182149540.18573@ionos.tec.linutronix.de> <alpine.DEB.2.10.1403181705000.15687@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1403182218170.18573@ionos.tec.linutronix.de> <alpine.DEB.2.10.1403190941170.18343@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.02.1403191456120.18573@ionos.tec.linutronix.de> <alpine.DEB.2.10.1403191039560.18652@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1403191552570.18573@ionos.tec.linutronix.de> <alpine.DEB.2.10.1403191300540.18754@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.02.1403201056020.18573@ionos.tec.linutronix.de> <alpine.DEB.2.10.1403201045560.21603@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Mar 2014, Vince Weaver wrote:

> On Thu, 20 Mar 2014, Thomas Gleixner wrote:
> > Find a more brute force method to get this decoded below. Full patch
> > this time, please zap the old one. That should spill out the recent
> > debug object calls and we can just hope, that we get enough history to
> > find this horror.
> 
> The patch didn't compile, as "addr" was not known.  I guessed and
> changed it to "oaddr", but if that's not what you meant then the
> trace results might be useless.

Yeah, it causes the explosion in the debug object code. This should
have been:

+                       trace_printk("Tracking Object free: %s %p %pS\n",
+                                    descr->name, obj->object, obj->hint);

 
Sorry, -ENOTENOUGHCOFFEE to switch on DEBUG_OBJECTS_FREE=y before
compile testing.

Thanks,

	tglx
