Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbaJCOZ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 10:25:28 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:49906 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbaJCOZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 10:25:25 -0400
From: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] perf tools: Add option to copy events when queueing
References: <1412267936-19827-1-git-send-email-yarygin@linux.vnet.ibm.com>
	<1412267936-19827-2-git-send-email-yarygin@linux.vnet.ibm.com>
	<20141003043421.GA24217@gmail.com>
	<20141003065047.GN9764@krava.brq.redhat.com>
	<20141003084754.GA29966@gmail.com>
Date: Fri, 03 Oct 2014 18:25:15 +0400
In-Reply-To: <20141003084754.GA29966@gmail.com> (Ingo Molnar's message of
	"Fri, 3 Oct 2014 10:47:54 +0200")
Message-ID: <87iok1cjsk.fsf@linux.vnet.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14100314-0342-0000-0000-00000144DD08
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@kernel.org> writes:

> * Jiri Olsa <jolsa@redhat.com> wrote:
>
>> On Fri, Oct 03, 2014 at 06:34:21AM +0200, Ingo Molnar wrote:
>> > 
>> > * Alexander Yarygin <yarygin@linux.vnet.ibm.com> wrote:
>> > 
[..]
>> > 
>> > What's the performance effect of this - i.e. by how much does CPU 
>> > use increase due to copying the events?
>> > 
>> > Wouldn't it be faster to fix this problem by updating the mmap 
>> > tail pointer only once the event has truly been consumed?
>> 
>> Alexander mentioned he'd loose data, because of userspace 
>> processing being to slow:
>>
>> http://marc.info/?l=linux-kernel&m=141111652424818&w=2
>
> So copying helps by allocating an essentially larger buffer, to 
> hold all unprocessed events that user-space is too slow to 
> process?
>
> I guess it's a valid usecase.
>
> Thanks,
>
> 	Ingo

Right. Also, it looks like the overhead here isn't a big deal:
time needed for actual processing an event is significantly bigger
and the additional memdup() doesn't change that much.

