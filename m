Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbaBSQep (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 11:34:45 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:57663 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754464AbaBSQeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 11:34:44 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Sudeep Holla <Sudeep.Holla@arm.com>
Cc: Hanjun Guo <hanjun.guo@linaro.org>, Lan Tianyu <tianyu.lan@intel.com>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Linaro-acpi] [PATCH v4 5/5] ACPI: Replace printk with pr_* in tables.c
Date: Wed, 19 Feb 2014 17:49:35 +0100
Message-ID: <2341500.Z47JjkFCMP@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5304DCA2.5080906@arm.com>
References: <1392731700-10992-1-git-send-email-hanjun.guo@linaro.org> <1392731700-10992-6-git-send-email-hanjun.guo@linaro.org> <5304DCA2.5080906@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 19, 2014 04:32:34 PM Sudeep Holla wrote:
> On 18/02/14 13:55, Hanjun Guo wrote:
> > This patch just do some clean up to replace printk with pr_*,
> > no functional change.
> > 
> Any particular reason for choosing just this file in this series ?
> It seems but off-topic in this series. The printk format is same in almost all
> other acpi files and it's better to change all or none for consistency.

Well, it's fine, I can put it into a different branch in any case. :-)

> > Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> > ---
> >  drivers/acpi/tables.c |   51 +++++++++++++++++++------------------------------
> >  1 file changed, 20 insertions(+), 31 deletions(-)
> > 
> > diff --git a/drivers/acpi/tables.c b/drivers/acpi/tables.c
> > index 5837f85..97bc6df 100644
> > --- a/drivers/acpi/tables.c
> > +++ b/drivers/acpi/tables.c
> > @@ -55,8 +55,7 @@ void acpi_table_print_madt_entry(struct acpi_subtable_header *header)
> >  		{
> >  			struct acpi_madt_local_apic *p =
> >  			    (struct acpi_madt_local_apic *)header;
> > -			printk(KERN_INFO PREFIX
> > -			       "LAPIC (acpi_id[0x%02x] lapic_id[0x%02x] %s)\n",
> > +			pr_info(PREFIX "LAPIC (acpi_id[0x%02x] lapic_id[0x%02x] %s)\n",
> 
> You can even get rid of PREFIX by defining pr_fmt instead.

But this is a good point.

> If the intention is to move to pr_* format it's better to have this as separate
> patch and convert all of them.

Well, not really.  One file at a time is OK too.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
