Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936699Ab3DIJX2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 05:23:28 -0400
Received: from www.linutronix.de ([62.245.132.108]:44299 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936673Ab3DIJXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 05:23:23 -0400
Date: Tue, 9 Apr 2013 11:23:15 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Kees Cook <keescook@chromium.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, Alex Shi <alex.shi@intel.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org,
        kernel-hardening@lists.openwall.com,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>,
        Eric Northup <digitaleric@google.com>
Subject: Re: [PATCH] x86: make IDT read-only
In-Reply-To: <51634935.9010905@zytor.com>
Message-ID: <alpine.LFD.2.02.1304091122490.21884@ionos>
References: <20130408224328.GA17641@www.outflux.net> <51634935.9010905@zytor.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Apr 2013, H. Peter Anvin wrote:

> On 04/08/2013 03:43 PM, Kees Cook wrote:
> > This makes the IDT unconditionally read-only. This primarily removes
> > the IDT from being a target for arbitrary memory write attacks. It has
> > an added benefit of also not leaking (via the "sidt" instruction) the
> > kernel base offset, if it has been relocated.
> > 
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > Cc: Eric Northup <digitaleric@google.com>
> 
> Also, tglx: does this interfere with your per-cpu IDT efforts?

I don't think so. And it's on the backburner at the moment.

Thanks,

	tglx
