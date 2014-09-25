Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926AbaIYX2R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 19:28:17 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:55937 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751875AbaIYX2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 19:28:16 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 1/1 linux-next] ACPI: processor: use container_of to resolve acpi_madt_local_apic/sapic/x2apic from acpi_subtable_header
Date: Fri, 26 Sep 2014 01:48:06 +0200
Message-ID: <2501224.1N8WbXDNS5@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1410700363-17939-1-git-send-email-fabf@skynet.be>
References: <1410700363-17939-1-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, September 14, 2014 03:12:43 PM Fabian Frederick wrote:
> Use container_of instead of casting first structure member.
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Queued up for 3.18, thanks!

> ---
> 
> Compiled but untested.
> 
>  drivers/acpi/processor_core.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
> index e32321c..ef58f46 100644
> --- a/drivers/acpi/processor_core.c
> +++ b/drivers/acpi/processor_core.c
> @@ -16,7 +16,7 @@ static int map_lapic_id(struct acpi_subtable_header *entry,
>  		 u32 acpi_id, int *apic_id)
>  {
>  	struct acpi_madt_local_apic *lapic =
> -		(struct acpi_madt_local_apic *)entry;
> +		container_of(entry, struct acpi_madt_local_apic, header);
>  
>  	if (!(lapic->lapic_flags & ACPI_MADT_ENABLED))
>  		return -ENODEV;
> @@ -32,7 +32,7 @@ static int map_x2apic_id(struct acpi_subtable_header *entry,
>  			 int device_declaration, u32 acpi_id, int *apic_id)
>  {
>  	struct acpi_madt_local_x2apic *apic =
> -		(struct acpi_madt_local_x2apic *)entry;
> +		container_of(entry, struct acpi_madt_local_x2apic, header);
>  
>  	if (!(apic->lapic_flags & ACPI_MADT_ENABLED))
>  		return -ENODEV;
> @@ -49,7 +49,7 @@ static int map_lsapic_id(struct acpi_subtable_header *entry,
>  		int device_declaration, u32 acpi_id, int *apic_id)
>  {
>  	struct acpi_madt_local_sapic *lsapic =
> -		(struct acpi_madt_local_sapic *)entry;
> +		container_of(entry, struct acpi_madt_local_sapic, header);
>  
>  	if (!(lsapic->lapic_flags & ACPI_MADT_ENABLED))
>  		return -ENODEV;
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
