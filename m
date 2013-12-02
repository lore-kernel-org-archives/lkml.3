Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012Ab3LBQqN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 11:46:13 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:47626 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816Ab3LBQqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 11:46:09 -0500
Date: Mon, 2 Dec 2013 16:46:01 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Simon Kirby <sim@hostway.ca>, Ian Applegate <ia@cloudflare.com>,
        Christoph Lameter <cl@gentwo.org>, Pekka Enberg <penberg@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>
Subject: Re: Found it! (was Re: [3.10] Oopses in kmem_cache_allocate() via
 prepare_creds())
Message-ID: <20131202164601.GF10323@ZenIV.linux.org.uk>
References: <CA+55aFyez7uZ6LeXrBRCqJzgJ=w4Xv+CV6QSYp5NkOJ2R9Xang@mail.gmail.com>
 <20131202162755.GB27781@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131202162755.GB27781@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 02, 2013 at 05:27:55PM +0100, Ingo Molnar wrote:

> It's not like there should be many (any?) VFS operations where a pipe 
> is used via i_mutex and pipe->mutex in parallel, which would improve 
> scalability - so I don't see the scalability advantage. (But I might 
> be missing something)
> 
> Barring such kind of workload the extra mutex just adds extra 
> micro-costs because now two locks have to be taken on 
> creation/destruction, plus it adds extra complexity and races.
> 
> So unless I'm missing something obvious, another good fix would be to 
> just revert pipe->mutex and rely on i_mutex as before?

You are missing the extra shitloads of complexity in ->i_mutex ordering,
and ->i_mutex is already used for too many things...
