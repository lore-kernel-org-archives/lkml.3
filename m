Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933878AbaDISOh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 14:14:37 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:50544 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933143AbaDISOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 14:14:34 -0400
Date: Wed, 9 Apr 2014 13:14:28 -0500
From: rkuo <rkuo@codeaurora.org>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: "Theodore Ts'o" <tytso@mit.edu>, "Luck, Tony" <tony.luck@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>, tglx@linutronix.de,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Felipe Balbi <balbi@ti.com>,
        shawn.guo@linaro.org, grant.likely@linaro.org,
        Mikael Starvik <starvik@axis.com>, David Howells <dhowells@redhat.com>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 01/11] random: don't feed stack data into pool when
 interrupt regs NULL
Message-ID: <20140409181428.GA2935@codeaurora.org>
References: <1380572952-30729-1-git-send-email-andi@firstfloor.org>
 <1380572952-30729-2-git-send-email-andi@firstfloor.org>
 <3908561D78D1C84285E8C5FCA982C28F31D1F249@ORSMSX106.amr.corp.intel.com>
 <20131001124424.GA2097@thunk.org>
 <20140404165447.GA28040@breakpoint.cc>
 <20140407040137.GA29755@thunk.org>
 <20140407193057.GA16588@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140407193057.GA16588@breakpoint.cc>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 07, 2014 at 09:30:57PM +0200, Sebastian Andrzej Siewior wrote:
> Yes. Usually there is generic function doing something sane but not as
> good as it could do with arch specific code. Or the code is completly
> disabled unless the architecture wires it up. Dropping a new function and
> hoping everyone will wire it up in no time is, ehm, brave. Nobody implemented
> random_get_entropy(), everyone falls back to get_cycles. From a quick
> grep I can see that atleast Hexagon, Cris, Frv, m32r and m68k return 0. I 
> put some of the maintainers Cc, I am curious if they know about the side
> effects.

Thanks for the CC; I was not aware of the side effects.  Hexagon does have a
pcycles mechanism, so I will hook that up in our arch.



-- 

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
