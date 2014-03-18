Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756968AbaCRTuZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 15:50:25 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:64651 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755509AbaCRTuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 15:50:22 -0400
Date: Tue, 18 Mar 2014 20:50:07 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Ben Widawsky <ben@bwidawsk.net>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH] drm/i915: Do not dereference pointers from ring buffer
 in evict event
Message-ID: <20140318195007.GJ30571@phenom.ffwll.local>
Mail-Followup-To: Steven Rostedt <rostedt@goodmis.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Ben Widawsky <ben@bwidawsk.net>,
	Chris Wilson <chris@chris-wilson.co.uk>,
	Ramkumar Ramachandra <artagnon@gmail.com>,
	Jiri Olsa <jolsa@redhat.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>, stable <stable@vger.kernel.org>
References: <20140318112737.2192898a@gandalf.local.home>
 <20140318113136.02d2e08b@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140318113136.02d2e08b@gandalf.local.home>
X-Operating-System: Linux phenom 3.12.0+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 11:31:36AM -0400, Steven Rostedt wrote:
> On Tue, 18 Mar 2014 11:27:37 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > The TP_printk() should never dereference any pointers, because the ring
> > buffer can be read at some unknown time in the future. If a device no
> > longer exists, it can cause a kernel oops. This also makes this
> > event useless when saving the ring buffer in userspaces tools such as
> > perf and trace-cmd.
> > 
> > The i915_gem_evict_vm dereferences the vm pointer which may also not
> > exist when the ring buffer is read sometime in the future.
> > 
> > Link: http://lkml.kernel.org/r/1395095198-20034-3-git-send-email-artagnon@gmail.com
> > Reported-by: Ramkumar Ramachandra <artagnon@gmail.com> Cc:
> > stable@vger.kernel.org # 3.13+
> 
> Bah, claw's mail is playing havoc with my line wraps. Please fix the
> above when applying, or I can send anothe patch. Thanks :-)
> 
> I had to re-insert the patch due to it but didn't see the screw up with
> the Cc of stable.

Patch applied and cc: stable fixed, thanks.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
