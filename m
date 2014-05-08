Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539AbaEHFiz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 01:38:55 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:42688 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbaEHFiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 01:38:54 -0400
Date: Thu, 8 May 2014 09:38:51 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: perf_fuzzer crash on pentium 4
Message-ID: <20140508053851.GK8607@moon>
References: <alpine.DEB.2.10.1405061137560.3220@vincent-weaver-1.umelst.maine.edu>
 <20140506202307.GA1458@moon>
 <20140508020050.GX39568@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140508020050.GX39568@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 10:00:50PM -0400, Don Zickus wrote:
> > 
> > If i'm right (btw it's possible to use addr2line helper?) then hwc->config
> > is corrupted and p4_config_get_bind returned nil simply because proper event
> > was not found. And I don't understand how it could happen because before
> > configuration gets written into hwc->config it's validated once obtained
> > from user-space as a raw event. Weird...
> 
> I think my commit 13beacee817d27a40ffc6f065ea0042685611dd5 explains this
> corruption.  Though I have to admit I haven't looked through the problem
> very closely yet.

nope ;) without the fix above we could (and we did) simply misconfigure
counter but never get access out of array bound. anyway, Vince confirm
the fix from PeterZ healed the problem.

> IOW my lazy fix in that commit doesn't cover fuzzers and the real problem
> in p4_pmu_schedule_events. :-)
