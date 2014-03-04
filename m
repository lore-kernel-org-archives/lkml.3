Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492AbaCDXFL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 18:05:11 -0500
Received: from mail.skyhub.de ([78.46.96.112]:46707 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565AbaCDXFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 18:05:08 -0500
Date: Wed, 5 Mar 2014 00:05:05 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: perf_fuzzer compiled for x32 causes reboot
Message-ID: <20140304230505.GA27095@pd.tnic>
References: <alpine.DEB.2.10.1402280957470.6727@vincent-weaver-1.um.maine.edu>
 <1c583986-74f8-4829-883b-390dc49ddabb@email.android.com>
 <20140228154026.GH9987@twins.programming.kicks-ass.net>
 <5310B60F.30806@zytor.com>
 <20140228112946.1f194397@gandalf.local.home>
 <20140228205638.GD14089@laptop.programming.kicks-ass.net>
 <20140228160638.3b045dbc@gandalf.local.home>
 <20140301091650.GD5885@gmail.com>
 <20140301095042.GA16524@pd.tnic>
 <7f55737e-25a2-4cf0-aa07-17102a368ef2@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7f55737e-25a2-4cf0-aa07-17102a368ef2@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 01, 2014 at 08:50:17AM -0800, H. Peter Anvin wrote:
> The bottom line is that if we want hard numbers we probably have to
> measure.
>
> Hoisting the cr2 read is a no-brainer, might even help performance...

Btw, I just got word that on AMD, a read from CR2 is 4 cycles on family
0x15 and 3 cycles on family 0x10. If we're in the same ballpark on
Intel, I'd say we're fine with those numbers even in hot paths. The OoO
is an additional bonus which should hide latency even more.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
