Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422651AbaDQLqQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 07:46:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10628 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161087AbaDQLqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 07:46:14 -0400
Date: Thu, 17 Apr 2014 13:45:59 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        KVM <kvm@vger.kernel.org>, linux-s390 <linux-s390@vger.kernel.org>,
        Cornelia Huck <cornelia.huck@de.ibm.com>, linux-kernel@vger.kernel.org,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Subject: Re: [PATCH] perf/tool: Fix usage of trace events with '-' in trace
 system name.
Message-ID: <20140417114559.GB7422@krava.brq.redhat.com>
References: <1395694140-43447-1-git-send-email-borntraeger@de.ibm.com>
 <53315741.9010508@redhat.com>
 <20140417113221.GA7422@krava.brq.redhat.com>
 <534FBE04.9000501@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534FBE04.9000501@de.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 01:41:56PM +0200, Christian Borntraeger wrote:
> On 17/04/14 13:32, Jiri Olsa wrote:
> > On Tue, Mar 25, 2014 at 11:15:29AM +0100, Paolo Bonzini wrote:
> >> Il 24/03/2014 21:49, Christian Borntraeger ha scritto:
> >>> event_legacy_tracepoint:
> >>> +PE_NAME '-' PE_NAME ':' PE_NAME
> >>> +{
> >>> +	struct parse_events_evlist *data = _data;
> >>> +	struct list_head *list;
> >>> +	char sys_name[strlen($1) + strlen($3) + 2];
> >>> +	sprintf(&sys_name, "%s-%s", $1, $3);
> >>> +
> >>> +	ALLOC_LIST(list);
> >>> +	ABORT_ON(parse_events_add_tracepoint(list, &data->idx, &sys_name, $5));
> >>> +	$$ = list;
> >>> +}
> >>
> >> Why isn't '-' part of PE_NAME?
> > 
> > hi Paolo ;-)
> > 
> > because it screws cache events parsing.. we need some code factoring
> > in this part
> > 
> > Acked-by: Jiri Olsa <jolsa@redhat.com>
> 
> Jiri,
> 
> can you handle this patch + "perf-kvm: fix of 'Min time' counting in report command" in your tree?

yep, I queued both of them

jirka

> 
> > 
> > it'd be nice to add test to tests/parse-events.c, probably s390 specific,
> > because the parsing code touches the tracepoint format file
> 
> Alexander,
> 
> can you have a look to provide a simple test for perf that checks that trace events like kvm-s390 are handled properly?
> 
> Thanks
> 
> Christian
> 
