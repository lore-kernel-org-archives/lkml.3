Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbbAJUmf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 15:42:35 -0500
Received: from mail.skyhub.de ([78.46.96.112]:47975 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754270AbbAJUme (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 15:42:34 -0500
Date: Sat, 10 Jan 2015 21:42:31 +0100
From: Borislav Petkov <bp@alien8.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Denys Vlasenko <vda.linux@googlemail.com>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 3/4] x86: open-code register save/restore in
 trace_hardirqs thunks
Message-ID: <20150110204231.GD12218@pd.tnic>
References: <1420734315-30943-1-git-send-email-dvlasenk@redhat.com>
 <1420734315-30943-4-git-send-email-dvlasenk@redhat.com>
 <20150109121950.GD13637@pd.tnic>
 <CAK1hOcMsGJ7geRAzfazPLZitcO0o9XYRPJDYa8sJHR4i6DPL-g@mail.gmail.com>
 <20150110142336.GC12218@pd.tnic>
 <CAK1hOcO7K=4N8CF=LOPmosXRNnogaNi5vLDPMdb0XiKsL=JOfg@mail.gmail.com>
 <CALCETrXS7BvtS3P3J8hnbt3GGvezx-935uxanSN_a=CU6s1d3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALCETrXS7BvtS3P3J8hnbt3GGvezx-935uxanSN_a=CU6s1d3g@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2015 at 12:17:13PM -0800, Andy Lutomirski wrote:
> I asked this once, and someone told me that push/pop has lower
> throughput.  I find this surprising.

Implicit dependency on %rsp probably. The MOVs allow you to start more
stuff out-of-order I'd guess...

> Tt could be worth adding a macro along the lines of pushq_cfi_save
> that does the pushq_cfi and the CFI_REL_OFFSET.

Yep, for balance.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
