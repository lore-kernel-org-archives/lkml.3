Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbaKSF53 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 00:57:29 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:35673 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754005AbaKSF52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 00:57:28 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: "Liang\, Kan" <kan.liang@intel.com>
Cc: "'Jiri Olsa'" <jolsa@redhat.com>, "'acme\@kernel.org'" <acme@kernel.org>,
        "'a.p.zijlstra\@chello.nl'" <a.p.zijlstra@chello.nl>,
        "'eranian\@google.com'" <eranian@google.com>,
        "'linux-kernel\@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'mingo\@redhat.com'" <mingo@redhat.com>,
        "'paulus\@samba.org'" <paulus@samba.org>,
        "'ak\@linux.intel.com'" <ak@linux.intel.com>
Subject: Re: [PATCH V3 3/3] perf tools: Construct LBR call chain
References: <1415972652-17310-1-git-send-email-kan.liang@intel.com>
	<1415972652-17310-4-git-send-email-kan.liang@intel.com>
	<20141117155425.GA31042@krava.brq.redhat.com>
	<37D7C6CF3E00A74B8858931C1DB2F07701670BF9@SHSMSX103.ccr.corp.intel.com>
	<87lhn9qbmp.fsf@sejong.aot.lge.com>
	<20141118075539.GA27645@krava.brq.redhat.com>
	<37D7C6CF3E00A74B8858931C1DB2F0770167125F@SHSMSX103.ccr.corp.intel.com>
	<37D7C6CF3E00A74B8858931C1DB2F077016717AD@SHSMSX103.ccr.corp.intel.com>
Date: Wed, 19 Nov 2014 14:57:25 +0900
In-Reply-To: <37D7C6CF3E00A74B8858931C1DB2F077016717AD@SHSMSX103.ccr.corp.intel.com>
	(Kan Liang's message of "Tue, 18 Nov 2014 19:40:23 +0000")
Message-ID: <878uj7rauy.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kan,

On Tue, 18 Nov 2014 19:40:23 +0000, Kan Liang wrote:
>> > whole
>> > > >> stack.
>> > > >> > +			 */
>> > > >>
>> > > >> Andi is using some sanity checks:
>> > > >> http://marc.info/?l=linux-kernel&m=141584447819894&w=2
>> > > >> I guess this could be applied in here, once his patch gets in.
>> > > >>
>> > > >
>> > > > Are you suggesting me to remove the comments, or rebase the
>> whole
>> > > > patch to Andi's patch once it's merged?
>> > > >
>> > > > The branch history in Andi's patch is different as the call stack,
>> > > > although they are both from LBR.
>> > > > Andi's branch history recording branch records for taken branches,
>> > > > interrupts, and exceptions.
>> > > > While the LBR call stack records for the call stack.
>> > >
>> > > Right.  And branch history can overlap with normal callchains so
>> > > additional check in there is to remove duplication.  While LBR call
>> > > stack is separated to user only so there should be no overlap.
>> >
>> > hum, it seemed to me like the remove_loops function could be used for
>> > this one as well.. but anyway I meant that this can be introduced
>> > later after Andi's change gets in
>> 
>> I see. I will apply Andi's remove_loops.
>> 
>
> As Namhyung said, there is no overlap for LBR call stack. The user callchain 
> is not a mix. It's from either LBR or FP. so remove_loops
> doesn't fit to the LBR call stack. 

IIUC the remove_loops() is for eliminating repeated branches in a loop
in a single function (and it only checks LBRs not FP callchain).  It's
needed since branch history saves all branches, but not needed for LBR
callstack as it saves CALLs only.

Thanks,
Namhyung
