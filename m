Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab3I0NdJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 09:33:09 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:59638 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307Ab3I0NdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 09:33:06 -0400
Date: Fri, 27 Sep 2013 15:33:02 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, huawei.libin@huawei.com,
        wangyijing@huawei.com, fenghua.yu@intel.com, tglx@linutronix.de,
        guohanjun@huawei.com, paul.gortmaker@windriver.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86/smpboot: Fix announce_cpu() to printk() the
 last "OK" properly
Message-ID: <20130927133302.GA12013@gmail.com>
References: <1378378676-18276-1-git-send-email-huawei.libin@huawei.com>
 <tip-52239484bf8aec031afa84ae08aa88224d819b93@git.kernel.org>
 <20130925100722.GB3433@nazgul.tnic>
 <20130925182936.GD16693@gmail.com>
 <20130926231545.GD10123@pd.tnic>
 <20130927065115.GA6852@gmail.com>
 <20130927124850.GB4422@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130927124850.GB4422@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@alien8.de> wrote:

> On Fri, Sep 27, 2013 at 08:51:15AM +0200, Ingo Molnar wrote:
> > That message was cool and interesting back in the days when we wrote
> > lockdep ('hey, look ma, it really works!!'), but there hasn't been
> > any breakage in that area for a long time and it definitely does not
> > deserve one line of log spam per CPU! Especially if it messes up such
> > a nice CPU bootup table.
> 
> Right. The comment in alternatives_enable_smp() talks about older
> binutils and could be a useful info if we encounter the issue again. Should I
> keep it or are we talking really old, i.e.
> 
> obsolete-we-will-never-use-them-anywhere-and-if-someone-does-we-dont-care
> 
> binutils?

See this commit from ~5 years ago:

  17abecfe651c x86: fix up alternatives with lockdep enabled

I was thinking about removing the message back then. Nobody ever 
complained: code patching is so fundamental to a properly functioning 
Linux kernel that broken binutils would stick out like a sore thumb - and 
not just related to lockdep.

So lets remove it.

Thanks,

	Ingo
