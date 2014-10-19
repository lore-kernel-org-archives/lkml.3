Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908AbaJSMjU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 08:39:20 -0400
Received: from www17.your-server.de ([213.133.104.17]:33693 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbaJSMjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 08:39:19 -0400
Message-ID: <1413722356.2991.8.camel@localhost.localdomain>
Subject: [UM] Long loop in __getnsdayoftime() after resume from ram
From: Thomas Meyer <thomas@m3y3r.de>
To: user-mode-linux-devel <user-mode-linux-devel@lists.sourceforge.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 19 Oct 2014 14:39:16 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

in UML kernel I get a long cpu using loop in __getnstimeofday()
(kernel/time/timekeeping.c:315) in the call of timespec_add_ns(),
when I left the host kernel suspended to ram for a few hours and resume
again.
this is because it seems like the tk->xtime_sec wasn't updated yet, but
the nsecs were. nsecs can be as high as 8111000111000111000l

the function timespec_add_ns() (include/linux/time.h:266) will call
__iter_div_u64_rem() which has an optimized loop for the case
that the dividend is not much bigger as the divisior.
but this isn't the case for resume from ram on the host kernel.

any ideas how to fix this? is it possible to intercept the resume from
ram and update the timekeeper->xtime_sec somehow?
or can the um arch somehow overwrite timespec_add_ns() to always use
div_u64_rem() instead?

with kind regards

PS: repost on these lists, because nobody did respond to my original
email.

