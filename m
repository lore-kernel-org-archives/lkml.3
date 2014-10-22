Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932650AbaJVJmI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 05:42:08 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:39844 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932123AbaJVJmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 05:42:06 -0400
Message-ID: <54477BE6.2060006@hitachi.com>
Date: Wed, 22 Oct 2014 18:41:58 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Hemant Kumar <hemant@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, hegdevasant@linux.vnet.ibm.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org,
        namhyung@kernel.org, aravinda@linux.vnet.ibm.com, penberg@iki.fi
Subject: Re: [PATCH v3 5/5] perf/sdt: Add support to perf record to trace
 SDT events
References: <20141010104402.15506.73285.stgit@hemant-fedora> <20141010105914.15506.84827.stgit@hemant-fedora> <54475292.20409@hitachi.com> <544768C6.6090105@linux.vnet.ibm.com>
In-Reply-To: <544768C6.6090105@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/10/22 17:20), Hemant Kumar wrote:
>>> From "file_sdt_ent" we will find out the file name.
>>> Convert this sdt note into a perf event and then write this into uprobe_events
>>> file to be able to record the event.
>>> Then, corresponding entries are added to uprobe_events file for
>>> the SDT events.
>>> After recording is done, these events are silently deleted from uprobe_events
>>> file. The uprobe_events file is present in debugfs/tracing directory.
>>>
>>> To support the addition and deletion of SDT events to/from uprobe_events
>>> file, a record_sdt struct is maintained which has the event data.
>> OK, I have some comments on this.
>>
>>> An example usage:
>>>
>>> # ./perf record -e %user_app:fun_start -aR /home/user_app
>> At first, I'd like to add SDT support for adding probes too, like below;
>>
>> ./perf probe -a '%user_app:fun_start $vars'
> 
> But I think, previously we discussed that we won't be having "perf 
> probe" for SDT events.
> We list them and probe/trace them using "perf record" directly.

Right, sorry for confusing you. I meant that I'd like to support SDT on both of
perf-record and perf-probe :)
And even if we'll hide sdt related events via perf, users can access it via ftrace.
So, I doubt that we can completely hide them, in that case, honesty is the best way;)

Thank you,


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


