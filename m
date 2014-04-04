Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318AbaDDTM3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 15:12:29 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:43595 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042AbaDDTM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 15:12:27 -0400
MIME-Version: 1.0
In-Reply-To: <20140404174842.GA25736@gmail.com>
References: <20140404064120.GB11877@gmail.com>
	<tip-d122ab8d224a59aa0c3e4ba3540c6ab99556c3e3@git.kernel.org>
	<20140404080006.GB6944@gmail.com>
	<533EB5F1.8060002@linux.intel.com>
	<20140404174842.GA25736@gmail.com>
Date: Fri, 4 Apr 2014 12:12:26 -0700
X-Google-Sender-Auth: RnZvRtdmi_Xze2F9VZkA41KKLSQ
Message-ID: <CA+55aFw6oYajG8DeUTRDFwTtHey-byXMU9zHXxs3nB2RjS-3zg@mail.gmail.com>
Subject: Re: [tip:x86/reboot] [PATCH] x86: Try the BIOS reboot method before
 the PCI reboot method
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: "Li, Aubrey" <aubrey.li@linux.intel.com>, Peter Anvin <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        Adam Williamson <awilliam@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 4, 2014 at 10:48 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> 'Breaks a box' is more than enough justification to revert a patch...

Indeed. That's especially true when "breaks a box" was found within a
day of the patch being merged.

The default thinking should be: "If we found _one_ box that broke
during the merge window, that probably means that there are at least
ten thousand boxes that would break if the change actually hit a major
distribution kernel".

Yes, developer boxes are sometimes "special". But the fact is, I doubt
that's the case. Not when this kind of breakage (oops, reboot doesn't
work) is actually not all that unusual. The quirk entries we have for
it are *not* developer boxes.

            Linus
