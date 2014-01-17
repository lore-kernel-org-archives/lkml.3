Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513AbaAQKIK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 05:08:10 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:60016 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752492AbaAQKIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 05:08:05 -0500
Date: Fri, 17 Jan 2014 10:07:23 +0000
From: Will Deacon <will.deacon@arm.com>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnaldo <acme@ghostprotocols.net>,
        "patches@linaro.org" <patches@linaro.org>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] ARM64: perf: support dwarf unwinding in compat mode
Message-ID: <20140117100723.GB16003@mudshark.cambridge.arm.com>
References: <1389869123-5884-1-git-send-email-jean.pihet@linaro.org>
 <20140116115634.GE30257@mudshark.cambridge.arm.com>
 <CAFrcx1=eAHsGZDsedGvvNai7Vrnf5p8RKLGFPS+cn5yGp7UQJw@mail.gmail.com>
 <20140116125727.GI30257@mudshark.cambridge.arm.com>
 <CAFrcx1npWFs3=rooqiGKSv-p7ivcG1J7SCvcmsz-hd3waXBfdA@mail.gmail.com>
 <CAFrcx1=QWPFeuNDc0JatiykGnRuvPyOgwwCxnW7pSAiNa9RsxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFrcx1=QWPFeuNDc0JatiykGnRuvPyOgwwCxnW7pSAiNa9RsxA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 09:00:09AM +0000, Jean Pihet wrote:
> On 16 January 2014 14:47, Jean Pihet <jean.pihet@linaro.org> wrote:
> >> So the simplest thing would be to make compat_user_stack_pointer expand to
> >> user_stack_pointer(current_pt_regs()) on arm64 and merge that in with your
> >> original patch fixing user_stack_pointer.
> 
> I see 2 issues in your proposal:
> 
> 1) user_stack_pointer(regs) calls compat_user_stack_pointer if
> compat_user_mode(regs)) and compat_user_stack_pointer expands to
> user_stack_pointer. I see a circular dependency in the macros.

Not today it doesn't, so you just need to avoid writing the circular
dependency and instead make user_stack_pointer access (regs)->compat_sp
instead.

> 2) current_pt_regs() returns the current task regs although perf
> passes a regs struct that had been recorded previously.

Yes, but compat_user_stack_pointer doesn't take a regs paramater anyway, so
there's no change in behaviour here.

Will
