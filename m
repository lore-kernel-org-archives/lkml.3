Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936944Ab3DJJa1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 05:30:27 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:49170 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab3DJJaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 05:30:24 -0400
Date: Wed, 10 Apr 2013 11:33:22 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Daniel Vetter <daniel@ffwll.ch>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        linux-arch@vger.kernel.org, daniel.vetter@ffwll.ch, x86@kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, robclark@gmail.com, tglx@linutronix.de,
        mingo@elte.hu, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 2/3] mutex: add support for reservation style locks, v2
Message-ID: <20130410093322.GH27612@phenom.ffwll.local>
Mail-Followup-To: Steven Rostedt <rostedt@goodmis.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Maarten Lankhorst <maarten.lankhorst@canonical.com>,
	linux-arch@vger.kernel.org, x86@kernel.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, robclark@gmail.com,
	tglx@linutronix.de, mingo@elte.hu, linux-media@vger.kernel.org
References: <20130228102452.15191.22673.stgit@patser>
 <20130228102502.15191.14146.stgit@patser>
 <1364900432.18374.24.camel@laptop>
 <515AF1C1.7080508@canonical.com>
 <1364921954.20640.22.camel@laptop>
 <1365076908.2609.94.camel@laptop>
 <20130404133123.GW2228@phenom.ffwll.local>
 <1365093662.2609.111.camel@laptop>
 <20130409222808.GC20739@home.goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130409222808.GC20739@home.goodmis.org>
X-Operating-System: Linux phenom 3.7.0-rc4+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 06:28:08PM -0400, Steven Rostedt wrote:
> On Thu, Apr 04, 2013 at 06:41:02PM +0200, Peter Zijlstra wrote:
> > On Thu, 2013-04-04 at 15:31 +0200, Daniel Vetter wrote:
> > > The thing is now that you're not expected to hold these locks for a
> > > long
> > > time - if you need to synchronously stall while holding a lock
> > > performance
> > > will go down the gutters anyway. And since most current
> > > gpus/co-processors
> > > still can't really preempt fairness isn't that high a priority,
> > > either.
> > > So we didn't think too much about that.
> > 
> > Yeah but you're proposing a new synchronization primitive for the core
> > kernel.. all such 'fun' details need to be considered, not only those
> > few that bear on the one usecase.
> 
> Which bares the question, what other use cases are there?

Tbh I don't see any other either - but I agree with Peter and thinking
things through and making the api a bit more generic seems to help in
clarifying the semantics. Reminds me that I still need to draw a few
diagrams ;-)
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
