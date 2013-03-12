Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875Ab3CLDZ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 23:25:28 -0400
Received: from gate.crashing.org ([63.228.1.57]:35418 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754246Ab3CLDZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 23:25:27 -0400
Message-ID: <1363058712.4534.12.camel@pasglop>
Subject: Regression with orderly_poweroff()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        hongfeng <hongfeng@marvell.com>, david@gibson.dropbear.id.au
Date: Tue, 12 Mar 2013 14:25:12 +1100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

A couple of weeks ago, David sent an email that went unanswered about a
regression concerning orderly_poweroff(). I think the original patch
causing it should be reverted, here's the actual email with the
explanation:

<<<
Subject: orderly_poweroff() is no longer safe in atomic context

Commit 6c0c0d4d1080840eabb3d055d2fd81911111c5fd "poweroff: fix bug in
orderly_poweroff()" apparently fixes one bug in orderly_poweroff(),
but introduces another.  The comments on orderly_poweroff() claim it
can be called from any context - and indeed we call it from interrupt
context in arch/powerpc/platforms/pseries/ras.c for example.  But
since that commit this is no longer safe, since
call_usermodehelper_fns() is not safe in interrupt context without the
UMH_NO_WAIT option.

I'm having trouble understanding the commit message to see what the
original bug being fixed was.  Specifically I can't make sense of:

  |  The bug here is, step 1 is always successful with param
  |  UMH_NO_WAIT, which obey the design goal of orderly_poweroff.

And without understanding the original bug, I'm not sure what the
correct fix is.
>>>

Cheers,
Ben.


