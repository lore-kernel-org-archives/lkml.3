Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759098Ab3LGU7T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 15:59:19 -0500
Received: from gate.crashing.org ([63.228.1.57]:56532 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755538Ab3LGU7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 15:59:17 -0500
Message-ID: <1386449914.21910.109.camel@pasglop>
Subject: Re: [PATCH] powerpc 8xx: Loading kernels over 8Mbytes without
 CONFIG_PIN_TLB
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: christophe leroy <christophe.leroy@c-s.fr>
Cc: Scott Wood <scottwood@freescale.com>, Paul Mackerras <paulus@samba.org>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Date: Sun, 08 Dec 2013 07:58:34 +1100
In-Reply-To: <52A2ECE4.3050407@c-s.fr>
References: <20131127110406.6DC8E1A504F@localhost.localdomain>
	 <1386356996.7375.120.camel@snotra.buserror.net> <52A2ECE4.3050407@c-s.fr>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-12-07 at 10:39 +0100, christophe leroy wrote:
> Function setup_initial_memory_limit() in mm/init_32.c defines the
> limits 
> based on the parameters given by the bootloader.
> As far as I know, the 8xx doesn't do speculative access just because
> an area is loaded in a TLB Entry.

Speculative accesses are ... speculative :-) The address used for such
an access can be anything really. So yes, architecturally, powerpc
processors can access *anything* speculatively just because there's a
valid non-garded translation.

Whether the 8xx does it at all, I don't know. 44x originally did but
that was so buggy that we had to force G on all mappings (until later
versions of the core just burned the feature out). Pretty much all other
powerpc's do it.

Cheers,
Ben.


