Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936AbaCNUqn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 16:46:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45289 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707AbaCNUqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 16:46:42 -0400
Message-ID: <53236AA2.7030105@canonical.com>
Date: Fri, 14 Mar 2014 16:46:26 -0400
From: Joseph Salisbury <joseph.salisbury@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: penguin-kernel@I-love.SAKURA.ne.jp
CC: Oleg Nesterov <oleg@redhat.com>, rientjes@google.com,
        akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>, tj@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Kernel Team <kernel-team@lists.ubuntu.com>
Subject: [v3.13][v3.14][Regression] kthread: make kthread_create() killable
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tetsuo,

A kernel bug report was opened against Ubuntu[0].  We performed a kernel
bisect, and found that reverting the following commit resolved this bug:


commit 786235eeba0e1e85e5cbbb9f97d1087ad03dfa21
Author: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date:   Tue Nov 12 15:06:45 2013 -0800

    kthread: make kthread_create() killable

The regression was introduced as of v3.13-rc1.

The bug indicates an issue with the SAS controller during
initialization, which prevents the system from booting.  Additional
details are available in the bug report or on request.

I was hoping to get your feedback, since you are the patch author.  Do
you think gathering any additional data will help diagnose this issue,
or would it be best to submit a revert request?


Thanks,

Joe

[0] http://pad.lv/1276705
