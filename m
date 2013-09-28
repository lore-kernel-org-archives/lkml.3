Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655Ab3I1Ryx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 13:54:53 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:55597 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab3I1Rys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 13:54:48 -0400
Date: Sat, 28 Sep 2013 19:54:44 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, huawei.libin@huawei.com,
        wangyijing@huawei.com, fenghua.yu@intel.com, tglx@linutronix.de,
        guohanjun@huawei.com, paul.gortmaker@windriver.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH] x86, boot: Further compress CPUs bootup message
Message-ID: <20130928175444.GA4402@gmail.com>
References: <20130925182936.GD16693@gmail.com>
 <20130926231545.GD10123@pd.tnic>
 <20130927065115.GA6852@gmail.com>
 <20130927103802.GA4422@pd.tnic>
 <20130927143249.GD4422@pd.tnic>
 <20130927143554.GF4422@pd.tnic>
 <20130928082542.GA18198@gmail.com>
 <20130928102305.GA5956@pd.tnic>
 <20130928134449.GB26931@gmail.com>
 <20130928174749.GE5956@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130928174749.GE5956@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@alien8.de> wrote:

> +void smp_announce(void)
> +{
> +	int num_nodes = num_online_nodes();
> +
> +	printk(KERN_INFO "x86: Booted up %d node%s, %ld CPUs\n",
> +	       num_nodes, (num_nodes > 1 ? "s" : ""), (long)num_online_cpus());
> +}

That (long) cast looks weird - num_online_cpus() is 'unsigned int' so 
changing the format to %d should do the trick, right?

> +void __weak smp_announce(void)
> +{
> +	printk(KERN_INFO "Brought up %ld CPUs\n", (long)num_online_cpus());
> +}

Ditto.

Thanks,

	Ingo
