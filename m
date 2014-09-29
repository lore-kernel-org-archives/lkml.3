Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbaI2JXA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 05:23:00 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:62234 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751146AbaI2JW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 05:22:59 -0400
Date: Mon, 29 Sep 2014 10:22:30 +0100
From: Will Deacon <will.deacon@arm.com>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: Sudeep Holla <Sudeep.Holla@arm.com>, "acme@redhat.com" <acme@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] perf tools: fix build breakage on arm and arm64 targets
Message-ID: <20140929092229.GB20303@arm.com>
References: <1411750918-25220-1-git-send-email-will.deacon@arm.com>
 <5425A008.2030901@arm.com>
 <CAFrcx1=s4Ae2z6OAC3dUR34rhd=HpKA+O9DAtM=QVNpJ7oNnEg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFrcx1=s4Ae2z6OAC3dUR34rhd=HpKA+O9DAtM=QVNpJ7oNnEg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 07:59:59AM +0100, Jean Pihet wrote:
> Hi Will,
> 
> On 26 September 2014 19:19, Sudeep Holla <sudeep.holla@arm.com> wrote:
> >
> > On 26/09/14 18:01, Will Deacon wrote:
> >>
> >> Attempting to build the perf tool on arm or arm64 targets results in the
> >> following failure:
> >>
> >> arch/arm/util/unwind-libunwind.c: In function ‘libunwind__arch_reg_id’:
> >> arch/arm/util/unwind-libunwind.c:43:3: error: implicit declaration of
> >> function ‘pr_err’ [-Werror=implicit-function-declaration]
> >>     pr_err("unwind: invalid reg id %d\n", regnum);
> >>     ^
> >> This is due to commit 84f5d36f4866 ("perf tools: Move pr_* debug macros
> >> into debug object") moving the pr_* macros into a new header file, but
> >> failing to update architectures other than x86.
> >>
> >> This patch adds the missing includes, and fixes the build again.
> 
> The fix for ARM is already in the tip tree at
> http://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/commit/?id=29a3ce31c38c8f73f4e076b7ffc0876b4f5dd6c3.

Thanks, but that doesn't fix the issue for arm64. I'm also not sure why
these haven't been merged into mainline -- without them, the tool doesn't
even build for arm/arm64 targets.

Will
