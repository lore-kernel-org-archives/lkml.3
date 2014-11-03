Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614AbaKCP2T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 10:28:19 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:53302 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579AbaKCP2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 10:28:17 -0500
Date: Mon, 3 Nov 2014 15:27:48 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Josh Triplett <josh@joshtriplett.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, x86@kernel.org
Subject: Re: [PATCH v4 10/10] x86: Support compiling out userspace IO (iopl
 and ioperm)
Message-ID: <20141103152748.327032f8@alan.etchedpixels.co.uk>
In-Reply-To: <20141103141357.GC21818@thin>
References: <cover.1414870871.git.josh@joshtriplett.org>
	<ec10c497d3a7f44f335dbc267edd6de5b4acd671.1414870871.git.josh@joshtriplett.org>
	<20141103121049.2f0c81a9@alan.etchedpixels.co.uk>
	<20141103141357.GC21818@thin>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > This isn't unreasonable but there are drivers with userspace helpers that
> > use iopl/ioperm type functionality where you should be doing a SELECT of
> > X86_IOPORT. The one that comes to mind is the uvesa driver. From a quick
> > scan it may these days be the only mainstream one that needs the select
> > adding.
> 
> Should kernel drivers really express dependencies that only their
> (current instances of) corresponding userspace components need?
> Something seems wrong about that.

uvesafb will always need X86_IOPORT. It's kind of implicit in the design.
I'm not suggesting that fbdev should select X86_IOPORT but in the uvesafb
case at least it's completely useless to have one and not the other.

> IO_BITMAP_LONGS already gets defined to (0/sizeof(long)).  And as far as
> I can tell, that would only work for init_tss_io, not anything else.
> Even then, that would only work with a zero-size array left around in
> tss_struct, which doesn't seem appropriate.  The remaining ifdefs wrap
> code that GCC could not constant-fold away, and making that code
> constant-foldable seems significantly more invasive than the ifdefs.

OK
