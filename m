Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579AbaJHQqK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 12:46:10 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:38118 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbaJHQqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 12:46:08 -0400
Date: Wed, 8 Oct 2014 18:45:57 +0200
From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: bisected: futex regression >= 3.14 - was - Slowdown due to
 threads bouncing between HT cores
Message-ID: <20141008164557.GB38790@sesse.net>
References: <20141003194428.GA27084@sesse.net>
 <1412782664.5179.75.camel@marge.simpson.net>
 <alpine.DEB.2.11.1410081756250.4292@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.DEB.2.11.1410081756250.4292@nanos>
X-Operating-System: Linux 3.16.3 on a x86_64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 06:14:18PM +0200, Thomas Gleixner wrote:
> It looks far more like an issue with the stocking fish code, but hell
> with futexes one can never be sure.

OK, maybe we should move to a more recent Stockfish version first of all;
the specific benchmark was about that specific binary, but for tracking down
futex issues we can see if more recent code fixes it (the SMP in this thing
keeps getting developed).

I'm moving to 2ac206e847a04a7de07690dd575c6949e5625115 (current head) of
https://github.com/mcostalba/Stockfish.git, and building with
“make -j ARCH=x86-64-bmi2”.

I still don't see any hangs, but I do see the same behavior of moving around
between CPUs as the older version exhibited. In a test run (using the given
test script, just with 28 replaced by 20), I get 18273 kN/sec with default,
and 21875 kN/sec when using taskset.

/* Steinar */
-- 
Homepage: http://www.sesse.net/
