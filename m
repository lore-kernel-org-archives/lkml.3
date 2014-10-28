Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968AbaJ1XPm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 19:15:42 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:33791 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345AbaJ1XPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 19:15:39 -0400
MIME-Version: 1.0
Date: Tue, 28 Oct 2014 16:15:38 -0700
Message-ID: <CAADnVQL3X_UqA1Oz1msuz8LyP0CTGG5iy16YwjdPUhoNTk31yQ@mail.gmail.com>
Subject: Re: [PATCH 2/5] perf, x86, uncore: Add Haswell-EP uncore support
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 8:30 AM, Andi Kleen <andi@firstfloor.org> wrote:
>> snbep_uncore_msr_init_box() is called with:
>> [    1.055678] msr 0
>> [    1.056027] msr 3584
>> [    1.056376] msr 3600
>> [    1.056725] msr 3616
>> [    1.057074] msr 3632
>> [    1.057424] msr 1824
>
> So it would normally crash here, right? That's the SBOX.
>
> When you remove the sbox in hswep_msr_uncores the crash goes away,
> correct?

yes. removing line 'hswep_uncore_sbox' also worked as workaround.
You have an idea what's going on?
I suspect other folks will see the same crash when E5 v3
become more widespread.
