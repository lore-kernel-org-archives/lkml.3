Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934411AbaE3VQJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 17:16:09 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:38265 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324AbaE3VQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 17:16:07 -0400
MIME-Version: 1.0
In-Reply-To: <20140530100716.GE28131@pd.tnic>
References: <1400142646-10127-1-git-send-email-gong.chen@linux.intel.com>
	<1401247938-22125-1-git-send-email-gong.chen@linux.intel.com>
	<1401247938-22125-2-git-send-email-gong.chen@linux.intel.com>
	<20140528112832.5f83c66b@gandalf.local.home>
	<20140528163452.GF17196@pd.tnic>
	<20140528125625.6f6dcf7f@gandalf.local.home>
	<20140530092232.GA13495@gchen.bj.intel.com>
	<20140530100716.GE28131@pd.tnic>
Date: Fri, 30 May 2014 14:16:06 -0700
Message-ID: <CA+8MBbK7JO=+adEAuAQSBroL5133bA0U6J+yfx4sqVhzR4iVBA@mail.gmail.com>
Subject: Re: [PATCH 5/7 v6] trace, RAS: Add eMCA trace event interface
From: Tony Luck <tony.luck@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "Chen, Gong" <gong.chen@linux.intel.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        linux-acpi <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 3:07 AM, Borislav Petkov <bp@alien8.de> wrote:
> Please elaborate, what conditions? DIMM silk screen labels or so? Maybe
> we can generate a mapping between text labels and indices and we can
> dump the indices in the tracepoint and do the mapping back to strings in
> userspace...?

The UEFI error record gives us the SMBIOS "handle" (2-byte index). We
use that to look up the bank and device locator strings ... which should be
the silk-screen labels (in a correctly written BIOS).

So we could just have the tracepoint save the "handle" and do the
decode later.  If we want to keep doing mappings in the kernel (so console
logs can say "DIMM location: CPU 0 DIMM_C1" rather than
"SMBIOS handle 0x0015") - and would like to make things easier
for ourselves - we could have dmi_memdev_walk() do a bit more
work so we can just index an allocated array of strings that are
the concatenation of the bank/device locators.

-Tony
