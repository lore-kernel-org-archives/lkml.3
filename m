Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbaILISN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 04:18:13 -0400
Received: from www.linutronix.de ([62.245.132.108]:45964 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475AbaILISI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 04:18:08 -0400
Date: Fri, 12 Sep 2014 10:17:54 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Ren, Qiaowei" <qiaowei.ren@intel.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v8 06/10] mips: sync struct siginfo with general
 version
In-Reply-To: <9E0BE1322F2F2246BD820DA9FC397ADE017A3FF0@shsmsx102.ccr.corp.intel.com>
Message-ID: <alpine.DEB.2.10.1409121015070.4178@nanos>
References: <1410425210-24789-1-git-send-email-qiaowei.ren@intel.com> <1410425210-24789-7-git-send-email-qiaowei.ren@intel.com> <alpine.DEB.2.10.1409120007550.4178@nanos> <9E0BE1322F2F2246BD820DA9FC397ADE017A3FF0@shsmsx102.ccr.corp.intel.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Sep 2014, Ren, Qiaowei wrote:
> On 2014-09-12, Thomas Gleixner wrote:
> > On Thu, 11 Sep 2014, Qiaowei Ren wrote:
> > 
> >> Due to new fields about bound violation added into struct siginfo,
> >> this patch syncs it with general version to avoid build issue.
> > 
> > You completely fail to explain which build issue is addressed by this
> > patch. The code you added to kernel/signal.c which accesses _addr_bnd
> > is guarded by
> > 
> > +#ifdef SEGV_BNDERR
> > 
> > which is not defined my MIPS. Also why is this only affecting MIPS and
> > not any other architecture which provides its own struct siginfo ?
> > 
> > That patch makes no sense at all, at least not without a proper explanation.
> >
> For arch=mips, siginfo.h (arch/mips/include/uapi/asm/siginfo.h) will
> include general siginfo.h, and only replace general stuct siginfo
> with mips specific struct siginfo. So SEGV_BNDERR will be defined
> for all archs, and we will get error like "no _lower in struct
> siginfo" when arch=mips.

> In addition, only MIPS arch define its own struct siginfo, so this
> is only affecting MIPS.

So IA64 does not count as an architecture and therefor does not need
the same treatment, right?

Thanks,

	tglx


