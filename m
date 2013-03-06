Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab3CFVdQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 16:33:16 -0500
Received: from www.linutronix.de ([62.245.132.108]:45540 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755773Ab3CFVdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 16:33:15 -0500
Date: Wed, 6 Mar 2013 22:33:08 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Feng Tang <feng.tang@intel.com>
cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, x86@kernel.org,
        Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org, gong.chen@linux.intel.com
Subject: Re: [PATCH v3 5/5] timekeeping: utilize the suspend-nonstop clocksource
 to count suspended time
In-Reply-To: <20130306142914.GA25790@feng-snb>
Message-ID: <alpine.LFD.2.02.1303062231000.22263@ionos>
References: <1362554271-22382-1-git-send-email-feng.tang@intel.com> <1362554271-22382-6-git-send-email-feng.tang@intel.com> <alpine.LFD.2.02.1303061512110.22263@ionos> <20130306142914.GA25790@feng-snb>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Mar 2013, Feng Tang wrote:
> On Wed, Mar 06, 2013 at 03:15:49PM +0100, Thomas Gleixner wrote:
> > If the suspend time measured by the nonstop clocksource is 0.999 sec
> > then we throw it away and then let the RTC code inject inaccurate
> > sleep time? Brilliant design, really.
> 
> Emm, I wrote the code with an assumption that the sleep itself and the
> enter/exit processes will be longer than 1 second.
> 
> I can initialize the ts_delta to (0, 0} and change the check condition
> to 
> 	if (ts_delta.tv_sec || ts_delta.tv_nsec)
> 

To be honest, I hate this abuse of ts_delta as a condition. Use a
separate condition variable to make clear what the hell that code is
doing. This is not a fast path and I really prefer understandable code
over magic microoptimizations for no value.

Thanks,

	tglx
