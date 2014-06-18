Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbaFRS7o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 14:59:44 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:54038 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbaFRS7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 14:59:42 -0400
Date: Wed, 18 Jun 2014 14:59:39 -0400
From: "Gabriel L. Somlo" <gsomlo@gmail.com>
To: Eric Northup <digitaleric@google.com>
Cc: Nadav Amit <nadav.amit@gmail.com>, Nadav Amit <namit@cs.technion.ac.il>,
        Paolo Bonzini <pbonzini@redhat.com>, gleb@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>, joro@8bytes.org, mst@redhat.com,
        agraf@suse.de
Subject: Re: [PATCH 3/3] KVM: x86: correct mwait and monitor emulation
Message-ID: <20140618185939.GF1695@ERROL.INI.CMU.EDU>
References: <1403101176-23664-1-git-send-email-namit@cs.technion.ac.il>
 <1403101176-23664-4-git-send-email-namit@cs.technion.ac.il>
 <CAG7+5M1T=OSqMLOJjb-txRCL_J_q=KSNV9yOfeP=98YuyD27Fw@mail.gmail.com>
 <53A1D921.2090305@gmail.com>
 <CAG7+5M0cxB3-Wiv-mo6qYN=c08ejGCvJ7MKPc=XteSkTYYCdUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG7+5M0cxB3-Wiv-mo6qYN=c08ejGCvJ7MKPc=XteSkTYYCdUg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 11:30:07AM -0700, Eric Northup wrote:
> Quoting Gabriel's post http://www.spinics.net/lists/kvm/msg103792.html :
> 
> [...]
> 
> > E.g., OS X 10.5 *does* check CPUID, and panics if it doesn't find it.
> > It needs the MONITOR cpuid flag to be on, *and* the actual
> > instructions to work.

That was an argument in favor of finding a mechanism to allow (qemu)
users to enable an otherwise default-off monitor cpuid flag.

We definitely don't want to advertise monitor/mwait availability to
guests which would otherwise sanely fail back to a hlt-based idle loop
when cpuid tells them monitor/mwait are not available :)

However, check my earlier proposal of backing out of monitor/mwait
entirely (as it turns out, there's a kernel command line to tell OS X
not to use monitor/mwait, which is IMHO vastly preferable to creating
"undocumented" KVM hacks :)

Thanks much,
--Gabriel
