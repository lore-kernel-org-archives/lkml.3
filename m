Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656AbaCaKZe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 06:25:34 -0400
Received: from www.linutronix.de ([62.245.132.108]:58853 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256AbaCaKZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 06:25:32 -0400
Message-ID: <53394296.5030906@linutronix.de>
Date: Mon, 31 Mar 2014 12:25:26 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.4.0
MIME-Version: 1.0
To: Yijing Wang <wangyijing@huawei.com>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>, Zhangwei <jovi.zhangwei@huawei.com>
Subject: Re: [BUGREPORT] Tasklet scheduled issue in Linux 3.4.x-rt
References: <53144A57.4040204@huawei.com> <20140328163753.GB14842@linutronix.de> <533669C7.0@huawei.com>
In-Reply-To: <533669C7.0@huawei.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2014 07:35 AM, Yijing Wang wrote:
> Hi Sebastian,

Hi Yijing,

>    Thanks for your reply and help to look at it, thanks!
> 
> I also check the tasklet state machine changes, and didn't find
> clue for this issue. So I Temporarily reverted Ingo's patch, without
> this patch, my test is ok.
> 
> Because this patch does not exist in the latest Linus kernel, so I
> have not reported this issue to kernel bugzilla.

This patch exists in all -RT releases up to 3.12. If there is an issue
with it, it should be solved.

If the sched bit set is and you can't get lock later then the tasklet
has be to active. Finally, not getting the lock in the tasklet code
itself means it is still occupied by the "add-to-the-list" part which
actually can't happen according to the code.
You said, that you have an eight-way. Is this also NUMA? If so, does
this problem happen if you disable NUMA (i.e. run only one NUMA node
and use only the memory that is directly attached to the node).

> Finally, I would like to thank you again.
> 
> Thanks!
> Yijing.

Sebastian
