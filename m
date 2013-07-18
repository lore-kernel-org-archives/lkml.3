Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758780Ab3GRK4l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 06:56:41 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:38269 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757780Ab3GRK4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 06:56:39 -0400
Message-ID: <51E7C9E3.1070506@hitachi.com>
Date: Thu, 18 Jul 2013 19:56:35 +0900
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
Subject: Re: Re: [RFC PATCH 3/4] tracing: Kill tracing_open/release_generic_file
References: <20130716185726.GA21200@redhat.com> <1374004295.6458.59.camel@gandalf.local.home> <20130717191917.GA14137@redhat.com>
In-Reply-To: <20130717191917.GA14137@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/07/18 4:19), Oleg Nesterov wrote:
> On 07/16, Steven Rostedt wrote:
>>
>> On Tue, 2013-07-16 at 20:57 +0200, Oleg Nesterov wrote:
>>> trace_array_get() goes away. NOTE! this is actually wrong until we
>>> change instance_delete() path to nullify ->i_private.
>>
>> I think this needs to be done first.
> 
> Do you mean "change instance_delete() path to nullify ->i_private" ?
> 
> Yes. Well yes and no, afaics, but please ignore. Of course, I won't
> send the patches with the holes which I knew about.
> 
> Once again, this is just RFC to know your and Masami's opinion. If
> you think this can work, I'll try to resend this series with the
> additional bits to cover instance_delete() too. _Afaics_ this needs
> some temporary uglifications "in between".

I think your proposal goes a good direction, but it also requires
completeness, because, as I pointed, we have to take care of all
operations are correctly checked except for open/close.

So, I agree with Steven, I'd like to see a complete patchset.

Thank you,


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


