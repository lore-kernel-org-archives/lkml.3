Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303AbaKCQpt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 11:45:49 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:37160 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbaKCQpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 11:45:46 -0500
Date: Mon, 3 Nov 2014 08:45:39 -0800
From: josh@joshtriplett.org
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, x86@kernel.org
Subject: Re: [PATCH v4 10/10] x86: Support compiling out userspace IO (iopl
 and ioperm)
Message-ID: <20141103164539.GA18104@cloud>
References: <cover.1414870871.git.josh@joshtriplett.org>
 <ec10c497d3a7f44f335dbc267edd6de5b4acd671.1414870871.git.josh@joshtriplett.org>
 <20141103121049.2f0c81a9@alan.etchedpixels.co.uk>
 <20141103141357.GC21818@thin>
 <20141103152748.327032f8@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141103152748.327032f8@alan.etchedpixels.co.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 03:27:48PM +0000, One Thousand Gnomes wrote:
> > > This isn't unreasonable but there are drivers with userspace helpers that
> > > use iopl/ioperm type functionality where you should be doing a SELECT of
> > > X86_IOPORT. The one that comes to mind is the uvesa driver. From a quick
> > > scan it may these days be the only mainstream one that needs the select
> > > adding.
> > 
> > Should kernel drivers really express dependencies that only their
> > (current instances of) corresponding userspace components need?
> > Something seems wrong about that.
> 
> uvesafb will always need X86_IOPORT. It's kind of implicit in the design.
> I'm not suggesting that fbdev should select X86_IOPORT but in the uvesafb
> case at least it's completely useless to have one and not the other.

OK, fair enough.  Do you want the patch series respun to add that select
in patch 10/10, or would you consider it sufficient to add that in a
followup patch, since the kernel will build and boot either way (so it
won't break bisection)?

Related to that: Is it intentional that FB_UVESA doesn't depend on X86,
even though FB_VESA does?  Does v86d run on non-x86 hardware via
emulation?  If so, should FB_UVESA have "select X86_IOPORT if X86"?

- Josh Triplett
