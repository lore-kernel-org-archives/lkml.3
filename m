Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932453Ab3LDNIq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 08:08:46 -0500
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:34410 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932270Ab3LDNIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 08:08:44 -0500
Date: Wed, 4 Dec 2013 15:08:39 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: Thierry Reding <thierry.reding@gmail.com>
cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Russell King <linux@arm.linux.org.uk>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Scott Wood <scottwood@freescale.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH v2] OF: base: match each node compatible against all
 given matches first
In-Reply-To: <20131204094010.GO19943@ulmo.nvidia.com>
Message-ID: <alpine.SOC.1.00.1312041506010.8902@math.ut.ee>
References: <1385663785-8643-1-git-send-email-sebastian.hesselbarth@gmail.com> <1386078720-8756-1-git-send-email-sebastian.hesselbarth@gmail.com> <alpine.SOC.1.00.1312032210480.25191@math.ut.ee> <529E614B.3070307@gmail.com>
 <20131204094010.GO19943@ulmo.nvidia.com>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I added Meelis on Cc because he found a regression with my original
> proposal (107a84e61cdd "of: match by compatible property first"). That
> got later reverted in commit bc51b0c22ceb (Revert "of: match by
> compatible property first"). Here's the commit message for reference:
> 
> commit bc51b0c22ceb
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Tue Jul 10 12:49:32 2012 -0700
> 
>     Revert "of: match by compatible property first"
> 
>     This reverts commit 107a84e61cdd3406c842a0e4be7efffd3a05dba6.
> 
>     Meelis Roos reports a regression since 3.5-rc5 that stops Sun Fire V100
>     and Sun Netra X1 sparc64 machines from booting, hanging after enabling
>     serial console.  He bisected it to commit 107a84e61cdd.
> 
>     Rob Herring explains:
>      "The problem is match combinations of compatible plus name and/or type
>       fail to match correctly.  I have a fix for this, but given how late it
>       is for 3.5 I think it is best to revert this for now.  There could be
>       other cases that rely on the current although wrong behavior.  I will
>       post an updated version for 3.6."
> 
>     Bisected-and-reported-by: Meelis Roos <mroos@linux.ee>
>     Requested-by: Rob Herring <rob.herring@calxeda.com>
>     Cc: Thierry Reding <thierry.reding@avionic-design.de>
>     Cc: Grant Likely <grant.likely@secretlab.ca>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> So if Meelis still has access to the Sun Fire V100 and Sun Netra X1
> machines that regressed last time around, it'd be great to get this
> patch tested on them to verify that it indeed fixes the problem and
> doesn't regress.

OK, I had forgotten about that.

Tested successfully on the same Sun Fire V100 and Sun Netra X1, on top 
of 3.13-rc2. The sunsu console is detected fine and I see no problem for 
now.

-- 
Meelis Roos (mroos@linux.ee)
