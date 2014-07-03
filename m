Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030871AbaGCJvr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:51:47 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60906 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965008AbaGCJvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:51:44 -0400
Date: Thu, 3 Jul 2014 11:51:35 +0200
From: Borislav Petkov <bp@alien8.de>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        toshi.kani@hp.com, imammedo@redhat.com, huawei.libin@huawei.com,
        paul.gortmaker@windriver.com, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com
Subject: Re: [PATCH] x86,cpu-hotplug: clear llc_shared_mask at CPU hotplug
Message-ID: <20140703095135.GA21776@pd.tnic>
References: <53B3A991.2070502@jp.fujitsu.com>
 <20140702113253.GD1318@pd.tnic>
 <53B4E1A4.2050502@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53B4E1A4.2050502@jp.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2014 at 01:52:52PM +0900, Yasuaki Ishimatsu wrote:
> I think that the reason to apply CPU number to ACPI ID is that CPU is
> used for the application without considering physical CPU. So even if
> CPU number is changed, it is no matter.

I don't think I understand what you're saying here...

> Thus the readded cores is numbered to unused CPU number.

Well, maybe we should use some method to number cores in a stable manner
so that they don't get new numbers when they reappear.

> I think the mask has 2 meanings as follows:
>   - representing CPUs that share same CPU cache.

... that share the last level cache.

>   - representing onlined CPUs

no, for that we have cpu_online_mask.

> So even if we keep their old numbers, we should clear the mask when
> offlinig CPU.

No, cpu_online_mask is for onlined cores. I think the mask which shows
which cores share a last level cache should not be changed *IF* the core
numbers remain stable, that is.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
