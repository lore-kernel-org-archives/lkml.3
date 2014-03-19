Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758796AbaCSBSt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 21:18:49 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:44395 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758493AbaCSBSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 21:18:48 -0400
Date: Tue, 18 Mar 2014 21:18:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the drm-intel tree
Message-ID: <20140318211842.017be730@gandalf.local.home>
In-Reply-To: <20140319115350.7860f102a804a9975ba6e93d@canb.auug.org.au>
References: <20140319115350.7860f102a804a9975ba6e93d@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Mar 2014 11:53:50 +1100
Stephen Rothwell <sfr@canb.auug.org.au> wrote:


> Caused by commit a25ca17c1eac ("drm/i915: Do not dereference pointers
> from ring buffer in evict event").
> 
> I have used the drm-intel tree from next-20140318 for today.
> 

Bah! I'm still suffering from jet lag (just came back from Linux-Tage
in Chemnitz).

The next time I compile test a patch for a module, I'll make sure I have
that module's config option set :-(  The woe of using localmodconfig. I
should have picked the box with the i915. :-/

Below is the fix. I'll repost a v2 of the original patch.

Sorry about that.

-- Steve

diff --git a/drivers/gpu/drm/i915/i915_trace.h b/drivers/gpu/drm/i915/i915_trace.h
index f3e8a90..783ae08 100644
--- a/drivers/gpu/drm/i915/i915_trace.h
+++ b/drivers/gpu/drm/i915/i915_trace.h
@@ -243,7 +243,7 @@ TRACE_EVENT(i915_gem_evict_vm,
 			    ),
 
 	    TP_fast_assign(
-			   __entry->dev = dev->primary->index;
+			   __entry->dev = vm->dev->primary->index;
 			   __entry->vm = vm;
 			  ),
 
