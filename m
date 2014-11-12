Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbaKLScP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 13:32:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58053 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753056AbaKLScM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 13:32:12 -0500
Date: Wed, 12 Nov 2014 19:31:46 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: "Liang, Kan" <kan.liang@intel.com>
Cc: "acme@kernel.org" <acme@kernel.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "eranian@google.com" <eranian@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: Re: [PATCH 2/2] perf tools: Construct LBR call chain
Message-ID: <20141112183145.GA30122@krava.redhat.com>
References: <1415285886-16949-1-git-send-email-kan.liang@intel.com>
 <1415285886-16949-3-git-send-email-kan.liang@intel.com>
 <20141112085914.GC25338@krava>
 <37D7C6CF3E00A74B8858931C1DB2F07701661906@SHSMSX103.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37D7C6CF3E00A74B8858931C1DB2F07701661906@SHSMSX103.ccr.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 02:37:13PM +0000, Liang, Kan wrote:
> 
> 
> > > +
> > > +	printf("... chain: nr:%" PRIu64 "\n", total_nr);
> > > +
> > > +	for (i = 0; i < callchain_nr + 1; i++)
> > >  		printf("..... %2d: %016" PRIx64 "\n",
> > >  		       i, sample->callchain->ips[i]);
> > 
> > so if there's lbr callstack info we dont display user stack part from standard
> > callchain? I think the dump code should dump out all the info..
> > 
>  
> Right, we don't display user stack part from fp if there is lbr callstack info.
> The lbr callstack info can only be captured when the user set --call-graph
> lbr. If --call-graph is set to fp and dwarf, there will be no lbr callstack info.
> 
> If the user set lbr, I think he really want the lbr info. So I think if we display
> both lbr and fp, the fp chain might be meaningless and it will confuse them.
> If the user want to do compare, they can do perf record twice with 
> different --call-graph.

hum, IMO if the user wants the dump (report -D), she wants to see
everything she got from kernel

jirka
