Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751412Ab3GQCLI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 22:11:08 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:51300 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab3GQCLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 22:11:06 -0400
Message-ID: <51E5FD33.4040604@hitachi.com>
Date: Wed, 17 Jul 2013 11:10:59 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Andrew Morton <akpm@linux-foundation.org>, jovi.zhangwei@huawei.com,
        Jiri Olsa <jolsa@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH V2] tracing: Check f_dentry before accessing event_file/call
 in inode->i_private
References: <20130705003223.GA4981@redhat.com> <20130709075519.2583.96462.stgit@mhiramat-M0-7522> <20130715181659.GA18505@redhat.com>
In-Reply-To: <20130715181659.GA18505@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/07/16 3:16), Oleg Nesterov wrote:
> On 07/09, Masami Hiramatsu wrote:
>>
>> To avoid this, when opening events/*/*/enable, we have to ensure
>> the dentry of the file is not unlinked yet, under event_mutex
>> is locked.
> 
> Probably this can work, but I am starting to think that this ref
> count becomes toooooo complex....

Oleg, I agree that is a bit complex way to fix but it can fix.

However, I think we should fix bugs first, because there are bugs.
I don't like to leave a bug in the kernel as it is, while we re-
start discussing new approach...

> Could you please look at the draft patch I sent in another email?

I'm happy to see the series, and I guess it will take a long
discussion and review time again.

So, I'd like to suggest you getting these fixes into ftrace as
first-aid treatment, and discuss your new series.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


