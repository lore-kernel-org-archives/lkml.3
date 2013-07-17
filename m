Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520Ab3GQCgh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 22:36:37 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:51442 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab3GQCgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 22:36:36 -0400
Message-ID: <51E6032B.7070907@hitachi.com>
Date: Wed, 17 Jul 2013 11:36:27 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] tracing: fix open/delete fixes
References: <20130716185658.GA21167@redhat.com>
In-Reply-To: <20130716185658.GA21167@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/07/17 3:56), Oleg Nesterov wrote:
> Hello.
> 
> Completely untested and _incomplete_. This ignores instance_delete()
> and ftrace_event_format_fops, at least.
> 
> But I am not going to even try to finish this series unless you tell
> me that you agree with this approach.
> 
> I have no idea what else could I miss. I probably understand no more
> than 1% of this code, I won't be surprized if this can't work.
> 
> To remind, we also need other changes we are discussing.

At a glance, you're trying to change which operation will be
failed. Currently, user can not remove an event while someone
opens files which related to the event. And this approach
changes that the someone can remove the event even if the
files are opened (and read/write operation will be failed).
Am I understand correctly?

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


