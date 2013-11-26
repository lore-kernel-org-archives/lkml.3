Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440Ab3KZH1I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 02:27:08 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:49862 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085Ab3KZH1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 02:27:04 -0500
Message-ID: <52944D3E.4000700@hitachi.com>
Date: Tue, 26 Nov 2013 16:26:54 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Jovi Zhangwei <jovi.zhangwei@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: (ltc-kernel 7837) Re: [BUG] 3.13-rc1 kernel crash when enable
 all tracepoints
References: <CAGdX0WFeEuy+DtpsJzyzn0343qEEjLX97+o1VREFkUEhndC+5Q@mail.gmail.com> <5294409F.70508@hitachi.com>
In-Reply-To: <5294409F.70508@hitachi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/11/26 15:33), Masami Hiramatsu wrote:
> (2013/11/26 13:38), Jovi Zhangwei wrote:
>> Hi,
>>
>> I'm not sure this issue already be fixed or not, it can be reproduced
>> permanently.
>>
>> (I didn't use git-bisect yet, you guys might can understand it quickly)
>>
>> #echo 1 > /sys/kernel/debug/tracing/events/enable
> 
> Thanks for reporting. I could reproduce it.
> 
> To narrow this down, I tried to run the below command
> 
> [tracing]# for i in events/*/*/enable ; do echo $i; echo 1 > $i; done
> 
> And it ran through the end without any problem.
> Hm, next I checked the difference of available_events and set_event.
> 
> [tracing]# diff available_events set_event
> 283d282
> < ftrace:function
> 
> So, I guess it was caused by enabling ftrace:function, and
> it is unable to do that via set_event, nor events/ftrace/enable
> I'm not sure how, but it seems that ftrace:function can be
> enabled by the events/enable.

Oops, No, forget it. When I added a printk in
ftrace_set_clr_event_nolock(), it didn't happen and ftrace/function
is not enabled.

I'm trying to reproduce it on the latest tip kernel again on KVM,
but not yet reproduced.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


