Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101Ab3IYS3l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 14:29:41 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:50266 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226Ab3IYS3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 14:29:40 -0400
Date: Wed, 25 Sep 2013 20:29:36 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, huawei.libin@huawei.com,
        wangyijing@huawei.com, fenghua.yu@intel.com, tglx@linutronix.de,
        guohanjun@huawei.com, paul.gortmaker@windriver.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86/smpboot: Fix announce_cpu() to printk() the
 last "OK" properly
Message-ID: <20130925182936.GD16693@gmail.com>
References: <1378378676-18276-1-git-send-email-huawei.libin@huawei.com>
 <tip-52239484bf8aec031afa84ae08aa88224d819b93@git.kernel.org>
 <20130925100722.GB3433@nazgul.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130925100722.GB3433@nazgul.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@alien8.de> wrote:

> On Thu, Sep 05, 2013 at 10:52:15AM -0700, tip-bot for Libin wrote:
> > Commit-ID:  52239484bf8aec031afa84ae08aa88224d819b93
> > Gitweb:     http://git.kernel.org/tip/52239484bf8aec031afa84ae08aa88224d819b93
> > Author:     Libin <huawei.libin@huawei.com>
> > AuthorDate: Thu, 5 Sep 2013 18:57:56 +0800
> > Committer:  Ingo Molnar <mingo@kernel.org>
> > CommitDate: Thu, 5 Sep 2013 15:05:37 +0200
> > 
> > x86/smpboot: Fix announce_cpu() to printk() the last "OK" properly
> > 
> > When booting secondary CPUs, announce_cpu() is called to show which cpu has
> > been brought up. For example:
> > 
> > [    0.402751] smpboot: Booting Node   0, Processors  #1 #2 #3 #4 #5 OK
> > [    0.525667] smpboot: Booting Node   1, Processors  #6 #7 #8 #9 #10 #11 OK
> > [    0.755592] smpboot: Booting Node   0, Processors  #12 #13 #14 #15 #16 #17 OK
> > [    0.890495] smpboot: Booting Node   1, Processors  #18 #19 #20 #21 #22 #23
> > 
> > But the last "OK" is lost, because 'nr_cpu_ids-1' represents the maximum
> > possible cpu id. It should use the maximum present cpu id in case not all
> > CPUs booted up.
> > 
> > Signed-off-by: Libin <huawei.libin@huawei.com>
> > Cc: <guohanjun@huawei.com>
> > Cc: <wangyijing@huawei.com>
> > Cc: <fenghua.yu@intel.com>
> > Cc: <paul.gortmaker@windriver.com>
> > Link: http://lkml.kernel.org/r/1378378676-18276-1-git-send-email-huawei.libin@huawei.com
> > [ tweaked the changelog, removed unnecessary line break, tweaked the format to align the fields vertically. ]
> > Signed-off-by: Ingo Molnar <mingo@kernel.org>
> 
> Hmm, this one kinda funnied up output on smaller boxes:
> 
> [    0.089340] smpboot: Booting Node   0, Processors  #   1
> [    0.105930] SMP alternatives: lockdep: fixing up alternatives
> [    0.106073]  #   2
> [    0.122237] SMP alternatives: lockdep: fixing up alternatives
> [    0.122384]  #   3 OK
> [    0.136464] Brought up 4 CPUs
> [    0.136539] smpboot: Total of 4 processors activated (23146.40 BogoMIPS)

Indeed, that should be fixed.

Thanks,

	Ingo
