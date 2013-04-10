Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935428Ab3DJNcR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 09:32:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:6509 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754678Ab3DJNcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 09:32:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,447,1363158000"; 
   d="scan'208";a="315987078"
Date: Wed, 10 Apr 2013 06:31:57 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf, x86: Allow setting period 1
Message-ID: <20130410133157.GG22166@tassilo.jf.intel.com>
References: <1362785070-12860-1-git-send-email-andi@firstfloor.org>
 <20130410125808.GC12978@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130410125808.GC12978@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 02:58:08PM +0200, Ingo Molnar wrote:
> 
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > I had some requests for setting period 1, so that every event of something
> > is caught.  To my knowledge there is no limit to 1 on Intel hardware.
> > Just remove the check for minimum 2
> > 
> > If specific CPUs have problems we can black list them.
> 
> How have you tested this? The commit that added this quirk mentions very high perf 
> load triggering badness unless this quirk is added.

Profiling a couple of simple loads on Westmere and IvyBridge: mostly AIM7 and
kernel builds. You can get throttling of course, but no excessive load.

The original quirk was done long ago before the modern event throttling
infrastructure may have been completely in place, right?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
