Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760187AbaGYLE0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 07:04:26 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:38229 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759947AbaGYLEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 07:04:24 -0400
Date: Fri, 25 Jul 2014 12:03:42 +0100
From: Will Deacon <will.deacon@arm.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Deepak Saxena <dsaxena@linaro.org>,
        Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 1/3] arm64: ptrace: reload a syscall number after
 ptrace operations
Message-ID: <20140725110342.GD5269@arm.com>
References: <1406020499-5537-1-git-send-email-takahiro.akashi@linaro.org>
 <1406020499-5537-2-git-send-email-takahiro.akashi@linaro.org>
 <53D08358.4020902@amacapital.net>
 <53D0A037.2060308@linaro.org>
 <CALCETrU9_sdODRz-xZ4bouq+anHhmfx2tkr7hg00RVf_bBBJwg@mail.gmail.com>
 <53D23341.4040403@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53D23341.4040403@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 11:36:49AM +0100, AKASHI Takahiro wrote:
> On 07/25/2014 12:01 AM, Andy Lutomirski wrote:
> >>> If so, then you risk (at least) introducing
> >>>
> >>> a nice user-triggerable OOPS if audit is enabled.
> >>
> >>
> >> Can you please elaborate this?
> >> Since I didn't find any definition of audit's behavior when syscall is
> >> rewritten to -1, I thought it is reasonable to skip "exit tracing" of
> >> "skipped" syscall.
> >> (otherwise, "fake" seems to be more appropriate :)
> >
> > The audit entry hook will oops if you call it twice in a row without
> > calling the exit hook in between.
> 
> Thank you, I could reproduce this problem which hits BUG(in_syscall) in
> audit_syscall_entry(). Really bad, and I fixed it in my next version and
> now a "skipped" system call is also traced by audit.

Can you reproduce this on arch/arm/ too? If so, we should also fix the code
there.

Will
