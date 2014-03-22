Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006AbaCVWAq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 18:00:46 -0400
Received: from lekensteyn.nl ([178.21.112.251]:42002 "EHLO lekensteyn.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159AbaCVWAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 18:00:44 -0400
From: Peter Wu <peter@lekensteyn.nl>
To: Gleb Natapov <gleb@kernel.org>
Cc: Venkatesh Srinivas <venkateshs@google.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: GPF in intel_pmu_lbr_reset() with qemu -cpu host
Date: Sat, 22 Mar 2014 23:00:24 +0100
Message-ID: <7070151.NcmQcQO4az@al>
User-Agent: KMail/4.12.3 (Linux/3.14.0-rc7-custom-00033-g8878439; KDE/4.12.3; x86_64; ; )
In-Reply-To: <20140322122758.GA4292@minantech.com>
References: <4055058.qLAukpngnj@al> <1558917.OgpeoK0IhF@al> <20140322122758.GA4292@minantech.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 22 March 2014 14:27:59 Gleb Natapov wrote:
> > but now I have a NULL dereference (in rapl_pmu_init). Previously, when
> > `-cpu SandyBridge` was passed to qemu, it would show this:
> > 
> >     [    0.016995] Performance Events: unsupported p6 CPU model 42 no PMU driver, software events only.
> > 
> > The same NULL pointer deref would be visible (slightly different
> > addresses, but the Code lines are equal). With `-host`, the NULL deref
> > with `-cpu host` contains:
> > 
> >     [    0.016445] Performance Events: 16-deep LBR, IvyBridge events, Intel PMU driver.
> > 
> > Full dmesg below.
> > 
> I am confused. Do you see crash now with -cpu SandyBridge and -cpu host, or -cpu host only?

The RAPL crash is seen with both SandyBridge and host, I mentioned SB
because that environment should be more constant than "host" (which
depends on the CPU you have on, well, the host).

Peter

