Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932832AbaE3KH0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 06:07:26 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47714 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755156AbaE3KHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 06:07:24 -0400
Date: Fri, 30 May 2014 12:07:16 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Chen, Gong" <gong.chen@linux.intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, tony.luck@intel.com,
        m.chehab@samsung.com, linux-acpi@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/7 v6] trace, RAS: Add eMCA trace event interface
Message-ID: <20140530100716.GE28131@pd.tnic>
References: <1400142646-10127-1-git-send-email-gong.chen@linux.intel.com>
 <1401247938-22125-1-git-send-email-gong.chen@linux.intel.com>
 <1401247938-22125-2-git-send-email-gong.chen@linux.intel.com>
 <20140528112832.5f83c66b@gandalf.local.home>
 <20140528163452.GF17196@pd.tnic>
 <20140528125625.6f6dcf7f@gandalf.local.home>
 <20140530092232.GA13495@gchen.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140530092232.GA13495@gchen.bj.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 05:22:32AM -0400, Chen, Gong wrote:
> We have two big chunk string. One for memory error location, the other
> for DIMM error location. Since DIMM error location depends on some
> other conditions, how about just converting memory error location to a
> compact mode but leaving DIMM error location alone?

Please elaborate, what conditions? DIMM silk screen labels or so? Maybe
we can generate a mapping between text labels and indices and we can
dump the indices in the tracepoint and do the mapping back to strings in
userspace...?

> For memory error location, I will utilize type offset to save one
> more byte, furthermore, I want to drop requestor_id, responder_id
> and target_id. 1) They are very rare (I've never seen them by now)

My concern is, are we sure we're never going to need them at all? Tony,
what's your take on this?

> 2) They are u64 but not u16. So to keep whole struct clean I want
> to use following struct. We can extend it later when necessary.
> 
> struct __attribute__((__packed__)) cper_sec_mem_rec {
> 	u8 type;
> 	u16 data;
> };
> 
> So whole struct is just 3 bytes. Even if all fields are valid, we
> have 3 * 9 = 27 bytes in total for a record in the ring buffer.
> 
> Make sense?

That is definitely much better than what we have now.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
