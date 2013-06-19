Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935022Ab3FSSEv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:04:51 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58061 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934555Ab3FSSEt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:04:49 -0400
Date: Wed, 19 Jun 2013 20:04:41 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: tony.luck@intel.com, ananth@in.ibm.com, masbock@linux.vnet.ibm.com,
        lcm@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, ying.huang@intel.com
Subject: Re: [PATCH v2 2/2] mce: acpi/apei: Add a boot option to disable ff
 mode for corrected errors
Message-ID: <20130619180441.GK28300@pd.tnic>
References: <20130619175438.2852.93449.stgit@localhost.localdomain>
 <20130619175728.2852.73156.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130619175728.2852.73156.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 11:27:42PM +0530, Naveen N. Rao wrote:
> Add a boot option to disable firmware first mode for corrected errors.
> 
> Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
> ---
>  Documentation/x86/x86_64/boot-options.txt |    5 +++++
>  arch/x86/include/asm/acpi.h               |    2 ++
>  arch/x86/kernel/acpi/boot.c               |    5 +++++
>  drivers/acpi/apei/hest.c                  |    3 ++-
>  4 files changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/x86/x86_64/boot-options.txt b/Documentation/x86/x86_64/boot-options.txt
> index e9e8ddb..1228b22 100644
> --- a/Documentation/x86/x86_64/boot-options.txt
> +++ b/Documentation/x86/x86_64/boot-options.txt
> @@ -176,6 +176,11 @@ ACPI
>  
>    acpi=noirq	Don't route interrupts
>  
> +  acpi=nocmcff	Disable firmware first mode for corrected errors. This
> +		disables parsing the HEST CMC error source to check if
> +		firmware has set the FF flag. This may result in
> +		duplicate corrected error reports.

Interesting, why? Why would we even need such an option? My impression
is, if ACPI tells us FF, MCE code doesn't poll those banks anymore. So
where do the duplicated reports come from?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
