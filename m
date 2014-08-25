Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215AbaHYLQ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 07:16:59 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:39550 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990AbaHYLQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 07:16:57 -0400
Date: Mon, 25 Aug 2014 12:16:53 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Dave Young <dyoung@redhat.com>
Cc: "Zheng, Lv" <lv.zheng@intel.com>, "Fleming, Matt" <matt.fleming@intel.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@acpica.org" <devel@acpica.org>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Moore, Robert" <robert.moore@intel.com>
Subject: Re: kernel boot fail with efi earlyprintk (bisected)
Message-ID: <20140825111653.GR29733@console-pimps.org>
References: <20140819081658.GA1795@darkstar.nay.redhat.com>
 <20140821205224.GJ29733@console-pimps.org>
 <20140822100258.GA1877@darkstar.nay.redhat.com>
 <20140825060713.GA4011@darkstar.nay.redhat.com>
 <1AE640813FDE7649BE1B193DEA596E880265F57B@SHSMSX101.ccr.corp.intel.com>
 <20140825090619.GA3202@darkstar.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140825090619.GA3202@darkstar.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Aug, at 05:06:19PM, Dave Young wrote:
> 
> Problem is I do not understand the implementation detail yet.
> 
> I did below changes:
> 
> Original values:
> #define NR_FIX_BTMAPS           64
> #define FIX_BTMAPS_SLOTS        4
> 
> -> new values tested:
> #define NR_FIX_BTMAPS           32
> #define FIX_BTMAPS_SLOTS        8
> 
> 
> There's below comments
>         /*
>          * 256 temporary boot-time mappings, used by early_ioremap(),
>          * before ioremap() is functional.
>          *
>          * If necessary we round it up to the next 256 pages boundary so
>          * that we can have a single pgd entry and a single pte table:
>          */
> 
> So seems increase it to 64 * 8 = 512 should be ok. If it's fine I can test again
> and post a patch.

Make sure you include the x86 maintainers on Cc if you change these
values.

-- 
Matt Fleming, Intel Open Source Technology Center
