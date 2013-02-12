Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab3BLHHD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 02:07:03 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:61422 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781Ab3BLHHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 02:07:01 -0500
Message-ID: <1360652809.4657.87.camel@marge.simpson.net>
Subject: Re: [PATCH] sched/rt: Unthrottle the highest RT task of the rq if
 there are no another available tasks to be picked
From: Mike Galbraith <bitbucket@online.de>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Date: Tue, 12 Feb 2013 08:06:49 +0100
In-Reply-To: <2260671360618316@web22h.yandex.ru>
References: <2260671360618316@web22h.yandex.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:YbLixWac1BelonjMKdBLEhDO+LYmOTCu/ZhAdfH+NVS
 1rmQqGcrVm2J9YYDoXByine56MBwd+oKpxSNDRejGisJAGtgdg
 hzx/jWFQ/gaI/IODr2Trp+Z8lT8e22yJTiNy9ldM/H25E+S3mO
 MgYtpztfRPmseeIMHYGDtK/UNQR7ysH7RUNAYc8cFOLBI4n2fa
 cafTqneXOFlE34TPL896uUIfquRZpAGY71k8nrNWVCIDUeoSNO
 FFt7/D0StbYytkhIp0YXmTapWJdsTNejG4Hrsg7vxL5aptyjF0
 KiIn3DX0zJYEFq634+zKqBgSg23fnnjTeC3qZ9ZPnOaDvSKFQn
 +WAfKTanWmgMg48GBgsvOzSK0GEb7RWRPUYby8GlC5dZt09uZa
 uQFj37GssTkcA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-12 at 01:31 +0400, Kirill Tkhai wrote: 
> It's possible a situation when rq->rt is throttled or
> it has no child entities and there are RT tasks ready
> for execution in the rq which are the only tasks
> of TASK_RUNNING state. In this case pick_next_task
> takes idle tasks and idle wastes cpu time.

That's not a waste of CPU time, that's utilization enforcement the thing
it is designed to do.  I'd rather see borrowing go away, bodyguard being
either a ruthless thug who may save your bacon, or unemployed.  AFAIKT,
the throttle is useless in any other role, just having it standing
around glaring across the room occasionally can turn sensitive realtime
into a quaking heap of jello.

-Mike

