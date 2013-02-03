Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab3BCTKn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 14:10:43 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53337 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417Ab3BCTKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 14:10:40 -0500
Date: Sun, 3 Feb 2013 20:10:35 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: mingo@redhat.com, peterz@infradead.org, paulus@samba.org,
        acme@ghostprotocols.net, penberg@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/7] liblockdep: wrap kernel/lockdep.c to allow usage
 from userspace
Message-ID: <20130203191035.GB23021@gmail.com>
References: <1359737231-26127-1-git-send-email-sasha.levin@oracle.com>
 <20130203110410.GA11739@gmail.com>
 <510E8E0E.9020103@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <510E8E0E.9020103@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sasha Levin <sasha.levin@oracle.com> wrote:

> On 02/03/2013 06:04 AM, Ingo Molnar wrote:
> > 
> > So I applied your patches and did:
> > 
> >   cd tools/lib/lockdep
> >   make
> > 
> > and got:
> > 
> > comet:~/tip/tools/lib/lockdep> make
> >   CC FPIC            common.o
> > In file included from ./uinclude/linux/lockdep.h:13:0,
> >                  from 
> > /fast/mingo/tip/tools/lib/lockdep/common.c:4:
> > ./../../../include/linux/lockdep.h:21:27: fatal error: linux/linkage.h: No such file or directory
> > compilation terminated.
> > make: *** [common.o] Error 1
> 
> That's odd, uinclude/linux/linkage.h is an empty file which is 
> needed there just so gcc won't complain (like it did in the 
> example above).

Ah, indeed - an empty file that Quilt mishandles, so the problem 
is on my side.

Thanks,

	Ingo
