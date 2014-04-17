Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225AbaDQLmH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 07:42:07 -0400
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:53245 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbaDQLmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 07:42:03 -0400
Message-ID: <534FBE04.9000501@de.ibm.com>
Date: Thu, 17 Apr 2014 13:41:56 +0200
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        KVM <kvm@vger.kernel.org>, linux-s390 <linux-s390@vger.kernel.org>,
        Cornelia Huck <cornelia.huck@de.ibm.com>, linux-kernel@vger.kernel.org,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Subject: Re: [PATCH] perf/tool: Fix usage of trace events with '-' in trace
 system name.
References: <1395694140-43447-1-git-send-email-borntraeger@de.ibm.com> <53315741.9010508@redhat.com> <20140417113221.GA7422@krava.brq.redhat.com>
In-Reply-To: <20140417113221.GA7422@krava.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14041711-6892-0000-0000-0000087F5A93
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/04/14 13:32, Jiri Olsa wrote:
> On Tue, Mar 25, 2014 at 11:15:29AM +0100, Paolo Bonzini wrote:
>> Il 24/03/2014 21:49, Christian Borntraeger ha scritto:
>>> event_legacy_tracepoint:
>>> +PE_NAME '-' PE_NAME ':' PE_NAME
>>> +{
>>> +	struct parse_events_evlist *data = _data;
>>> +	struct list_head *list;
>>> +	char sys_name[strlen($1) + strlen($3) + 2];
>>> +	sprintf(&sys_name, "%s-%s", $1, $3);
>>> +
>>> +	ALLOC_LIST(list);
>>> +	ABORT_ON(parse_events_add_tracepoint(list, &data->idx, &sys_name, $5));
>>> +	$$ = list;
>>> +}
>>
>> Why isn't '-' part of PE_NAME?
> 
> hi Paolo ;-)
> 
> because it screws cache events parsing.. we need some code factoring
> in this part
> 
> Acked-by: Jiri Olsa <jolsa@redhat.com>

Jiri,

can you handle this patch + "perf-kvm: fix of 'Min time' counting in report command" in your tree?

> 
> it'd be nice to add test to tests/parse-events.c, probably s390 specific,
> because the parsing code touches the tracepoint format file

Alexander,

can you have a look to provide a simple test for perf that checks that trace events like kvm-s390 are handled properly?

Thanks

Christian

