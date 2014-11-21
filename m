Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758240AbaKUPG1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 10:06:27 -0500
Received: from mga11.intel.com ([192.55.52.93]:17394 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755321AbaKUPG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 10:06:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,431,1413270000"; 
   d="scan'208";a="635937345"
From: "Liang, Kan" <kan.liang@intel.com>
To: "acme@kernel.org" <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
CC: "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "eranian@google.com" <eranian@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: RE: [PATCH V3 2/3] perf tool: Move cpumode resolve code to
 add_callchain_ip
Thread-Topic: [PATCH V3 2/3] perf tool: Move cpumode resolve code to
 add_callchain_ip
Thread-Index: AQHQABNGJDYEMra3kkyl6hDIwGsmpJxljACAgAWod8A=
Date: Fri, 21 Nov 2014 15:06:08 +0000
Message-ID: <37D7C6CF3E00A74B8858931C1DB2F07701674486@SHSMSX103.ccr.corp.intel.com>
References: <1415972652-17310-1-git-send-email-kan.liang@intel.com>
 <1415972652-17310-3-git-send-email-kan.liang@intel.com>
 <20141118082454.GB27645@krava.brq.redhat.com>
In-Reply-To: <20141118082454.GB27645@krava.brq.redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sALF6XuG018511



> -----Original Message-----
> From: Jiri Olsa [mailto:jolsa@redhat.com]
> Sent: Tuesday, November 18, 2014 3:25 AM
> To: Liang, Kan
> Cc: acme@kernel.org; a.p.zijlstra@chello.nl; eranian@google.com; linux-
> kernel@vger.kernel.org; mingo@redhat.com; paulus@samba.org;
> ak@linux.intel.com
> Subject: Re: [PATCH V3 2/3] perf tool: Move cpumode resolve code to
> add_callchain_ip
> 
> On Fri, Nov 14, 2014 at 08:44:11AM -0500, kan.liang@intel.com wrote:
> > From: Kan Liang <kan.liang@intel.com>
> >
> > Move the cpumode resolve code to add_callchain_ip function.
> > No change in behavior.
> >
> > Signed-off-by: Kan Liang <kan.liang@intel.com>
> > ---
> >  tools/perf/util/machine.c | 62
> > ++++++++++++++++++++++-------------------------
> >  1 file changed, 29 insertions(+), 33 deletions(-)
> >
> > diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
> > index d97309c..dd8496a 100644
> > --- a/tools/perf/util/machine.c
> > +++ b/tools/perf/util/machine.c
> > @@ -1384,11 +1384,35 @@ struct mem_info
> *sample__resolve_mem(struct
> > perf_sample *sample,  static int add_callchain_ip(struct thread *thread,
> >  			    struct symbol **parent,
> >  			    struct addr_location *root_al,
> > -			    int cpumode,
> > +			    u8 cpumode,
> 
> Andi's patch got in:
> b3340a5 perf callchain: Support handling complete branch stacks as
> histograms
> 
> and it uses the cpumode check for -1, so it needs to stay int, otherwise
> there's a compilation failure:
> 
>   CC       util/machine.o
> util/machine.c: In function â€˜add_callchain_ipâ€™:
> util/machine.c:1419:14: error: comparison is always false due to limited
> range of data type [-Werror=type-limits]
>   if (cpumode == -1)
>               ^
> 

Hi Arnaldo and Jirka,

According to recent feedback, the LBR call stack V4 patch only need to do small
change. However, it looks the patch "b3340a5 perf callchain: Support handling
complete branch stacks as histograms" has been removed from perf/core.

Should I wait for the patch to merge again and submit the V5 patch then, OR
Should I rebase the V5 to the latest perf/core and submit it today?

Thanks,
Kan


> 
> jirka
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
