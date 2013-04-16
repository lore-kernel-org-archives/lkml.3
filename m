Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964908Ab3DPKFc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 06:05:32 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48157 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964853Ab3DPKFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 06:05:30 -0400
Date: Tue, 16 Apr 2013 11:05:05 +0100
From: Will Deacon <will.deacon@arm.com>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH v2 optional 3/3] mutex: back out architecture specific
 check for negative mutex count
Message-ID: <20130416100505.GD31156@mudshark.cambridge.arm.com>
References: <1366036679-9702-1-git-send-email-Waiman.Long@hp.com>
 <1366036679-9702-4-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366036679-9702-4-git-send-email-Waiman.Long@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 03:37:59PM +0100, Waiman Long wrote:
> If it is confirmed that all the supported architectures can allow a
> negative mutex count without incorrect behavior, we can then back
> out the architecture specific change and allow the mutex count to
> go to any negative number. That should further reduce contention for
> non-x86 architecture.
> 
> If this is not the case, this patch should be dropped.

A good starting point might be to look at the asm-generic mutex
implementations, which clears up the majority of architectures. A cursory
glance at mutex-dec.h suggests that it's OK to me...

Will
