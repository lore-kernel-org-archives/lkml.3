Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530AbaJWIV0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 04:21:26 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:48625 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356AbaJWIVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 04:21:24 -0400
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Hemant Kumar <hemant@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, oleg@redhat.com, hegdevasant@linux.vnet.ibm.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org,
        aravinda@linux.vnet.ibm.com, penberg@iki.fi
Subject: Re: [PATCH v3 5/5] perf/sdt: Add support to perf record to trace SDT events
References: <20141010104402.15506.73285.stgit@hemant-fedora>
	<20141010105914.15506.84827.stgit@hemant-fedora>
	<54475292.20409@hitachi.com> <544768C6.6090105@linux.vnet.ibm.com>
	<54477BE6.2060006@hitachi.com>
	<20141023055422.GA27939@linux.vnet.ibm.com>
	<5448A141.7050601@hitachi.com>
Date: Thu, 23 Oct 2014 17:21:21 +0900
In-Reply-To: <5448A141.7050601@hitachi.com> (Masami Hiramatsu's message of
	"Thu, 23 Oct 2014 15:33:37 +0900")
Message-ID: <87oat3dwn2.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masami,

On Thu, 23 Oct 2014 15:33:37 +0900, Masami Hiramatsu wrote:
> (2014/10/23 14:54), Srikar Dronamraju wrote:
>> I am somehow not able to figure out how perf probe comes into the
>> current workflow.
>> 
>> I think the current design was
>> 1. perf sdt-cache --add <file> (only once per file)
>> 2. perf record -e <sdt-event>
>> 
>> So what is the additional thing that perf probe does or Is it going to
>> replace any of the above steps?
>
> 3. perf probe -a <sdt-event>
>
> And this will be done subsequently in this series (without user interface part).
> However, current implementation of 2. will do the following steps
>
> s1. get sdt event data from sdt-cache
> s2. set up sdt events with suppressing messages
> s3. do recording events
> (s4. and hiding existing sdt events from perf-probe --list)
> s5. remove sdt events
>
> So, what I proposed were ;
> - to implement s2., we can introduce --quiet(-q) option and use it
>   instead of ->sdt flag checking
> - removing s4. and s5.
> - and add verification of existing sdt events at s2. if needed.

I'm okay with removing the s4 but not sure about the s5.  In that case,
we might have many dynamic events in a system without noticing to users.

Thanks,
Namhyung


>
> This will simplify your patch and removing complex part of sdt-specific code.
> What would you think about this?
>
> Thank you,
