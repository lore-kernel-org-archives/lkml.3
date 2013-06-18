Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933425Ab3FRQSv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 12:18:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8739 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933205Ab3FRQSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 12:18:48 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=wMhEMHMXtCwA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=YiCIw8J5n04A:10 a=vaJtXVxTAAAA:8 a=20KFwNOVAAAA:8 a=JfrnYn6hAAAA:8 a=PCxtn313arcaCoGtD5gA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=jEp0ucaQiEUA:10 a=3Rfx1nUSh_UA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1371572327.18733.37.camel@gandalf.local.home>
Subject: Re: [PATCHv2 2/2]misc: Use schedule_(raw_)spin_unlock and
 schedule_(raw_)spin_unlock_irq
From: Steven Rostedt <rostedt@goodmis.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Date: Tue, 18 Jun 2013 12:18:47 -0400
In-Reply-To: <670131371571433@web19e.yandex.ru>
References: <1451381371569817@web21d.yandex.ru>
	 <1371571012.18733.33.camel@gandalf.local.home>
	 <670131371571433@web19e.yandex.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-18 at 20:03 +0400, Kirill Tkhai wrote:
> Use helpers where possible (All directories except arch/.)

Also, this change log needs to be a bit better. Do not assume that
people have read the previous change. A year from now, when someone does
a git blame and sees this change, they will probably curse at this
explanation.

Add here the explanation that spin_unlock() calls preempt_enable() which
can schedule. But there are several locations that explicitly call
schedule after unlocking a spin lock. To prevent the double schedule,
use this schedule_spin_unlock() API.

-- Steve

> 
> Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
> CC: Steven Rostedt <rostedt@goodmis.org>
> CC: Ingo Molnar <mingo@redhat.com>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: LKML


