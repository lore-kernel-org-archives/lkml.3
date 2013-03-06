Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655Ab3CFV3g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 16:29:36 -0500
Received: from www.linutronix.de ([62.245.132.108]:45519 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936Ab3CFV3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 16:29:35 -0500
Date: Wed, 6 Mar 2013 22:29:21 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "H. Peter Anvin" <hpa@linux.intel.com>
cc: Feng Tang <feng.tang@intel.com>, John Stultz <john.stultz@linaro.org>,
        Ingo Molnar <mingo@elte.hu>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, x86@kernel.org,
        Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org, gong.chen@linux.intel.com
Subject: Re: [PATCH v3 4/5] clocksource: Enable clocksource_cyc2ns() to cover
 big cycles
In-Reply-To: <5137B30D.8060509@linux.intel.com>
Message-ID: <alpine.LFD.2.02.1303062225460.22263@ionos>
References: <1362554271-22382-1-git-send-email-feng.tang@intel.com> <1362554271-22382-5-git-send-email-feng.tang@intel.com> <alpine.LFD.2.02.1303061451340.22263@ionos> <5137AF96.6050003@linux.intel.com> <alpine.LFD.2.02.1303062215190.22263@ionos>
 <5137B30D.8060509@linux.intel.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1921361005-1362605362=:22263"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1921361005-1362605362=:22263
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Wed, 6 Mar 2013, H. Peter Anvin wrote:
> On 03/06/2013 01:15 PM, Thomas Gleixner wrote:
> > On Wed, 6 Mar 2013, H. Peter Anvin wrote:
> > 
> >> On 03/06/2013 06:09 AM, Thomas Gleixner wrote:
> >>>
> >>> This breaks everything which does not have a 64/32bit divide
> >>> instruction. And you can't replace it with do_div() as that would
> >>> impose massive overhead on those architectures in the fast path.
> >>>
> >>
> >> Could we do the same kind of scaling-by-multiplication that we do in
> >> kernel/time.c for this?
> > 
> > Not sure what you are referring to. kernel/time.c contains a lot of stuff :)
> > 
> 
> This stuff, specifically the third clause (which incidentally could be
> extended to the fourth clause without much trouble... I have
> experimented with it already.)
> 
> It uses a N*N->2N multiply and a shift to do overflowless scaling; it is
> ±1 LSB in the upper half of the value range with can be remedied with an
> additional 2N add.

That's compile time. We need this at runtime and we do not want to
reduce the accuracy. That's precision timekeeping not jiffies :)

Thanks,

	tglx
--8323328-1921361005-1362605362=:22263--
