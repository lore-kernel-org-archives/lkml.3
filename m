Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab3KZGdQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 01:33:16 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:37527 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795Ab3KZGdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 01:33:12 -0500
Message-ID: <5294409F.70508@hitachi.com>
Date: Tue, 26 Nov 2013 15:33:03 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Jovi Zhangwei <jovi.zhangwei@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] 3.13-rc1 kernel crash when enable all tracepoints
References: <CAGdX0WFeEuy+DtpsJzyzn0343qEEjLX97+o1VREFkUEhndC+5Q@mail.gmail.com>
In-Reply-To: <CAGdX0WFeEuy+DtpsJzyzn0343qEEjLX97+o1VREFkUEhndC+5Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/11/26 13:38), Jovi Zhangwei wrote:
> Hi,
> 
> I'm not sure this issue already be fixed or not, it can be reproduced
> permanently.
> 
> (I didn't use git-bisect yet, you guys might can understand it quickly)
> 
> #echo 1 > /sys/kernel/debug/tracing/events/enable

Thanks for reporting. I could reproduce it.

To narrow this down, I tried to run the below command

[tracing]# for i in events/*/*/enable ; do echo $i; echo 1 > $i; done

And it ran through the end without any problem.
Hm, next I checked the difference of available_events and set_event.

[tracing]# diff available_events set_event
283d282
< ftrace:function

So, I guess it was caused by enabling ftrace:function, and
it is unable to do that via set_event, nor events/ftrace/enable
I'm not sure how, but it seems that ftrace:function can be
enabled by the events/enable.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


