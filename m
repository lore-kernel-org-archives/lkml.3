Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033AbaKLOhj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 09:37:39 -0500
Received: from mga11.intel.com ([192.55.52.93]:16442 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752946AbaKLOhh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 09:37:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="415420760"
From: "Liang, Kan" <kan.liang@intel.com>
To: Jiri Olsa <jolsa@redhat.com>
CC: "acme@kernel.org" <acme@kernel.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "eranian@google.com" <eranian@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: RE: [PATCH 2/2] perf tools: Construct LBR call chain
Thread-Topic: [PATCH 2/2] perf tools: Construct LBR call chain
Thread-Index: AQHP+dQE2S0iXFhhE0OnjR0eOmOh6JxcNBgAgADU+tA=
Date: Wed, 12 Nov 2014 14:37:13 +0000
Message-ID: <37D7C6CF3E00A74B8858931C1DB2F07701661906@SHSMSX103.ccr.corp.intel.com>
References: <1415285886-16949-1-git-send-email-kan.liang@intel.com>
 <1415285886-16949-3-git-send-email-kan.liang@intel.com>
 <20141112085914.GC25338@krava>
In-Reply-To: <20141112085914.GC25338@krava>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> > +
> > +	printf("... chain: nr:%" PRIu64 "\n", total_nr);
> > +
> > +	for (i = 0; i < callchain_nr + 1; i++)
> >  		printf("..... %2d: %016" PRIx64 "\n",
> >  		       i, sample->callchain->ips[i]);
> 
> so if there's lbr callstack info we dont display user stack part from standard
> callchain? I think the dump code should dump out all the info..
> 
 
Right, we don't display user stack part from fp if there is lbr callstack info.
The lbr callstack info can only be captured when the user set --call-graph
lbr. If --call-graph is set to fp and dwarf, there will be no lbr callstack info.

If the user set lbr, I think he really want the lbr info. So I think if we display
both lbr and fp, the fp chain might be meaningless and it will confuse them.
If the user want to do compare, they can do perf record twice with 
different --call-graph.


Thanks,
Kan

> jirka
