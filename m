Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932491AbaD2ODv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 10:03:51 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:63829 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757454AbaD2ODu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 10:03:50 -0400
Date: Tue, 29 Apr 2014 10:03:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Salman Qazi <sqazi@google.com>, Ingo Molnar <mingo@elte.hu>,
        Michal Hocko <mhocko@suse.cz>, Borislav Petkov <bp@alien8.de>,
        Vojtech Pavlik <vojtech@suse.cz>, Petr Tesarik <ptesarik@suse.cz>,
        Petr Mladek <pmladek@suse.cz>
Subject: Re: 64bit x86: NMI nesting still buggy?
Message-ID: <20140429100345.3f76a5bd@gandalf.local.home>
In-Reply-To: <alpine.LNX.2.00.1404291150200.8903@pobox.suse.cz>
References: <alpine.LNX.2.00.1404291150200.8903@pobox.suse.cz>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2014 15:05:55 +0200 (CEST)
Jiri Kosina <jkosina@suse.cz> wrote:


> According to 38.4 of [1], when SMM mode is entered while the CPU is 
> handling NMI, the end result might be that upon exit from SMM, NMIs will 
> be re-enabled and latched NMI delivered as nested [2].

Note, if this were true, then the x86_64 hardware would be extremely
buggy. That's because NMIs are not made to be nested. If SMM's come in
during an NMI and re-enables the NMI, then *all* software would break.
That would basically make NMIs useless.

The only time I've ever witness problems (and I stress NMIs all the
time), is when the NMI itself does a fault. Which my patch set handles
properly. I've also stressed this on boxes that do have SMIs and SMMs.

Now, you can have a bad BIOS that does re-enable NMIs from SMMs or
SMIs, but then you need to take that up with your vendor.

-- Steve


