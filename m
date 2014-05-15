Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099AbaEOUkh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 16:40:37 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:33451 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755231AbaEOUkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 16:40:35 -0400
Date: Thu, 15 May 2014 22:40:29 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: "H. Peter Anvin" <h.peter.anvin@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] drm: Missed clflushopt in drm_clflush_virt_range
Message-ID: <20140515204029.GU8790@phenom.ffwll.local>
Mail-Followup-To: "H. Peter Anvin" <h.peter.anvin@intel.com>,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Ingo Molnar <mingo@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>
References: <1400082072-22482-1-git-send-email-ross.zwisler@linux.intel.com>
 <20140515123846.GQ8790@phenom.ffwll.local>
 <5374D12C.9030400@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5374D12C.9030400@intel.com>
X-Operating-System: Linux phenom 3.14.0+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 07:37:32AM -0700, H. Peter Anvin wrote:
> On 05/15/2014 05:38 AM, Daniel Vetter wrote:
> > On Wed, May 14, 2014 at 09:41:12AM -0600, Ross Zwisler wrote:
> >> With this commit:
> >>
> >> 2a0788dc9bc4 x86: Use clflushopt in drm_clflush_virt_range
> >>
> >> If clflushopt is available on the system, we use it instead of clflush
> >> in drm_clflush_virt_range.  There were two calls to clflush in this
> >> function, but only one was changed to clflushopt.  This patch changes
> >> the other clflush call to clflushopt.
> >>
> >> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> >> Reported-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
> >>
> >> Cc: David Airlie <airlied@linux.ie>
> >> Cc: dri-devel@lists.freedesktop.org
> >> Cc: H Peter Anvin <h.peter.anvin@intel.com>
> >> Cc: Ingo Molnar <mingo@kernel.org>
> >> Cc: Thomas Gleixner <tglx@linutronix.de>
> > 
> > Picked to my topic/core-stuff drm branch so it doesn't get lost.
> > -Daniel
> > 
> 
> Does this mean you're picking this up, or do you want me to put it into

I'll forward it eventually to Dave for 3.16. But if someone else steals it
beforehand I don't mind ;-)
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
