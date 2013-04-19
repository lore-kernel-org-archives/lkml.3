Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967909Ab3DSJZ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 05:25:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:42570 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757577Ab3DSJZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 05:25:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,507,1363158000"; 
   d="scan'208";a="324793356"
Date: Fri, 19 Apr 2013 10:25:52 +0100
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Jiri Slaby <jslaby@suse.cz>
Cc: daniel.vetter@ffwll.ch, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 3.9.0-rc7-next: i915: render error detected
Message-ID: <20130419092552.GH24068@cantiga.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Jiri Slaby <jslaby@suse.cz>, daniel.vetter@ffwll.ch,
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	LKML <linux-kernel@vger.kernel.org>
References: <51710B74.9020401@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51710B74.9020401@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 19, 2013 at 11:16:36AM +0200, Jiri Slaby wrote:
> Hi, with today's -next I got this:
> 
> [drm] capturing error event; look for more information in
> /sys/kernel/debug/dri/0/i915_error_state
> i915: render error detected, EIR: 0x00000010
> i915: page table error
> i915:   PGTBL_ER: 0x00000002
> [drm:i915_report_and_clear_eir] *ERROR* EIR stuck: 0x00000010, masking
> i915: render error detected, EIR: 0x00000010
> i915: page table error
> i915:   PGTBL_ER: 0x00000002

These feel like they are becoming more common, though we have had
reports of this style of error since the dawn of time. The error means
that the CPU accessed an invalid PTE - so the most likely a missing mb
or chipset flush.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
