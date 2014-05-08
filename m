Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640AbaEHP2m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 11:28:42 -0400
Received: from www.linutronix.de ([62.245.132.108]:56624 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbaEHP2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 11:28:41 -0400
Date: Thu, 8 May 2014 17:28:54 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dave Jones <davej@redhat.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>, peterz@infradead.org,
        davidlohr@hp.com, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [3.15-rc3] rtmutex-debug assertion.
In-Reply-To: <20140505182942.GA19129@redhat.com>
Message-ID: <alpine.DEB.2.02.1405081726250.6261@ionos.tec.linutronix.de>
References: <20140429151655.GA14277@redhat.com> <20140430001432.GA32142@redhat.com> <alpine.DEB.2.02.1404301113110.6261@ionos.tec.linutronix.de> <20140502045640.GA27264@redhat.com> <alpine.DEB.2.02.1405052002360.6261@ionos.tec.linutronix.de>
 <20140505182942.GA19129@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 May 2014, Dave Jones wrote:

> On Mon, May 05, 2014 at 08:08:02PM +0200, Thomas Gleixner wrote:
>  
>  > I twisted my brain around that for a fricking long time, but I really
>  > can't see the failure in the code.
>  > 
>  > Neither did I succeed to trigger the issue in a VM (with and without
>  > function tracing) on Linus latest.
>  > 
>  > I grabbed trinity source and did:
>  > 
>  > # ./trinity -l off -c futex -q
>  > 
>  > That should be enough, right?
> 
> yeah, that should do it.  That's with the version from git, or the
> last tarball ?  (I really should do another tarball release)

git
 
> Maybe try with -c <some number bigger than processor count>.
> On my 4 way haswell, I run with -C40 just to keep things busy while some
> processes idle. For something like futex, which sleeps a lot, this might
> be important.
> 
>  > All I see in dmesg are occasional ooms which kill random trinity
>  > childs. 
> 
> hm, that sounds odd. if it's only fuzzing futex, it shouldn't be
> doing much memory allocation.

It has a fast memory leak of some sort.

9271 tglx      20   0  198908  75320   2992 S   0.7  7.4   0:01.94 trinity-c0
9271 tglx      20   0  256888 104368   2992 S   3.3 10.2   0:02.78 trinity-c0

Thanks,

	tglx
