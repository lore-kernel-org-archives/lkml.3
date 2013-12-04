Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003Ab3LDTOX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 14:14:23 -0500
Received: from mail-yh0-f42.google.com ([209.85.213.42]:45555 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755983Ab3LDTOV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 14:14:21 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Jason Cooper <jason@lakedaemon.net>,
        "boris brezillon" <b.brezillon@overkiz.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <20131202031558.GB29282@titan.lakedaemon.net>
Cc: "Rob Landley" <rob@landley.net>, "Rob Herring" <rob.herring@calxeda.com>,
        "Pawel Moll" <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Stephen Warren" <swarren@wwwdotorg.org>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        "Russell King" <linux@arm.linux.org.uk>,
        "Nicolas Ferre" <nicolas.ferre@atmel.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <1385556285-19180-1-git-send-email-b.brezillon@overkiz.com>
 <1385556285-19180-3-git-send-email-b.brezillon@overkiz.com>
 <20131127145620.GR2879@titan.lakedaemon.net> <5296298C.9040300@overkiz.com>
 <20131127181042.16819.36364@quantum> <5296F8B2.9080807@overkiz.com>
 <20131202031558.GB29282@titan.lakedaemon.net>
Message-ID: <20131204191410.29850.32443@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH v2 2/2] clk: add accuracy support for fixed clock
Date: Wed, 04 Dec 2013 11:14:10 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Jason Cooper (2013-12-01 19:15:58)
> On Thu, Nov 28, 2013 at 09:02:58AM +0100, boris brezillon wrote:
> > On 27/11/2013 19:10, Mike Turquette wrote:
> > >Quoting boris brezillon (2013-11-27 09:19:08)
> > >>>On Wed, Nov 27, 2013 at 01:44:45PM +0100, Boris BREZILLON wrote:
> ...
> > >>>I would also prefer to see an unknown accuracy be -1.
> > >>I decided to keep 0 as a default value for unimplemented recalc_accuracy
> > >>(or unspecified fixed accuracy) to keep existing implementation coherent.
> > >>
> > >>0 means the clk is perfect, and I thought it would be easier to handle a
> > >>perfect clk (even if this is not really the case) than handling an error
> > >>case.
> > >>
> > >>Another aspect is the propagation of the clk accuracy accross the clk tree.
> > >>Returning -1 in the middle of the clk chain will drop the previous clk
> > >>accuracy
> > >>calculation.
> > >>
> > >>Anyway, I can change this if you think this is more appropriate.
> > >What about the absence of the property?
> > >Instead of requiring a -1 value
> > >can we simply detect that the property does not exist? This is nicer for
> > >backwards compatibility with existing DTS.
> > 
> > I already handle the absence of the clock-accuracy property.
> > In this case the clock is considered perfect (accuracy = 0 ppb).
> 
> Yeah, in order to calculate the theoretical accuracy of a leaf node, a
> missing accuracy in the middle of the chain really derails things.
> Since my previous concern (modelling the real accuracy of the clocks) is
> not an issue here, I think assuming the absent accuracy is 0 is fine.
> Especially since all Boris is trying to do is avoid the RC clocks.

Agreed. If accuracy data must exist along the entire chain for the
calculation to be successful then the feature will be useless due to
lack of adoption of the accuracy data.

Regards,
Mike

> 
> thx,
> 
> Jason.
