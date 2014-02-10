Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487AbaBJQqV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 11:46:21 -0500
Received: from mga09.intel.com ([134.134.136.24]:38348 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949AbaBJQqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 11:46:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,818,1384329600"; 
   d="scan'208";a="452924486"
Message-ID: <52F9021C.1030801@linux.intel.com>
Date: Mon, 10 Feb 2014 08:45:16 -0800
From: Dave Hansen <dave.hansen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, dzickus@redhat.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] x86/nmi: Push duration printk() to irq context
References: <tip-rdw0au56a5ymis1u8p48c12d@git.kernel.org>
In-Reply-To: <tip-rdw0au56a5ymis1u8p48c12d@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2014 05:29 AM, tip-bot for Peter Zijlstra wrote:
> x86/nmi: Push duration printk() to irq context
> 
> Calling printk() from NMI context is bad (TM), so move it to IRQ
> context.

Bad since the I/O device that we're doing it to may be slow and make the
NMI painfully long?

I can see why it might be a bad idea, but I'm unsold that it is
*universally* a bad idea.

> In doing so we slightly change (probably wreck) the debugfs
> nmi_longest_ns thingy, in that it doesn't update to reflect the
> longest, nor does writing to it reset the count.

The reason I coded this up was that NMIs were firing off so fast that
nothing else was getting a chance to run.  With this patch, at least the
printk() would come out and I'd have some idea what was going on.


