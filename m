Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140AbaD1TI5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:08:57 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:39862 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751305AbaD1TIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:08:53 -0400
Date: Mon, 28 Apr 2014 20:08:15 +0100
From: Will Deacon <will.deacon@arm.com>
To: Ding Tianhong <dingtianhong@huawei.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Robert Richter <rric@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        "huxinwei@huawei.com" <huxinwei@huawei.com>
Subject: Re: [PATCH] arm64: add OProfile support
Message-ID: <20140428190815.GA22135@arm.com>
References: <535B707F.7020802@huawei.com>
 <58ED971B-CC04-4BE1-916C-386D219874A8@arm.com>
 <535B88C9.6000908@huawei.com>
 <535DBDA4.6070607@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <535DBDA4.6070607@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 03:32:04AM +0100, Ding Tianhong wrote:
> On 2014/4/26 18:22, Ding Tianhong wrote:
> > On 2014/4/26 17:23, Catalin Marinas wrote:
> >> On 26 Apr 2014, at 09:38, Ding Tianhong <dingtianhong@huawei.com> wrote:
> >>> Add OProfile support for arm64,  using the perf backend, and failing back
> >>> to generic timer based sampling if PMU interrupt is not supported.
> >>>
> >>> I have test this patch on Cortex-A53 and Cortex-A57 motherboard, the OProfile
> >>> could work well by PMU irq or arch timer irq.
> >>
> >> This came up before a few times and we also had an implementation but
> >> decided not to merge it. We should rather get the user space oprofile to
> >> use the perf kernel API.
> >>
> >> That’s an old thread, it may have even made it into mainline oprofile
> >> but I haven’t followed the development:
> >>
> >> http://marc.info/?l=oprofile-list&m=133002515616302&w=2
> >>
> >> Catalin
> >>
> 
> Hi Cadtalin:
> 
> Sorry I could not find the implementation that not to merge the orpfile support for aarch64 till now, and
> I still have questions that the existing code only support oprofile by arch timer event, but not
> PMU event, this patch only add HW PMU support for oprofile, it is more accurate and stable, can you
> give me more advise and appreciate for your help.

Just use the operf tool, which is part of the oprofile project. It uses the
perf syscall under the hood and doesn't need any kernel-side additions over
perf.

Will
