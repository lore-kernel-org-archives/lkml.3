Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381AbaKRTmH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 14:42:07 -0500
Received: from mga11.intel.com ([192.55.52.93]:4461 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755230AbaKRTmF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 14:42:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,411,1413270000"; 
   d="scan'208";a="624424907"
From: "Liang, Kan" <kan.liang@intel.com>
To: "'Jiri Olsa'" <jolsa@redhat.com>, "'Namhyung Kim'" <namhyung@kernel.org>
CC: "'acme@kernel.org'" <acme@kernel.org>,
        "'a.p.zijlstra@chello.nl'" <a.p.zijlstra@chello.nl>,
        "'eranian@google.com'" <eranian@google.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'mingo@redhat.com'" <mingo@redhat.com>,
        "'paulus@samba.org'" <paulus@samba.org>,
        "'ak@linux.intel.com'" <ak@linux.intel.com>
Subject: RE: [PATCH V3 3/3] perf tools: Construct LBR call chain
Thread-Topic: [PATCH V3 3/3] perf tools: Construct LBR call chain
Thread-Index: AQHQAvbRcQ1rb+Jn4kS+6OT1ok92KZxlfgyAgADuSeCAAFnKMA==
Date: Tue, 18 Nov 2014 19:40:23 +0000
Message-ID: <37D7C6CF3E00A74B8858931C1DB2F077016717AD@SHSMSX103.ccr.corp.intel.com>
References: <1415972652-17310-1-git-send-email-kan.liang@intel.com>
 <1415972652-17310-4-git-send-email-kan.liang@intel.com>
 <20141117155425.GA31042@krava.brq.redhat.com>
 <37D7C6CF3E00A74B8858931C1DB2F07701670BF9@SHSMSX103.ccr.corp.intel.com>
 <87lhn9qbmp.fsf@sejong.aot.lge.com>
 <20141118075539.GA27645@krava.brq.redhat.com>
 <37D7C6CF3E00A74B8858931C1DB2F0770167125F@SHSMSX103.ccr.corp.intel.com>
In-Reply-To: <37D7C6CF3E00A74B8858931C1DB2F0770167125F@SHSMSX103.ccr.corp.intel.com>
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



> > whole
> > > >> stack.
> > > >> > +			 */
> > > >>
> > > >> Andi is using some sanity checks:
> > > >> http://marc.info/?l=linux-kernel&m=141584447819894&w=2
> > > >> I guess this could be applied in here, once his patch gets in.
> > > >>
> > > >
> > > > Are you suggesting me to remove the comments, or rebase the
> whole
> > > > patch to Andi's patch once it's merged?
> > > >
> > > > The branch history in Andi's patch is different as the call stack,
> > > > although they are both from LBR.
> > > > Andi's branch history recording branch records for taken branches,
> > > > interrupts, and exceptions.
> > > > While the LBR call stack records for the call stack.
> > >
> > > Right.  And branch history can overlap with normal callchains so
> > > additional check in there is to remove duplication.  While LBR call
> > > stack is separated to user only so there should be no overlap.
> >
> > hum, it seemed to me like the remove_loops function could be used for
> > this one as well.. but anyway I meant that this can be introduced
> > later after Andi's change gets in
> 
> I see. I will apply Andi's remove_loops.
> 

As Namhyung said, there is no overlap for LBR call stack. The user callchain 
is not a mix. It's from either LBR or FP. so remove_loops
doesn't fit to the LBR call stack. 
Sorry for the confusion from my last reply.

Thanks,
Kan  
