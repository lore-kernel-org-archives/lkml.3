Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751376AbaC1HiJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 03:38:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:34775 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099AbaC1HiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 03:38:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,749,1389772800"; 
   d="scan'208";a="508827790"
Date: Fri, 28 Mar 2014 15:37:18 +0800
From: Feng Tang <feng.tang@intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Clemens Ladisch <clemens@ladisch.de>,
        Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v2] x86: hpet: Don't default CONFIG_HPET_TIMER to be y
 for X86_64
Message-ID: <20140328073718.GA12762@feng-snb>
References: <1395975316-4795-1-git-send-email-feng.tang@intel.com>
 <20140328071716.GC30107@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140328071716.GC30107@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Thanks for reviewing this

On Fri, Mar 28, 2014 at 08:17:16AM +0100, Ingo Molnar wrote:
> 
> * Feng Tang <feng.tang@intel.com> wrote:
> 
> > On many new phone/tablet platforms like Baytrail/Merrifield etc, the 
> > HPET are either defeatured or has some problem to be used as a 
> > reliable timer. As these platforms also have X86_64, we should not 
> > make HPET_TIMER default y for all X86_64.
> 
> NAK!
> 
> If the HPET is unreliable on a specific platform then any of the 
> following solutions would address the problem (in order of 
> preference):
> 
>  - the hardware should not expose it. Why waste silicon on something 
>    that does not work?
> 
>  - or the firmware should not expose it. Why expose something that 
>    does not work?

Agreed, I've raised problem to BIOS vendor, but the response is very slow,
and those hardware/BIOS may already hit the market as a product.

> 
>  - or the kernel should have a quirk to reliably disable it. Why 
>    should we crash or misbehave if a driver is built into the
>    kernel?

I thought about this before, HPET doesn't have PCI ID like stuff, only
thing I can think of to identify them may be the CPU family/ID. 
Runtime check the reliability of HPET may be difficult, as we don't
know if the 8254 or the TSC are the golden timer to check HPET.

Thanks,
Feng

