Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921Ab3LBDQf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 22:16:35 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:20506 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891Ab3LBDQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 22:16:33 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+yBJSM/ZAxfqMTZ6RXbfC59MWYEG7KBYI=
Date: Sun, 1 Dec 2013 22:15:58 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: boris brezillon <b.brezillon@overkiz.com>
Cc: Mike Turquette <mturquette@linaro.org>, Rob Landley <rob@landley.net>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 2/2] clk: add accuracy support for fixed clock
Message-ID: <20131202031558.GB29282@titan.lakedaemon.net>
References: <1385556285-19180-1-git-send-email-b.brezillon@overkiz.com>
 <1385556285-19180-3-git-send-email-b.brezillon@overkiz.com>
 <20131127145620.GR2879@titan.lakedaemon.net>
 <5296298C.9040300@overkiz.com>
 <20131127181042.16819.36364@quantum>
 <5296F8B2.9080807@overkiz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5296F8B2.9080807@overkiz.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 28, 2013 at 09:02:58AM +0100, boris brezillon wrote:
> On 27/11/2013 19:10, Mike Turquette wrote:
> >Quoting boris brezillon (2013-11-27 09:19:08)
> >>>On Wed, Nov 27, 2013 at 01:44:45PM +0100, Boris BREZILLON wrote:
...
> >>>I would also prefer to see an unknown accuracy be -1.
> >>I decided to keep 0 as a default value for unimplemented recalc_accuracy
> >>(or unspecified fixed accuracy) to keep existing implementation coherent.
> >>
> >>0 means the clk is perfect, and I thought it would be easier to handle a
> >>perfect clk (even if this is not really the case) than handling an error
> >>case.
> >>
> >>Another aspect is the propagation of the clk accuracy accross the clk tree.
> >>Returning -1 in the middle of the clk chain will drop the previous clk
> >>accuracy
> >>calculation.
> >>
> >>Anyway, I can change this if you think this is more appropriate.
> >What about the absence of the property?
> >Instead of requiring a -1 value
> >can we simply detect that the property does not exist? This is nicer for
> >backwards compatibility with existing DTS.
> 
> I already handle the absence of the clock-accuracy property.
> In this case the clock is considered perfect (accuracy = 0 ppb).

Yeah, in order to calculate the theoretical accuracy of a leaf node, a
missing accuracy in the middle of the chain really derails things.
Since my previous concern (modelling the real accuracy of the clocks) is
not an issue here, I think assuming the absent accuracy is 0 is fine.
Especially since all Boris is trying to do is avoid the RC clocks.

thx,

Jason.
