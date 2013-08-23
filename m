Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918Ab3HWQYv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 12:24:51 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:58007 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755719Ab3HWQYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 12:24:49 -0400
Date: Fri, 23 Aug 2013 12:24:44 -0400
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
Message-ID: <20130823162444.GL3277@htj.dyndns.org>
References: <20130822033234.GA2413@htj.dyndns.org>
 <1377186729.10300.643.camel@misato.fc.hp.com>
 <20130822183130.GA3490@mtj.dyndns.org>
 <1377202292.10300.693.camel@misato.fc.hp.com>
 <20130822202158.GD3490@mtj.dyndns.org>
 <1377205598.10300.715.camel@misato.fc.hp.com>
 <20130822212111.GF3490@mtj.dyndns.org>
 <1377209861.10300.756.camel@misato.fc.hp.com>
 <20130823130440.GC10322@mtj.dyndns.org>
 <1377274448.10300.777.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377274448.10300.777.camel@misato.fc.hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Aug 23, 2013 at 10:14:08AM -0600, Toshi Kani wrote:
> I still think acpi table info should be available earlier, but I do not
> think I can convince you on this.  This can be religious debate.

I'm curious.  If there aren't substantial enough benefits, why would
you still want to pull it earlier when it brings in things like initrd
override and crafting the code carefully so that it's safe to execute
it from different address modes and so on?  Please note that x86 is
not ia64.  The early environment is completely different not only
technically but also in its diversity and suckiness.  It wasn't too
long ago that vendors were screwing up ACPI left and right.  It has
been getting better but there's a reason why, for example, we still
consider e820 to be the authoritative information over ACPI.

Thanks.

-- 
tejun
