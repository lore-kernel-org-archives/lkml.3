Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758031Ab3BGKyX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 05:54:23 -0500
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:52974 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757265Ab3BGKyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 05:54:22 -0500
Date: Thu, 7 Feb 2013 11:54:15 +0100
From: Florian Westphal <fw@strlen.de>
To: Feng Hong <hongfeng@marvell.com>
Cc: ebiederm@xmission.com, Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org, kys@microsoft.com,
        haiyangz@microsoft.com
Subject: Regression, bisected: hyperv shutdown panics guest
Message-ID: <20130207105415.GD13962@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With 3.7, hyperv guest shutdown no longer works.
Instead, guest kernel throws a bunch of "BUG: scheduling-while-atomic"
errors and then dies.

reverting

commit 6c0c0d4d1080840eabb3d055d2fd81911111c5fd
Author: hongfeng <hongfeng@marvell.com>
Date:   Thu Oct 4 17:12:25 2012 -0700
poweroff: fix bug in orderly_poweroff()

fixes this problem.

Greping for users of orderly_poweroff() shows that hyperv isn't
the only caller that invokes the function from irq context.

In fact, kdoc for orderly_poweroff says:

* This may be called from any context to trigger a system shutdown.
* If the orderly shutdown fails, it will force an immediate shutdown.

Any suggestions on how to properly fix this?

Thanks,
Florian
