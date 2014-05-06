Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbaEFV0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 17:26:46 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:60191 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561AbaEFV0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 17:26:44 -0400
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Tue, 6 May 2014 17:30:19 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: perf_fuzzer crash on pentium 4
In-Reply-To: <20140506202307.GA1458@moon>
Message-ID: <alpine.DEB.2.10.1405061729350.4849@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.10.1405061137560.3220@vincent-weaver-1.umelst.maine.edu> <20140506202307.GA1458@moon>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2014, Cyrill Gorcunov wrote:

> > [   67.872274] BUG: unable to handle kernel NULL pointer dereference at 00000004
> > [   67.876146] IP: [<ffffffff81013df2>] p4_pmu_schedule_events+0xa5/0x331
> 
> This looks like
> 
> p4_pmu_schedule_events:
> 		...
> 		bind = p4_config_get_bind(hwc->config);
> 			returned bind = NULL;
> 		escr_idx = p4_get_escr_idx(bind->escr_msr[thread]); NULL deref
> 
> If i'm right (btw it's possible to use addr2line helper?) 

Yes, the address maps to

	escr_idx = p4_get_escr_idx(bind->escr_msr[thread]);

> then hwc->config
> is corrupted and p4_config_get_bind returned nil simply because proper event
> was not found. And I don't understand how it could happen because before
> configuration gets written into hwc->config it's validated once obtained
> from user-space as a raw event. Weird...

I'll try to get some sort of trace out if it to see what event is being 
tried.

Vince
