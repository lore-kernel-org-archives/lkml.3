Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714AbaB0Dj3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 22:39:29 -0500
Received: from mga09.intel.com ([134.134.136.24]:13616 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466AbaB0Dj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 22:39:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,551,1389772800"; 
   d="scan'208";a="463147473"
Date: Wed, 26 Feb 2014 19:39:20 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Stefani Seibold <stefani@seibold.net>, X86 ML <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        andriy.shevchenko@linux.intel.com, Martin.Runge@rohde-schwarz.com,
        Andreas.Brief@rohde-schwarz.com
Subject: Re: [PATCH 1/2] x86: Mark __vdso entries as asmlinkage
Message-ID: <20140227033920.GI12219@tassilo.jf.intel.com>
References: <cover.1393462777.git.luto@amacapital.net>
 <ecbd286ccd2ac038740a07cc04f5d98e96af669f.1393462777.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ecbd286ccd2ac038740a07cc04f5d98e96af669f.1393462777.git.luto@amacapital.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 05:02:13PM -0800, Andy Lutomirski wrote:
> This makes no difference for 64-bit, bit it's critical for 32-bit code:
> these functions are called from outside the kernel, so they need to comply
> with the ABI.

That's an odd patch. If that was wrong things couldn't have worked at all.
Probably hidden by inlining? If yes just make it static

Also you would rather need notrace more often.

-Andi
