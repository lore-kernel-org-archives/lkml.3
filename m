Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415AbaFPKaS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 06:30:18 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:26407 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278AbaFPKaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 06:30:13 -0400
Date: Mon, 16 Jun 2014 13:29:27 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Martin Jambor <mjambor@suse.cz>, Petr Mladek <pmladek@suse.cz>,
        linux-kernel@vger.kernel.org, gcc@gcc.gnu.org,
        linux-sparse@vger.kernel.org
Subject: Re: [PATCH] tell gcc optimizer to never introduce new data races
Message-ID: <20140616102927.GA2994@mwanda>
References: <alpine.LNX.2.00.1406101517300.9378@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1406101517300.9378@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding "--param allow-store-data-races=0" to the GCC options for the
kernel breaks C=1 because Sparse isn't expecting a GCC option with that
format.

It thinks allow-store-data-races=0 is the name of the file we are trying
to test.  Try use Sparse on linux-next to see the problem.

$ make C=2 mm/slab_common.o
  CHK     include/config/kernel.release
  CHK     include/generated/uapi/linux/version.h
  CHK     include/generated/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CHECK   scripts/mod/empty.c
No such file: allow-store-data-races=0
make[2]: *** [scripts/mod/empty.o] Error 1
make[1]: *** [scripts/mod] Error 2
make: *** [scripts] Error 2
$

regards,
dan carpenter

