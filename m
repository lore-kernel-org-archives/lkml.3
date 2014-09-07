Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456AbaIGODR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 10:03:17 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:22941 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752010AbaIGODQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 10:03:16 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+OXW+wXxAt8+Od6Gcl6bpF/McDYmcIm18=
X-DKIM: OpenDKIM Filter v2.0.1 titan 3703A5DA542
Date: Sun, 7 Sep 2014 10:02:55 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Mark Brown <broonie@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linaro-kernel@lists.linaro.org, Geoff Levand <geoff@infradead.org>,
        linux-kernel@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] irq: gic-v3: Tag all low level accessors
 __maybey_unused
Message-ID: <20140907140255.GB30828@titan.lakedaemon.net>
References: <1406748194-21094-1-git-send-email-broonie@kernel.org>
 <20140817170453.GE12769@titan.lakedaemon.net>
 <20140906125412.GA32429@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140906125412.GA32429@sirena.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark, Stephen,

On Sat, Sep 06, 2014 at 01:54:12PM +0100, Mark Brown wrote:
> On Sun, Aug 17, 2014 at 01:04:53PM -0400, Jason Cooper wrote:
> > On Wed, Jul 30, 2014 at 08:23:14PM +0100, Mark Brown wrote:
> > > From: Mark Brown <broonie@linaro.org>
> 
> > > This is only really needed for gic_write_sgi1r in the !SMP case since it
> > > is only referenced in the SMP initialisation code but it seems better to
> > > have these functions all next to each other and declared consistently.
> 
> > > Signed-off-by: Mark Brown <broonie@linaro.org>
> > > ---
> > >  drivers/irqchip/irq-gic-v3.c | 10 +++++-----
> > >  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> > Applied to irqchip/urgent
> 
> This appears to have disappeared from -next and the warning is back.

Hmm, interesting. Here's what I have in irqchip/for-next,irqchip/urgent:

  c44e9d77fd1c irqchip: gic-v3: Tag all low level accessors __maybe_unused
  ddc86821ee2c irqchip: gic-v3: Only define gic_peek_irq() when building SMP

and:

$ git tag --contains c44e9d77fd1c | grep ^next | sort -V
next-20140820
next-20140822
next-20140823
next-20140825
next-20140826
next-20140827
next-20140828
next-20140829

To see whether I forgot to add /urgent to /for-next or if
irqchip/for-next was dropped, I did the same search against the first
commit I added to irqchip/core:

$ git tag --contains 1c36d42c4ffe | grep ^next | sort -V
next-20140822
next-20140823
next-20140825
next-20140826
next-20140827
next-20140828
next-20140829

Also dropped on the 30th.  So, unless I really screwed up, -next is no
longer pulling irqchip/for-next.

Stephen, could you please look and see if this is the case?

thx,

Jason.
