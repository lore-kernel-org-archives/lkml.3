Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707AbaK1Jtm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 04:49:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38468 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564AbaK1Jtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 04:49:39 -0500
Date: Fri, 28 Nov 2014 10:49:26 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: "Liang, Kan" <kan.liang@intel.com>
Cc: Namhyung Kim <namhyung@kernel.org>, "acme@kernel.org" <acme@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: Re: [PATCH V5 3/3] perf tool: check buildid for symoff
Message-ID: <20141128094926.GB27703@krava.brq.redhat.com>
References: <1416844829-26945-1-git-send-email-kan.liang@intel.com>
 <1416844829-26945-3-git-send-email-kan.liang@intel.com>
 <87d289o0sz.fsf@sejong.aot.lge.com>
 <37D7C6CF3E00A74B8858931C1DB2F07701676CB2@SHSMSX103.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37D7C6CF3E00A74B8858931C1DB2F07701676CB2@SHSMSX103.ccr.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 02:09:51PM +0000, Liang, Kan wrote:
> 
> 
> > Hi Kan,
> > 
> > On Mon, 24 Nov 2014 11:00:29 -0500, Kan Liang wrote:
> > > From: Kan Liang <kan.liang@intel.com>
> > >
> > > symoff can support both same binaries and different binaries. However,
> > > the offset may be changed for different binaries. This patch checks
> > > the buildid of perf.data. If they are from different binaries, print a
> > > warning to notify the user.
> > 
> > Hmm.. I think that perf diff is supposed to compare performance between
> > different (i.e. modified) binaries.  So there's a little point to print the
> > warning IMHO - but I'm not insist it strongly..
> > 
> > Anyway, I think what we really need for the warning is different version of
> > same binary.  For example, if data file 1 has DSO A and B, and data file 2 has
> > DSO B and C, we should not consider they're different (unless build-ids of B
> > in data file 1 and 2 are different) since A and C won't affect symoff
> > comparision.

that sounds good to me

> >
> 
> It looks good.
> But I still slightly prefer to warn/inform the user if there are any different dsos,
> not just from common part. But it's not a strong option.
> I'd like to hear from others.
> 
> Arnaldo? Jirka?

sorry for late reply.. anyway like I said in the other email

---
IMO one (WARN_ONCE style) warning by default if we see
buildids discrepancy and detailed comparison for --verbose
---

I think the breakage of the check (that Namhyung described) could
be mentioned/labeled somehow as serious issue in the warning and
we could also 'inform' about "any different dsos" as you mentioned

jirka

> 
> Thanks,
> Kan
>  
> > Thanks,
> > Namhyung
