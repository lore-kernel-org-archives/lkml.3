Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab3HBQ6v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 12:58:51 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:43184 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937Ab3HBQ6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 12:58:49 -0400
Message-ID: <1375462662.10300.91.camel@misato.fc.hp.com>
Subject: Re: [PATCH v2 06/18] x86, acpi: Initialize ACPI root table list
 earlier.
From: Toshi Kani <toshi.kani@hp.com>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: rjw@sisk.pl, lenb@kernel.org, tglx@linutronix.de, mingo@elte.hu,
        hpa@zytor.com, akpm@linux-foundation.org, tj@kernel.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com,
        zhangyanfei@cn.fujitsu.com, yanghy@cn.fujitsu.com, x86@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-acpi@vger.kernel.org
Date: Fri, 02 Aug 2013 10:57:42 -0600
In-Reply-To: <51FB646F.30604@cn.fujitsu.com>
References: <1375340800-19332-1-git-send-email-tangchen@cn.fujitsu.com>
	  <1375340800-19332-7-git-send-email-tangchen@cn.fujitsu.com>
	 <1375401251.10300.53.camel@misato.fc.hp.com>
	 <51FB646F.30604@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-02 at 15:49 +0800, Tang Chen wrote:
> On 08/02/2013 07:54 AM, Toshi Kani wrote:
> ......
> >>   /*
> >> + * acpi_root_table_init - Initialize acpi_gbl_root_table_list.
> >> + *
> >> + * This function will parse RSDT or XSDT, find all tables' phys addr,
> >> + * initialize acpi_gbl_root_table_list, and record all tables' phys addr
> >> + * in acpi_gbl_root_table_list.
> >> + */
> >> +void __init acpi_root_table_init(void)
> >
> > I think acpi_root_table_init() is a bit confusing with
> > acpi_boot_table_init().  Perhaps, something like
> > acpi_boot_table_pre_init() or early_acpi_boot_table_init() is better to
> > indicate that this new function is called before acpi_boot_table_init().
> >
> 
> OK, will change it to early_acpi_boot_table_init().
> 
> >> +{
> >> +	dmi_check_system(acpi_dmi_table);
> >> +
> >> +	/* If acpi_disabled, bail out */
> >> +	if (acpi_disabled)
> >> +		return;
> >> +
> >> +	/* Initialize the ACPI boot-time table parser */
> >> +	if (acpi_table_init()) {
> >> +		disable_acpi();
> >> +		return;
> >> +	}
> >> +}
> >> +
> >> +/*
> >>    * acpi_boot_table_init() and acpi_boot_init()
> >>    *  called from setup_arch(), always.
> >>    *	1. checksums all tables
> >> @@ -1511,21 +1533,7 @@ static struct dmi_system_id __initdata acpi_dmi_table_late[] = {
> >>
> >>   void __init acpi_boot_table_init(void)
> >
> > The comment of this function needs to be updated.  For instance, it
> > describes acpi_table_init(), which you just relocated.
> >
> >   * acpi_table_init() is separate to allow reading SRAT without
> >   * other side effects.
> >   *
> 
> Sure. But I don't quite understand this comment. It seems that
> acpi_table_init() has nothing to do with SRAT.
> 
> Do you know anything about this ?

Well, I do not know, either.  But if I have to guess, it might mean that
"acpi_table_init() is separated from acpi_boot_init() to allow reading
SRAT without the conditional flags, ex. acpi_lapic and acpi_ioapic, in
acpi_boot_init()."

I'd suggest you simply rephrase it to match with your change, instead of
trying to keep such old history.

Thanks,
-Toshi

