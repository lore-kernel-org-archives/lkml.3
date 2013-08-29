Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723Ab3H2GhI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 02:37:08 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:52130 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755325Ab3H2GhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 02:37:06 -0400
Message-ID: <1377758224.1928.91.camel@joe-AO722>
Subject: Re: [PATCH] ARC: Fix __udelay parentheses
From: Joe Perches <joe@perches.com>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: Mischa Jonker <Mischa.Jonker@synopsys.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Joern Rennecke <joern.rennecke@embecosm.com>
Date: Wed, 28 Aug 2013 23:37:04 -0700
In-Reply-To: <C2D7FE5348E1B147BCA15975FBA23075140F41@IN01WEMBXA.internal.synopsys.com>
References: <1377714588-2144-1-git-send-email-mjonker@synopsys.com>
	 <C2D7FE5348E1B147BCA15975FBA23075140F26@IN01WEMBXA.internal.synopsys.com>
	 <1377756078.1928.89.camel@joe-AO722>
	 <C2D7FE5348E1B147BCA15975FBA23075140F41@IN01WEMBXA.internal.synopsys.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-29 at 06:24 +0000, Vineet Gupta wrote:
> On 08/29/2013 11:31 AM, Joe Perches wrote:
> > I think the whole thing is odd and it should simply be
> >
> >	loops = loops_per_jiffy * usecs_to_jiffies(usecs)
[]
> On the topic of multiply vs. divide (which probably is not relevant to topic at
> hand though), since ARCompact doesn't have native divide, we end up emulating it
> using libgcc routines. That makes it slightly non-deterministic (not a big deal)
> and also adds to boot time (which those delays sprinkled all over the place in
> crazy device probes and such). Seriously we got hammered by a customer for that once.

That argues more for reducing the uses of hard delays
than making the hard delay count calculation simpler.


