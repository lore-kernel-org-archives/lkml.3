Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbaHYEQW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 00:16:22 -0400
Received: from ozlabs.org ([103.22.144.67]:57998 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780AbaHYEQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 00:16:21 -0400
Message-ID: <1408940178.7941.3.camel@concordia>
Subject: Re: [PATCH] powerpc/pseries: Drop unnecessary continue
From: Michael Ellerman <mpe@ellerman.id.au>
To: Robert Jennings <rcj4747@gmail.com>
Cc: Himangi Saraogi <himangi774@gmail.com>,
        benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>,
        Brian King <brking@linux.vnet.ibm.com>
Date: Mon, 25 Aug 2014 14:16:18 +1000
In-Reply-To: <53F61586.3000107@gmail.com>
References: <20140813091847.GA3078@himangi-Dell>
	 <1408596086.9307.3.camel@concordia> <53F61586.3000107@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-08-21 at 10:51 -0500, Robert Jennings wrote:
> On 08/20/2014 11:41 PM, Michael Ellerman wrote:
> > On Wed, 2014-08-13 at 14:48 +0530, Himangi Saraogi wrote:
> >> Continue is not needed at the bottom of a loop.
> > 
> > True.
> > 
> > I wonder though, is the code trying to continue to the outer loop?
> > I stared at it for a minute but it wasn't obvious.
> > 
> > I wonder if Robert still remembers?
> 
> I don't recall what the intent was here.  Can't believe that it's been
> almost 5 years since I wrote this.  I wish I had left a few more
> comments in the code for me to go on.
> 
> Obviously the continue should be removed since it's not doing
> anything.  I don't believe that we'd want a continue statement in
> there to get outer loop.  That would change the current cmm_page_array
> pointer (pa_curr) to the next in the list after it may have just been
> reassigned to pa_last->next.
> 
> It may be the case that an earlier version of the code had statements
> in the inner loop after that continue that I wanted to skip, or I just
> did something silly.

OK, thanks for looking at it. I came to a similar conclusion, but good to have
your review as well.

The CMM regression test suite will catch us if we get it wrong anyway.

cheers


