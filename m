Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055AbaJGPOT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 11:14:19 -0400
Received: from mail.kernel.org ([198.145.19.201]:42793 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752956AbaJGPOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 11:14:18 -0400
Date: Tue, 7 Oct 2014 12:14:12 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] perf kvm stat record: print kvm specific --help output
Message-ID: <20141007151412.GL14113@kernel.org>
References: <1412611998-8690-1-git-send-email-yarygin@linux.vnet.ibm.com>
 <1412611998-8690-2-git-send-email-yarygin@linux.vnet.ibm.com>
 <54340276.9070708@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54340276.9070708@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Oct 07, 2014 at 09:10:46AM -0600, David Ahern escreveu:
> On 10/6/14, 10:13 AM, Alexander Yarygin wrote:
> 
> >+static void print_record_help(void)
> >+{
> >+	fprintf(stderr, "\n usage: perf kvm stat record [<options>]\n\n");
> >+
> >+	fprintf(stderr, "    -p, --pid <pid>      record events on existing process id\n");
> >+	fprintf(stderr, "    -t, --tid <tid>      record events on existing thread id\n");
> >+	fprintf(stderr, "    -r, --realtime <n>   collect data with this RT SCHED_FIFO priority\n");
> >+	fprintf(stderr, "        --no-buffering   collect data without buffering\n");
> >+	fprintf(stderr, "    -a, --all-cpus       system-wide collection from all CPUs\n");
> >+	fprintf(stderr, "    -C, --cpu <cpu>      list of cpus to monitor\n");
> >+	fprintf(stderr, "    -c, --count <n>      event period to sample\n");
> >+	fprintf(stderr, "    -o, --output <file>  output file name\n");
> >+	fprintf(stderr, "    -i, --no-inherit     child tasks do not inherit counters\n");
> >+	fprintf(stderr, "    -m, --mmap-pages <pages>\n");
> >+	fprintf(stderr, "                         number of mmap data pages\n");
> >+	fprintf(stderr, "    -v, --verbose        be more verbose (show counter open errors, etc)\n");
> >+	fprintf(stderr, "    -q, --quiet          don't print any message\n");
> >+	fprintf(stderr, "    -D, --delay <n>      ms to wait before starting measurement after program start\n");
> >+	fprintf(stderr, "    -u, --uid <user>     user to profile\n");
> >+	fprintf(stderr, "        --per-thread     use per-thread mmaps\n");
> >+
> >+	fprintf(stderr, "\nOtherwise, it is the alias of 'perf record:'\n");
> >+}
> 
> Those are all perf-record options, not perf-kvm-stat-record options. This
> usage should not repeat perf-record.

Right, and from a quick look, the way Namhyung is tackling this problem
is better.

- Arnaldo
