Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510Ab3EINta (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 09:49:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53070 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755015Ab3EINt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 09:49:29 -0400
Message-ID: <518BA91E.3080406@zytor.com>
Date: Thu, 09 May 2013 06:48:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
CC: Francis Deslauriers <fdeslaur@gmail.com>, linux-mm@kvack.org,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        rostedt@goodmis.org, fweisbec@gmail.com, raphael.beamonte@gmail.com,
        mathieu.desnoyers@efficios.com, linux-kernel@vger.kernel.org
Subject: Re: [page fault tracepoint 1/2] Add page fault trace event definitions
References: <1368079520-11015-1-git-send-email-fdeslaur@gmail.com> <518B464E.6010208@huawei.com>
In-Reply-To: <518B464E.6010208@huawei.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2013 11:46 PM, zhangwei(Jovi) wrote:
> On 2013/5/9 14:05, Francis Deslauriers wrote:
>> Add page_fault_entry and page_fault_exit event definitions. It will
>> allow each architecture to instrument their page faults.
> 
> I'm wondering if this tracepoint could handle other page faults,
> like faults in kernel memory(vmalloc, kmmio, etc...)
> 
> And if we decide to support those faults, add a type annotate in TP_printk
> would be much helpful for user, to let user know what type of page faults happened.
> 

The plan for x86 was to switch the IDT so that any exception could get a
trace event without any overhead in normal operation.  This has been in
the process for quite some time but looks like it was getting very close.

	-hpa


