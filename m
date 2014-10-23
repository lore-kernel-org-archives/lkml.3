Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860AbaJWFy3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 01:54:29 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:47780 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbaJWFy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 01:54:28 -0400
Date: Thu, 23 Oct 2014 11:24:22 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Hemant Kumar <hemant@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, oleg@redhat.com, hegdevasant@linux.vnet.ibm.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org,
        namhyung@kernel.org, aravinda@linux.vnet.ibm.com, penberg@iki.fi
Subject: Re: [PATCH v3 5/5] perf/sdt: Add support to perf record to trace SDT
 events
Message-ID: <20141023055422.GA27939@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20141010104402.15506.73285.stgit@hemant-fedora>
 <20141010105914.15506.84827.stgit@hemant-fedora>
 <54475292.20409@hitachi.com>
 <544768C6.6090105@linux.vnet.ibm.com>
 <54477BE6.2060006@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <54477BE6.2060006@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102305-0013-0000-0000-000001D8A330
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> [2014-10-22 18:41:58]:

> (2014/10/22 17:20), Hemant Kumar wrote:
> >>> From "file_sdt_ent" we will find out the file name.
> >>> Convert this sdt note into a perf event and then write this into uprobe_events
> >>> file to be able to record the event.
> >>> Then, corresponding entries are added to uprobe_events file for
> >>> the SDT events.
> >>> After recording is done, these events are silently deleted from uprobe_events
> >>> file. The uprobe_events file is present in debugfs/tracing directory.
> >>>
> >>> To support the addition and deletion of SDT events to/from uprobe_events
> >>> file, a record_sdt struct is maintained which has the event data.
> >> OK, I have some comments on this.
> >>
> >>> An example usage:
> >>>
> >>> # ./perf record -e %user_app:fun_start -aR /home/user_app
> >> At first, I'd like to add SDT support for adding probes too, like below;
> >>
> >> ./perf probe -a '%user_app:fun_start $vars'
> >
> > But I think, previously we discussed that we won't be having "perf
> > probe" for SDT events.
> > We list them and probe/trace them using "perf record" directly.
>
> Right, sorry for confusing you. I meant that I'd like to support SDT on both of
> perf-record and perf-probe :)
> And even if we'll hide sdt related events via perf, users can access it via ftrace.
> So, I doubt that we can completely hide them, in that case, honesty is the best way;)
>

I am somehow not able to figure out how perf probe comes into the
current workflow.

I think the current design was
1. perf sdt-cache --add <file> (only once per file)
2. perf record -e <sdt-event>

So what is the additional thing that perf probe does or Is it going to
replace any of the above steps?

--
Thanks and Regards
Srikar Dronamraju

