Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043AbaIEUt3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 16:49:29 -0400
Received: from www.linutronix.de ([62.245.132.108]:34383 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbaIEUt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 16:49:26 -0400
Date: Fri, 5 Sep 2014 22:48:34 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, Peter Hurley <peter@hurleysoftware.com>,
        Marc Gauthier <marc@cadence.com>, Michael Cree <mcree@orcon.net.nz>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Laight <David.Laight@ACULAB.COM>,
        Jakub Jelinek <jakub@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Miroslav Franc <mfranc@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        "linux-alpha@vger.kernel.org" <linux-alpha@vger.kernel.org>
Subject: Re: bit fields && data tearing
In-Reply-To: <20140905204312.GA5001@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.10.1409052247460.5472@nanos>
References: <5408E458.3@zytor.com> <54090AF4.7060406@hurleysoftware.com> <54091B30.2090509@zytor.com> <20140905081648.GB5281@omega> <20140905180950.GU5001@linux.vnet.ibm.com> <540A05F7.1070202@hurleysoftware.com> <20140905190506.GV5001@linux.vnet.ibm.com>
 <8CA974F497CA064FA9926E10ABCC061F05F97E7B77@MAILSJ4.global.cadence.com> <540A19B8.4010907@hurleysoftware.com> <540A1E6C.2020005@zytor.com> <20140905204312.GA5001@linux.vnet.ibm.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Sep 2014, Paul E. McKenney wrote:
> On Fri, Sep 05, 2014 at 01:34:52PM -0700, H. Peter Anvin wrote:
> > On 09/05/2014 01:14 PM, Peter Hurley wrote:
> > > 
> > > Here's how I read the two statements.
> > > 
> > > First, the commit message:
> > > 
> > > "It [this commit] documents that CPUs [supported by the Linux kernel]
> > > _must provide_ atomic one-byte and two-byte naturally aligned loads and stores."
> > > 
> > > Second, in the body of the document:
> > > 
> > > "The Linux kernel no longer supports pre-EV56 Alpha CPUs, because these
> > > older CPUs _do not provide_ atomic one-byte and two-byte loads and stores."
> > > 
> > 
> > Does this apply in general or only to SMP configurations?  I guess
> > non-SMP configurations would still have problems if interrupted in the
> > wrong place...
> 
> And preemption could cause problems, too.  So I believe that it needs
> to be universal.

Well preemption is usually caused by an interrupt, except you have a
combined load and preempt instruction :)

Thanks,

	tglx
