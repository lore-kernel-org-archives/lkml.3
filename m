Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423312Ab3DFQ3N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 12:29:13 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:59951 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423289Ab3DFQ3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 12:29:12 -0400
Date: Sat, 6 Apr 2013 18:29:07 +0200
From: Robert Richter <rric@kernel.org>
To: Borislav Petkov <bp@alien8.de>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Borislav Petkov <bp@suse.de>
Subject: Re: [RFC PATCH 2/3] perf: Add persistent event facilities
Message-ID: <20130406162907.GG11652@rric.localhost>
References: <1363352789-17991-1-git-send-email-bp@alien8.de>
 <1363352789-17991-3-git-send-email-bp@alien8.de>
 <20130328181516.GR11449@rric.localhost>
 <20130403172712.GA4716@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130403172712.GA4716@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03.04.13 19:27:12, Borislav Petkov wrote:
> > > +	list_for_each_entry(desc, &per_cpu(pers_events, cpu), plist) {
> > > +
> > > +		if (desc->attr->config != attr->config)
> > > +			continue;
> > 
> > Umm, the attr->config is not sufficient as a selector since it must be
> > unique which is not granted (of course it works for one event only).
> 
> Right, so the tracepoints are enumerated by tracing code at boot
> time. But not the hw events, for example. How can we select events
> unambiguously?

As we discussed personally, in a first version we should allow only
the tracepoint pmu to be used for persistent events. The config value
is then unique and the above works.

-Robert
