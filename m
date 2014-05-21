Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324AbaEUWrU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 18:47:20 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:63641 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbaEUWrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 18:47:19 -0400
MIME-Version: 1.0
In-Reply-To: <537AEF2D.9040207@intel.com>
References: <537AEF2D.9040207@intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 21 May 2014 15:46:58 -0700
Message-ID: <CALCETrVFbo1yb7FyCH1Y=pHb89VPt9ycx0C-wv2A7h=CzwwdGA@mail.gmail.com>
Subject: Re: [x86, vdso] cfda7bb9ecb: +14.7% will-it-scale.per_thread_ops
To: Jet Chen <jet.chen@intel.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 10:59 PM, Jet Chen <jet.chen@intel.com> wrote:
> Hi Andy,
>
> FYI, we noticed the below changes on
>
> git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/vdso
> commit cfda7bb9ecbf9d96264bb5bade33a842966d1062 ("x86, vdso: Move syscall
> and sysenter setup into kernel/cpu/common.c")

This is really strange.  That change shouldn't have any effect except
that some kernels might boot a cycle or two faster.

>
> test case: nhm4/will-it-scale/sched_yield
>
> 3d7ee969bffcc98  cfda7bb9ecbf9d96264bb5bad
> ---------------  -------------------------
>     5497021 ~ 0%     +14.7%    6303424 ~ 0%  TOTAL
> will-it-scale.per_thread_ops
>        0.54 ~ 0%      +5.6%       0.57 ~ 0%  TOTAL will-it-scale.scalability
>     6209483 ~ 0%      +1.6%    6305917 ~ 0%  TOTAL
> will-it-scale.per_process_ops
>        2455 ~ 5%     +16.9%       2870 ~ 5%  TOTAL cpuidle.C1-NHM.usage
>        8829 ~ 7%     +15.2%      10169 ~10%  TOTAL
> slabinfo.kmalloc-64.active_objs
>       24.13 ~12%     +48.9%      35.93 ~14%  TOTAL time.user_time
>         393 ~ 0%      -3.0%        382 ~ 1%  TOTAL time.system_time
>

Is this a speedup or a slowdown?

--Andy
