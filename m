Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131AbaEBUTn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 16:19:43 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:6416 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752218AbaEBUTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 16:19:42 -0400
Date: Fri, 2 May 2014 16:19:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        "H. Peter Anvin" <h.peter.anvin@intel.com>
Subject: Re: [RFC/HACK] x86: Fast return to kernel
Message-ID: <20140502161939.26b61b7c@gandalf.local.home>
In-Reply-To: <CA+55aFzfDgeFmzk18xJ+ZvCcm-qCsCtd4RrNxYi0CXdfNbZn_A@mail.gmail.com>
References: <210a076ea197ae384705d2c02cfff12a951a62f8.1399057218.git.luto@amacapital.net>
	<CA+55aFzfDgeFmzk18xJ+ZvCcm-qCsCtd4RrNxYi0CXdfNbZn_A@mail.gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 May 2014 12:31:42 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> And NMI not being re-enabled might just be a real advantage. Adding
> Steven to the cc to make him aware of this patch.
> 

There's not much of an advantage for NMIs, as they seldom page fault.
We may get some due to vmalloc'd areas, but the whole nested NMI code
that I wrote was to deal with breakpoints in NMIs.

Although, this patch would have helped before my code, when doing
things like dumping stacks from NMI context, as some stack dumps can
trigger a page fault. In the past, I used dump all task's states from
NMI context to find why the system locked up hard. But due to the
re-enabling of NMIs with page faults, that usually caused the system to
triple fault, and made that debugging method rather useless.

-- Steve
