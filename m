Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617AbaENROy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 13:14:54 -0400
Received: from mail.skyhub.de ([78.46.96.112]:37185 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754880AbaENRNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 13:13:33 -0400
Date: Wed, 14 May 2014 19:13:21 +0200
From: Borislav Petkov <bp@alien8.de>
To: Tomasz Nowicki <tomasz.nowicki@linaro.org>
Cc: rjw@rjwysocki.net, lenb@kernel.org, tony.luck@intel.com, bp@suse.de,
        m.chehab@samsung.com, linux-edac@vger.kernel.org, x86@kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-acpi@lists.linaro.org
Subject: Re: [PATCH 7/7] acpi, apei, ghes: Factor out ioremap virtual memory
 for IRQ and NMI context.
Message-ID: <20140514171321.GG5231@pd.tnic>
References: <1397056476-9183-1-git-send-email-tomasz.nowicki@linaro.org>
 <1397056476-9183-8-git-send-email-tomasz.nowicki@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1397056476-9183-8-git-send-email-tomasz.nowicki@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 05:14:35PM +0200, Tomasz Nowicki wrote:
> @@ -310,6 +310,8 @@ static void ghes_copy_tofrom_phys(void *buffer, u64 paddr, u32 len,
>  	u64 offset;
>  	u32 trunk;
>  
> +	BUG_ON(in_nmi && !IS_ENABLED(CONFIG_ACPI_APEI_NMI));
> +

That's a good idea but it should be in the NMI notifier
ghes_notify_nmi() instead and simpler:

	BUG_ON(!IS_ENABLED(CONFIG_ACPI_APEI_NMI));

>  	while (len > 0) {
>  		offset = paddr - (paddr & PAGE_MASK);
>  		if (in_nmi) {

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
