Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824AbaCaL4d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 07:56:33 -0400
Received: from gate.crashing.org ([63.228.1.57]:38650 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749AbaCaL4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 07:56:32 -0400
Message-ID: <1396266973.11529.77.camel@pasglop>
Subject: Re: [PATCH] powerpc/le: enable RTAS events support
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Stewart Smith <stewart@linux.vnet.ibm.com>
Cc: Greg Kurz <gkurz@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        paulus@samba.org, anton@samba.org, nfont@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org
Date: Mon, 31 Mar 2014 22:56:13 +1100
In-Reply-To: <87vbuv9vaz.fsf@river.i-did-not-set--mail-host-address--so-tickle-me>
References: <20140328073344.26823.32931.stgit@bahia.local>
	 <87vbuv9vaz.fsf@river.i-did-not-set--mail-host-address--so-tickle-me>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.11.90 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-31 at 09:27 +1100, Stewart Smith wrote:
> Greg Kurz <gkurz@linux.vnet.ibm.com> writes:
> >  struct rtas_error_log {
> > +#ifdef __BIG_ENDIAN__
> > +	/* Byte 0 */
> >  	unsigned long version:8;		/* Architectural version */
> > +	/* Byte 1 */
> 
> I think it would be great if we got rid of the usage of bitfields. As
> soon as the mood of the compiler changes, this code is going to break.

 ... as would a whole pile of kernel code including filesystems :)

Now, don't get me wrong, I hate bitfields as much as you do for the same
reasons. However (unfortunately ?) we've somewhat painted ourselves into
a corner here in kernel-land and I suspect gcc would have a very hard
time changing the format considering how many people did just the same
we did.

Now if we were a userspace program, I would still insist on fixing it on
the ground on not depending on gcc but this is the kernel ... we have
more gcc'isms than spots on the face of a 14 yrs old..

Cheers,
Ben.


