Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695AbaHMUU3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 16:20:29 -0400
Received: from mail.kernel.org ([198.145.19.201]:50779 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516AbaHMUU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 16:20:28 -0400
Date: Wed, 13 Aug 2014 17:20:23 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>, Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC/PATCH 1/2] perf top: Fix -z option behavior
Message-ID: <20140813202023.GJ2718@kernel.org>
References: <1407831366-28892-1-git-send-email-namhyung@kernel.org>
 <53EA6495.4010600@gmail.com>
 <87vbpxdm8s.fsf@sejong.aot.lge.com>
 <53EAFBDB.8050500@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53EAFBDB.8050500@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Aug 12, 2014 at 11:47:07PM -0600, David Ahern escreveu:
> On 8/12/14, 10:52 PM, Namhyung Kim wrote:
> 
> >Are you sure?  I don't recall seeing any big change in this area so I
> >guess the problem existed since long time ago.  In fact I couldn't find
> >a logic to zero/clear out existing hist entries in a hists..
> 
> Just gave a quick try. v3.4 fails; v3.1 works.

I would say it was this one, without bisecting:

--------------------------------------------------------------------------------

commit ab81f3fd350c510730adb1ca40ef55c2b2952121
Author: Arnaldo Carvalho de Melo <acme@redhat.com>
Date:   Wed Oct 5 19:16:15 2011 -0300

    perf top: Reuse the 'report' hist_entry/hists classes
    
    This actually fixes several problems we had in the old 'perf top':
    
    1. Unresolved symbols not show, limitation that came from the old
       "KernelTop" codebase, to solve it we would need to do changes
       that would make sym_entry have most of the hist_entry fields.
    2. It was using the number of samples, not the sum of sample->period.
    
    And brings the --sort code that allows us to have all the views in
    'perf report', for instance:
<SNIP>
--------------------------------------------------------------------------------

It ended up only honouring the zeroing logic for the annotation stuff.

Anyway, reviewing Namhyung proposed fix now.

- Arnaldo
