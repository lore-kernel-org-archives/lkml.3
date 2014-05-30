Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030198AbaE3V1H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 17:27:07 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35633 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754611AbaE3V1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 17:27:03 -0400
Date: Fri, 30 May 2014 23:26:53 +0200
From: Borislav Petkov <bp@alien8.de>
To: Tony Luck <tony.luck@gmail.com>
Cc: "Chen, Gong" <gong.chen@linux.intel.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        linux-acpi <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/7 v6] trace, RAS: Add eMCA trace event interface
Message-ID: <20140530212653.GK28131@pd.tnic>
References: <1400142646-10127-1-git-send-email-gong.chen@linux.intel.com>
 <1401247938-22125-1-git-send-email-gong.chen@linux.intel.com>
 <1401247938-22125-2-git-send-email-gong.chen@linux.intel.com>
 <20140528112832.5f83c66b@gandalf.local.home>
 <20140528163452.GF17196@pd.tnic>
 <20140528125625.6f6dcf7f@gandalf.local.home>
 <20140530092232.GA13495@gchen.bj.intel.com>
 <20140530100716.GE28131@pd.tnic>
 <CA+8MBbK7JO=+adEAuAQSBroL5133bA0U6J+yfx4sqVhzR4iVBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+8MBbK7JO=+adEAuAQSBroL5133bA0U6J+yfx4sqVhzR4iVBA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 02:16:06PM -0700, Tony Luck wrote:
> On Fri, May 30, 2014 at 3:07 AM, Borislav Petkov <bp@alien8.de> wrote:
> > Please elaborate, what conditions? DIMM silk screen labels or so? Maybe
> > we can generate a mapping between text labels and indices and we can
> > dump the indices in the tracepoint and do the mapping back to strings in
> > userspace...?
> 
> The UEFI error record gives us the SMBIOS "handle" (2-byte index). We
> use that to look up the bank and device locator strings ... which should be
> the silk-screen labels (in a correctly written BIOS).

Ok, sounds straightforward.

> So we could just have the tracepoint save the "handle" and do the
> decode later. If we want to keep doing mappings in the kernel (so
> console logs can say "DIMM location: CPU 0 DIMM_C1" rather than
> "SMBIOS handle 0x0015") - and would like to make things easier for
> ourselves - we could have dmi_memdev_walk() do a bit more work
> so we can just index an allocated array of strings that are the
> concatenation of the bank/device locators.

Right, we probably would need both: if a userspace agent is active, it'd
need to resolve the handle and otherwise we'll be doing it in the kernel
with dmi.

But it all sounds very doable and nice to me.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
