Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334AbaKRHz5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 02:55:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417AbaKRHz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 02:55:56 -0500
Date: Tue, 18 Nov 2014 08:55:39 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: "Liang, Kan" <kan.liang@intel.com>, "acme@kernel.org" <acme@kernel.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "eranian@google.com" <eranian@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: Re: [PATCH V3 3/3] perf tools: Construct LBR call chain
Message-ID: <20141118075539.GA27645@krava.brq.redhat.com>
References: <1415972652-17310-1-git-send-email-kan.liang@intel.com>
 <1415972652-17310-4-git-send-email-kan.liang@intel.com>
 <20141117155425.GA31042@krava.brq.redhat.com>
 <37D7C6CF3E00A74B8858931C1DB2F07701670BF9@SHSMSX103.ccr.corp.intel.com>
 <87lhn9qbmp.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lhn9qbmp.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 03:13:50PM +0900, Namhyung Kim wrote:

SNIP

> >> > +			 * in "from" register, while the callee is stored
> >> > +			 * in "to" register.
> >> > +			 * For example, there is a call stack
> >> > +			 * "A"->"B"->"C"->"D".
> >> > +			 * The LBR registers will recorde like
> >> > +			 * "C"->"D", "B"->"C", "A"->"B".
> >> > +			 * So only the first "to" register and all "from"
> >> > +			 * registers are needed to construct the whole
> >> stack.
> >> > +			 */
> >> 
> >> Andi is using some sanity checks:
> >> http://marc.info/?l=linux-kernel&m=141584447819894&w=2
> >> I guess this could be applied in here, once his patch gets in.
> >> 
> >
> > Are you suggesting me to remove the comments,
> > or rebase the whole patch to Andi's patch once it's merged?
> >
> > The branch history in Andi's patch is different as the call stack,
> > although they are both from LBR.
> > Andi's branch history recording branch records for
> > taken branches, interrupts, and exceptions.
> > While the LBR call stack records for the call stack.
> 
> Right.  And branch history can overlap with normal callchains so
> additional check in there is to remove duplication.  While LBR call
> stack is separated to user only so there should be no overlap.

hum, it seemed to me like the remove_loops function could be used
for this one as well.. but anyway I meant that this can be introduced
later after Andi's change gets in

thanks,
jirka
