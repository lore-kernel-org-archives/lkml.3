Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933872AbaGWXMJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 19:12:09 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:50472 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933646AbaGWXME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 19:12:04 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/GmlrJsIA5G45Y8mmhr+bNV6onPrsyktQ=
X-DKIM: OpenDKIM Filter v2.0.1 titan 51FAD5B44E7
Date: Wed, 23 Jul 2014 19:12:01 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Florian Fainelli <f.fainelli@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] genirq: bug on inconstent flags and flow handler
Message-ID: <20140723231201.GJ23220@titan.lakedaemon.net>
References: <1406141136-19501-1-git-send-email-f.fainelli@gmail.com>
 <alpine.DEB.2.10.1407232048240.23352@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1407232048240.23352@nanos>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 08:49:46PM +0200, Thomas Gleixner wrote:
> On Wed, 23 Jul 2014, Florian Fainelli wrote:
> 
> > It is currently possible for a generic irq chip driver to set IRQ_LEVEL
> > and have its irq flow handler be handle_edge_irq. Setting IRQ_LEVEL in
> > such a case does not make sense, and will actually prevent e.g: the
> > software resend logic from kicking, and potential other problems too.
> > 
> > Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> > ---
> > Changes in v2:
> > - replaced WARN_ON() with BUG_ON() since we really don't want to continue
> >   as suggested by Jason Cooper
> 
> I disagree here. It's not a reason take the machine down. Its good
> enough to WARN. That keeps the machine alive and lets us debug that
> stuff.

Sure, I have no strong opinion either way.  On irc I mentioned that this
condition would most likely only arise when porting to a new SoC, so a
kernel developer that will know what to do.

I know for me personally, I need to be stopped mid-track and forced to
pay attention to something like this.  Otherwise, I'll forget and debug
for hours... :-)

thx,

Jason.
