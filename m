Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751304AbaK2PhJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 10:37:09 -0500
Received: from mail.skyhub.de ([78.46.96.112]:45913 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164AbaK2PhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 10:37:06 -0500
Date: Sat, 29 Nov 2014 16:37:01 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: linux-tip-commits@vger.kernel.org, matthias.bgg@gmail.com,
        tony.luck@intel.com, tglx@linutronix.de, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com, grant.likely@linaro.org,
        wangyijing@huawei.com, marc.zyngier@arm.com, bhelgaas@google.com,
        yingjoe.chen@mediatek.com, mingo@kernel.org
Subject: Re: [tip:irq/irqdomain] irqdomain: Introduce helper function
 irq_domain_add_hierarchy()
Message-ID: <20141129153701.GD5075@pd.tnic>
References: <1416061447-9472-5-git-send-email-jiang.liu@linux.intel.com>
 <tip-afb7da83b9f476728623130703acb553d7c7c4d9@git.kernel.org>
 <20141129125319.GA6491@pd.tnic>
 <5479D84D.7000500@linux.intel.com>
 <20141129145616.GC5075@pd.tnic>
 <5479E467.5070701@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5479E467.5070701@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 29, 2014 at 11:21:11PM +0800, Jiang Liu wrote:
> Thanks for the info about GFP_ATOMIC, originally I have an impression
> that we should use GFP_ATOMIC when interrupt is disabled:(

Hmm, that's actually a good point. GFP_NOFS has __GFP_WAIT which means
that we can wait and resched when the first alloc attempt fails so maybe
GFP_ATOMIC would be the correct solution after all...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
