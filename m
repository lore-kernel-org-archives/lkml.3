Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540AbaHZLGT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 07:06:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2490 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755724AbaHZLGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 07:06:17 -0400
Message-ID: <53FC6A15.5090209@redhat.com>
Date: Tue, 26 Aug 2014 13:05:57 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Gleb Natapov <gleb@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Davis <jim.epost@gmail.com>,
        linux-next <linux-next@vger.kernel.org>
Subject: Re: [PATCH] KVM: Only export kvm_ple_window for x86_64
References: <20140825191035.59673878@gandalf.local.home>
In-Reply-To: <20140825191035.59673878@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 26/08/2014 01:10, Steven Rostedt ha scritto:
> Commit 7b46268d2954 "KVM: trace kvm_ple_window grow/shrink"
> Added the tracepoint kvm_ple_window under a #ifdef CONFIG_X86_64 but
> left the export for that tracepoint unprotected, which would cause it
> to fail to compile when X86_32 is set.
> 
> Link: http://lkml.kernel.org/p/20140825172204.769ab4e6@gandalf.local.home
> 
> Reported-by: Jim Davis <jim.epost@gmail.com>
> tested-by: Jim Davis <jim.epost@gmail.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

The current KVM branch should have fixed this already---it leaves the
tracepoint outside CONFIG_X86_64, which was the right thing to do in the
first place.

Paolo
