Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383AbaHTX2F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 19:28:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57194 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753072AbaHTX2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 19:28:03 -0400
Date: Thu, 21 Aug 2014 01:27:56 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Martin Jambor <mjambor@suse.cz>, Petr Mladek <pmladek@suse.cz>,
        linux-kernel@vger.kernel.org, gcc@gcc.gnu.org
Subject: Re: [PATCH] tell gcc optimizer to never introduce new data races
In-Reply-To: <alpine.LNX.2.00.1406101517300.9378@pobox.suse.cz>
Message-ID: <alpine.LRH.2.00.1408210127150.12153@twin.jikos.cz>
References: <alpine.LNX.2.00.1406101517300.9378@pobox.suse.cz>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2014, Jiri Kosina wrote:

> We have been chasing a memory corruption bug, which turned out to be 
> caused by very old gcc (4.3.4), which happily turned conditional load into 
> a non-conditional one, and that broke correctness (the condition was met 
> only if lock was held) and corrupted memory.
> 
> This particular problem with that particular code did not happen when 
> never gccs were used. I've brought this up with our gcc folks, as I wanted 
> to make sure that this can't really happen again, and it turns out it 
> actually can.

For the record (and for mailinglist archives to catch this information) -- 
the default has been changed for gcc 4.10 to a sane value (0).
 
I'd however suggest we keep changes made by commit 69102311a ("./Makefile:
tell gcc optimizer to never introduce new data races") for rather a long  
time.

-- 
Jiri Kosina
SUSE Labs

