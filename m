Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502AbaEFVqd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 17:46:33 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:54089 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbaEFVqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 17:46:32 -0400
Date: Wed, 7 May 2014 01:46:30 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: perf_fuzzer crash on pentium 4
Message-ID: <20140506214630.GB1458@moon>
References: <alpine.DEB.2.10.1405061137560.3220@vincent-weaver-1.umelst.maine.edu>
 <20140506202307.GA1458@moon>
 <alpine.DEB.2.10.1405061729350.4849@vincent-weaver-1.umelst.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1405061729350.4849@vincent-weaver-1.umelst.maine.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2014 at 05:30:19PM -0400, Vince Weaver wrote:
> On Wed, 7 May 2014, Cyrill Gorcunov wrote:
> 
> > > [   67.872274] BUG: unable to handle kernel NULL pointer dereference at 00000004
> > > [   67.876146] IP: [<ffffffff81013df2>] p4_pmu_schedule_events+0xa5/0x331
> > 
> > This looks like
> > 
> > p4_pmu_schedule_events:
> > 		...
> > 		bind = p4_config_get_bind(hwc->config);
> > 			returned bind = NULL;
> > 		escr_idx = p4_get_escr_idx(bind->escr_msr[thread]); NULL deref
> > 
> > If i'm right (btw it's possible to use addr2line helper?) 
> 
> Yes, the address maps to
> 
> 	escr_idx = p4_get_escr_idx(bind->escr_msr[thread]);

Great, now we knows the reason of the issue, only to figure out
why is left ;)

> > then hwc->config
> > is corrupted and p4_config_get_bind returned nil simply because proper event
> > was not found. And I don't understand how it could happen because before
> > configuration gets written into hwc->config it's validated once obtained
> > from user-space as a raw event. Weird...
> 
> I'll try to get some sort of trace out if it to see what event is being 
> tried.

Yeah, this would help a lot.
