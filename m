Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023Ab3FQXWt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 19:22:49 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:9542 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab3FQXWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 19:22:48 -0400
Message-ID: <1371511350.27152.25.camel@misato.fc.hp.com>
Subject: Re: [PATCH v5 04/22] x86, ACPI: Search buffer above 4G in second
 try for acpi override tables
From: Toshi Kani <toshi.kani@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Thomas Renninger <trenn@suse.de>,
        Tang Chen <tangchen@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org
Date: Mon, 17 Jun 2013 17:22:30 -0600
In-Reply-To: <1371257800-11720-5-git-send-email-yinghai@kernel.org>
References: <1371257800-11720-1-git-send-email-yinghai@kernel.org>
	 <1371257800-11720-5-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-14 at 17:56 -0700, Yinghai Lu wrote:
> Now we only search buffer for override acpi table under 4G.
> In some case, like user use memmap to exclude all low ram,
> we may not find range for it under 4G.
> 
> Do second try to search above 4G.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> Cc: linux-acpi@vger.kernel.org
> Tested-by: Thomas Renninger <trenn@suse.de>
> Reviewed-by: Tang Chen <tangchen@cn.fujitsu.com>
> Tested-by: Tang Chen <tangchen@cn.fujitsu.com>
> ---
>  drivers/acpi/osl.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> index 93e3194..42c48fc 100644
> --- a/drivers/acpi/osl.c
> +++ b/drivers/acpi/osl.c
> @@ -627,6 +627,10 @@ void __init acpi_initrd_override(void *data, size_t size)
>  	/* under 4G at first, then above 4G */
>  	acpi_tables_addr = memblock_find_in_range(0, (1ULL<<32) - 1,
>  					all_tables_size, PAGE_SIZE);
> +	if (!acpi_tables_addr)
> +		acpi_tables_addr = memblock_find_in_range(0,
> +					~(phys_addr_t)0,
> +					all_tables_size, PAGE_SIZE);

Should this search start from 4G, instead of 0?

Thanks,
-Toshi


>  	if (!acpi_tables_addr) {
>  		WARN_ON(1);
>  		return;


