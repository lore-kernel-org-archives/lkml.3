Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab3BEBMg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 20:12:36 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54173 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754542Ab3BEBMf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 20:12:35 -0500
X-IronPort-AV: E=Sophos;i="4.84,603,1355068800"; 
   d="scan'208";a="6688691"
Subject: Re: [PATCH 2/5] acpi/numa: check if parsing acpi numa info
 disabled earlier
From: li guang <lig.fnst@cn.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, x86@kernel.org
In-Reply-To: <alpine.DEB.2.02.1302041133520.10378@chino.kir.corp.google.com>
References: <1359967426-32629-1-git-send-email-lig.fnst@cn.fujitsu.com>
	 <1359967426-32629-3-git-send-email-lig.fnst@cn.fujitsu.com>
	 <alpine.DEB.2.02.1302041133520.10378@chino.kir.corp.google.com>
Date: Tue, 05 Feb 2013 09:12:18 +0800
Message-ID: <1360026738.4449.8.camel@liguang.fnst.cn.fujitsu.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/05 09:11:16,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/05 09:11:17,
	Serialize complete at 2013/02/05 09:11:17
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

在 2013-02-04一的 11:41 -0800，David Rientjes写道：
> On Mon, 4 Feb 2013, liguang wrote:
> 
> > Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
> 
> Because there's no changelog, I have to read the patch to figure out what 
> it's doing since the title isn't that helpful either.  Please provide a 
> description of what problem you're trying to fix or what improvement 
> you're trying to make so it's clear.
> 
> > ---
> >  arch/x86/mm/srat.c  |    6 ------
> >  drivers/acpi/numa.c |    2 ++
> >  2 files changed, 2 insertions(+), 6 deletions(-)
> > 
> > diff --git a/arch/x86/mm/srat.c b/arch/x86/mm/srat.c
> > index a837c95..78c67bd 100644
> > --- a/arch/x86/mm/srat.c
> > +++ b/arch/x86/mm/srat.c
> > @@ -60,8 +60,6 @@ acpi_numa_x2apic_affinity_init(struct acpi_srat_x2apic_cpu_affinity *pa)
> >  	int pxm, node;
> >  	int apic_id;
> >  
> > -	if (srat_disabled())
> > -		return;
> >  	if (pa->header.length < sizeof(struct acpi_srat_x2apic_cpu_affinity)) {
> >  		bad_srat();
> >  		return;
> > @@ -100,8 +98,6 @@ acpi_numa_processor_affinity_init(struct acpi_srat_cpu_affinity *pa)
> >  	int pxm, node;
> >  	int apic_id;
> >  
> > -	if (srat_disabled())
> > -		return;
> >  	if (pa->header.length != sizeof(struct acpi_srat_cpu_affinity)) {
> >  		bad_srat();
> >  		return;
> > @@ -148,8 +144,6 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
> >  	u64 start, end;
> >  	int node, pxm;
> >  
> > -	if (srat_disabled())
> > -		return -1;
> >  	if (ma->header.length != sizeof(struct acpi_srat_mem_affinity)) {
> >  		bad_srat();
> >  		return -1;
> > diff --git a/drivers/acpi/numa.c b/drivers/acpi/numa.c
> > index cb31298..1f51222 100644
> > --- a/drivers/acpi/numa.c
> > +++ b/drivers/acpi/numa.c
> > @@ -262,6 +262,8 @@ static int __init acpi_parse_srat(struct acpi_table_header *table)
> >  	struct acpi_table_srat *srat;
> >  	if (!table)
> >  		return -EINVAL;
> > +	if (srat_disabled())
> > +		return -EACCES;
> >  
> >  	srat = (struct acpi_table_srat *)table;
> >  	acpi_srat_revision = srat->header.revision;
> 
> Nack, this isn't helpful since SRAT is only for x86 and other 
> architectures use this code.  It would break the build on ia64 since it's 
> obviously not going to have a function called srat_disabled().
> 
> And -EACCES would not be the appropriate return value, this has nothing to 
> do with permissions.

Yes, you're right, will drop this change.



