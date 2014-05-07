Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933114AbaEGQmn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 12:42:43 -0400
Received: from mail-qg0-f50.google.com ([209.85.192.50]:57255 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932223AbaEGQml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 12:42:41 -0400
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Wed, 7 May 2014 12:46:24 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: perf_fuzzer crash on pentium 4
In-Reply-To: <20140506214630.GB1458@moon>
Message-ID: <alpine.DEB.2.10.1405071244570.6340@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.10.1405061137560.3220@vincent-weaver-1.umelst.maine.edu> <20140506202307.GA1458@moon> <alpine.DEB.2.10.1405061729350.4849@vincent-weaver-1.umelst.maine.edu> <20140506214630.GB1458@moon>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2014, Cyrill Gorcunov wrote:

> On Tue, May 06, 2014 at 05:30:19PM -0400, Vince Weaver wrote:
> > On Wed, 7 May 2014, Cyrill Gorcunov wrote:
> > 
> > > > [   67.872274] BUG: unable to handle kernel NULL pointer dereference at 00000004
> > > > [   67.876146] IP: [<ffffffff81013df2>] p4_pmu_schedule_events+0xa5/0x331
> > > 
> > > This looks like
> > > 
> > > p4_pmu_schedule_events:
> > > 		...
> > > 		bind = p4_config_get_bind(hwc->config);
> > > 			returned bind = NULL;
> > > 		escr_idx = p4_get_escr_idx(bind->escr_msr[thread]); NULL deref
> > > 
> > > If i'm right (btw it's possible to use addr2line helper?) 
> > 
> > Yes, the address maps to
> > 
> > 	escr_idx = p4_get_escr_idx(bind->escr_msr[thread]);
> 
> Great, now we knows the reason of the issue, only to figure out
> why is left ;)
> 
> > > then hwc->config
> > > is corrupted and p4_config_get_bind returned nil simply because proper event
> > > was not found. And I don't understand how it could happen because before
> > > configuration gets written into hwc->config it's validated once obtained
> > > from user-space as a raw event. Weird...
> > 
> > I'll try to get some sort of trace out if it to see what event is being 
> > tried.
> 
> Yeah, this would help a lot.

sorry for the delay, I like to compile kernels locally and it takes a 
really long time to build a ftrace-enabled kernel on a pentium 4 it seems.

Anyway I threw some printks in, and this is what I get:

[  447.572626] VMW: bind=NULL config=6b6b6b6b6b6b6b6b

I have slab poisoning turned on.  Use after free?

Vince
