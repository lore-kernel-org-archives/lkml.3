Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957Ab3EaTAm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 15:00:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51617 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054Ab3EaTAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 15:00:34 -0400
Message-ID: <51A8F32D.90401@canonical.com>
Date: Fri, 31 May 2013 14:59:57 -0400
From: Joseph Salisbury <joseph.salisbury@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: matthew.garrett@nebula.com
CC: matt.fleming@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-efi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [v3.8] [v3.9] [v3.10] [Regression]  efi: be more paranoid about available
 space when creating variables
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew,

A bug was opened that reports a regression that prevents a system from
booting[0].  After a kernel bisect, it was found that reverting the
following commit resolved this bug:

commit 68d929862e29a8b52a7f2f2f86a0600423b093cd
Author: Matthew Garrett <matthew.garrett@nebula.com>
Date:   Sat Mar 2 19:40:17 2013 -0500

    efi: be more paranoid about available space when creating variables


The regression was introduced as of v3.9-rc2, but it also made it's way
into the stable trees(Commit 9f677cf in v3.8).

I see the following commit was introduced to address this issue:

commit 31ff2f20d9003e74991d135f56e503fe776c127c
Author: Matthew Garrett <matthew.garrett@nebula.com>
Date:   Mon Apr 15 13:09:47 2013 -0700

    efi: Distinguish between "remaining space" and actually used space

However, the issue still in 3.9.4, 3.10-rc3 and v3.8.13 after
backporting 31ff2f2.

I see that you are the author of this patch, so I wanted to run this by
you and see if reverting commit 68d9298 is an option.  There are several
folks reporting this, so it should be easy to collect any additional
data/information or perform testing, if needed.


Thanks,

Joe

[0] http://pad.lv/1173423
