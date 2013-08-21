Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735Ab3HUTyV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 15:54:21 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:46038 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836Ab3HUTyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 15:54:17 -0400
Date: Wed, 21 Aug 2013 15:54:10 -0400
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
Message-ID: <20130821195410.GA2436@htj.dyndns.org>
References: <1377080143-28455-1-git-send-email-tangchen@cn.fujitsu.com>
 <20130821130647.GB19286@mtj.dyndns.org>
 <5214D60A.2090309@gmail.com>
 <20130821153639.GA17432@htj.dyndns.org>
 <1377113503.10300.492.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377113503.10300.492.camel@misato.fc.hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Toshi.

On Wed, Aug 21, 2013 at 01:31:43PM -0600, Toshi Kani wrote:
> Well, there is reason why we have earlyprintk feature today.  So, let's
> not debate on this feature now.  There was previous attempt to support

Are you saying the existing earlyprintk automatically justifies
addition of more complex mechanism?  The added complex of course
should be traded off against the benefits of gaining ACPI based early
boot.  You aren't gonna suggest implementing netconsole based
earlyprintk, right?

> this feature with ACPI tables below.  As described, it had the same
> ordering issue.
> 
> https://lkml.org/lkml/2012/10/8/498
> 
> There is a basic problem that when we try to use ACPI tables that
> extends or replaces legacy interfaces (ex. SRAT extending e820), we hit
> this ordering issue because ACPI is not available as early as the legacy
> interfaces.

Do we even want ACPI parsing and all that that early?  Parsing SRAT
early doesn't buy us much and I'm not sure whether adding ACPI
earlyprintk would increase or decrease debuggability during earlyboot.
It adds whole lot more code paths where things can go wrong while the
basic execution environment is unstable.  Why do that?

Thanks.

-- 
tejun
