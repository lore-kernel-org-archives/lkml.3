Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344AbaIAIuG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 04:50:06 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:64831 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbaIAIuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 04:50:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Wang Long <long.wanglong@huawei.com>, linux@arm.linux.org.uk,
        santosh.shilimkar@ti.com, victor.kamensky@linaro.org, nico@linaro.org,
        ben.dooks@codethink.co.uk, cov@codeaurora.org,
        linux-kernel@vger.kernel.org
Subject: Re: [SMP BUG?] the return value of is_smp() is bug?
Date: Mon, 01 Sep 2014 10:49:09 +0200
Message-ID: <2846720.hM0WuNVsDY@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1409571334-2814-1-git-send-email-long.wanglong@huawei.com>
References: <1409571334-2814-1-git-send-email-long.wanglong@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:rQeb4q6ImeLi4f8qMJW11qoVfGJWcYhISl/RbbYTv+I
 u9nQaEQR9tLkCEDiLWwxc6zYgCOQKbVA9euaZeRfKXACttUDzw
 uKONb5H93MHLSAgGUv+bGMB4YCiecVNj9q8CcttohGA+bvCXcI
 Zsx0uqDIZJQX5gMUaXd4XypJTYEdnl/hxyQToMt5bCjoS1IpKs
 DWlAZlBTDfcn4lyg603ntHyuB5B3UNDIV6vER23+BONVML/flq
 Z3S33wWko2051g3FPZu7tSUCI2A+vrzzUPO15JPcmkW/uNdAww
 dt5qQnIs4iAiQEAVPC8nDWZbnku6eRImqO4KLghEyyokOWyUik
 FitSSK74VHUn6BQM+Ugw=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 September 2014 19:35:34 Wang Long wrote:
> In kernel 3.17-rc2, when i set CONFIG_HAVE_SMP = y and CONFIG_SMP_ON_UP = y 
> in .config file. the secondary core can not boot.
> 
> when i set CONFIG_HAVE_SMP = y and CONFIG_SMP_ON_UP = n in .config file,
> the secondary core can boot.
> 
> But this does not happen in kernel 3.10 lts kernel, Whether the 
> CONFIG_SMP_ON_UP is set yes or no ,the secondary core can boot.
> 
> Does the meaning of CONFIG_SMP_ON_UP changed or this is a bug in kernel 3.17-rc2 ? 
> 
> 
> I write the following patch to test the return value of is_smp().
> 

Can you check the value of CONFIG_SMP?

CONFIG_HAVE_SMP is set by platforms that allow enabling SMP, but you
still have the choice to set CONFIG_SMP on or off.

	Arnd
