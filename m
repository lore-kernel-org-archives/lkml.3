Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711Ab3J3Uup (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 16:50:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48014 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697Ab3J3Uun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 16:50:43 -0400
Date: Wed, 30 Oct 2013 13:50:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mark Salter <msalter@redhat.com>, linux-next@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>, ccross@android.com
Subject: Re: linux-next build failure
Message-Id: <20131030135042.9c40bca11370c2cfef29ff51@linux-foundation.org>
In-Reply-To: <20131031073700.f9642ce6c35674a45b3905bc@canb.auug.org.au>
References: <1383146865.11574.3.camel@deneb.redhat.com>
	<20131031073700.f9642ce6c35674a45b3905bc@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Oct 2013 07:37:00 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> [Jut add Andrew to the cc list]
> 
> On Wed, 30 Oct 2013 11:27:45 -0400 Mark Salter <msalter@redhat.com> wrote:
> >
> > This patch causes a build failure for no-MMU builds:
> > 
> >   commit 41df2957cb010edfa2f9d394d3617da6beeeb660
> >   Author: Colin Cross <ccross@android.com>
> >   Date:   Wed Oct 30 11:45:39 2013 +1100
> > 
> >       mm: add a field to store names for private anonymous memory
> >     
> > The problem is:
> > 
> >   kernel/built-in.o: In function `sys_prctl':
> >   (.text+0x19854): undefined reference to `madvise_set_anon_name'
> > 
> > madvise doesn't make sense without an MMU.
> > 
> > --Mark

OK, thanks.  I'll drop

mm-rearrange-madvise-code-to-allow-for-reuse.patch
mm-add-a-field-to-store-names-for-private-anonymous-memory.patch
mm-add-a-field-to-store-names-for-private-anonymous-memory-fix.patch
mm-add-a-field-to-store-names-for-private-anonymous-memory-fix-fix-2.patch

for now.  They have other question marks - let's revisit everything
after 3.13-rc1.

