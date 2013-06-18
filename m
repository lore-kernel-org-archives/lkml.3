Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217Ab3FRDlp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 23:41:45 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:54158 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973Ab3FRDlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 23:41:44 -0400
Message-ID: <51BFD6EF.1060805@hitachi.com>
Date: Tue, 18 Jun 2013 12:41:35 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: Re: [PATCH 2/3] tracing/kprobes: Kill probe_enable_lock
References: <20130616172149.GA8540@redhat.com> <51BE97C0.1070203@hitachi.com> <20130617151841.GA32267@redhat.com>
In-Reply-To: <20130617151841.GA32267@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/06/18 0:18), Oleg Nesterov wrote:
>> because
>> those calls are the reason why I have introduced this lock.
> 
> Please do not hesitate to nack this patch if you think that we should
> keep probe_enable_lock for safety even if it is not currently needed.
> In this case I'd suggest to move lock/unlock into kprobe_register()
> but this is minor.

Oh, I agree with removing probe_enable_lock itself :)
I just concerned only about the exceptional case of __init test
function, which can mislead someone to use enable/disable_trace_probe
at other racy point.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


