Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483Ab3APNnm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 08:43:42 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:41874 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405Ab3APNnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 08:43:40 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jslaby@suse.cz>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org, "Moore, Robert" <robert.moore@intel.com>
Subject: Re: [PATCH] ACPI: check zero length in acpi_rs_get_aml_length
Date: Wed, 16 Jan 2013 14:49:32 +0100
Message-ID: <3526578.G50o11JbOu@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1358334928-9736-1-git-send-email-jslaby@suse.cz>
References: <1358334928-9736-1-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday, January 16, 2013 12:15:28 PM Jiri Slaby wrote:
> There is a bug somewhere in the code that does not set the resource
> length. This makes the loop in acpi_rs_get_aml_length to loop forever.
> So it is a good thing to have the check even if the bug is fixed.

This needs to go through ACPICA upstream (Bob CCed).

> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> ---
>  drivers/acpi/acpica/rscalc.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/acpica/rscalc.c b/drivers/acpi/acpica/rscalc.c
> index da178b4..c128f2e 100644
> --- a/drivers/acpi/acpica/rscalc.c
> +++ b/drivers/acpi/acpica/rscalc.c
> @@ -198,7 +198,8 @@ acpi_rs_get_aml_length(struct acpi_resource * resource, acpi_size * size_needed)
>  
>  		/* Validate the descriptor type */
>  
> -		if (resource->type > ACPI_RESOURCE_TYPE_MAX) {
> +		if (resource->type > ACPI_RESOURCE_TYPE_MAX ||
> +				WARN_ON(!resource->length)) {

So this cannot be a WARN_ON().

>  			return_ACPI_STATUS(AE_AML_INVALID_RESOURCE_TYPE);
>  		}
>  

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
