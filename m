Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399Ab3HVUWI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 16:22:08 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:58199 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839Ab3HVUWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 16:22:06 -0400
Date: Thu, 22 Aug 2013 16:21:58 -0400
From: Tejun Heo <tj@kernel.org>
To: Toshi Kani <toshi.kani@hp.com>
Cc: Zhang Yanfei <zhangyanfei.yes@gmail.com>,
        Tang Chen <tangchen@cn.fujitsu.com>, konrad.wilk@oracle.com,
        robert.moore@intel.com, lv.zheng@intel.com, rjw@sisk.pl,
        lenb@kernel.org, tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, trenn@suse.de, yinghai@kernel.org,
        jiang.liu@huawei.com, wency@cn.fujitsu.com, laijs@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, izumi.taku@jp.fujitsu.com,
        mgorman@suse.de, minchan@kernel.org, mina86@mina86.com,
        gong.chen@linux.intel.com, vasilis.liaskovitis@profitbricks.com,
        lwoodman@redhat.com, riel@redhat.com, jweiner@redhat.com,
        prarit@redhat.com, zhangyanfei@cn.fujitsu.com, yanghy@cn.fujitsu.com,
        x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/8] x86, acpi: Move acpi_initrd_override() earlier.
Message-ID: <20130822202158.GD3490@mtj.dyndns.org>
References: <20130821153639.GA17432@htj.dyndns.org>
 <1377113503.10300.492.camel@misato.fc.hp.com>
 <20130821195410.GA2436@htj.dyndns.org>
 <1377116968.10300.514.camel@misato.fc.hp.com>
 <20130821204041.GC2436@htj.dyndns.org>
 <1377124595.10300.594.camel@misato.fc.hp.com>
 <20130822033234.GA2413@htj.dyndns.org>
 <1377186729.10300.643.camel@misato.fc.hp.com>
 <20130822183130.GA3490@mtj.dyndns.org>
 <1377202292.10300.693.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377202292.10300.693.camel@misato.fc.hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Aug 22, 2013 at 02:11:32PM -0600, Toshi Kani wrote:
> It's too late for the kernel image itself, but it prevents allocating
> kernel memory from movable ranges after that.  I'd say it solves a half
> of the issue this time.

That works if such half solution eventually leads to the full
solution.  This is just a distraction.  You are already too late in
the boot sequence.  It doesn't even qualify as a half solution.  It's
like obsessing about a speck on your shirt without your trousers on.
If you want to solve this, do that from a place where it actually is
solvable.

> > > Also, how do you support local page tables without pursing SRAT early?
> > 
> > Does it even matter with huge mappings?  It's gonna be contained in a
> > single page anyway, right?
> 
> Are the huge mappings always used?  We cannot force user programs to use
> huge pages, can we?

Everything is a trade-off.  Should we do all this just to support the
off chance someone tries to use memory hotplug on a machine which
doesn't support huge mapping when virtually all CPUs on market
supports it?

> As for the maintainability, I am far more concerned with your suggestion
> of having a separate page table init code when SRAT is used.  This kind
> of divergence is a recipe of breakage.

I don't buy that.  The only thing which needs to change is the
directionality of allocation and we probably don't even need to do
that if huge mapping is in use.

Thanks.

-- 
tejun
