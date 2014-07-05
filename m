Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196AbaGEKzN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 06:55:13 -0400
Received: from mail.skyhub.de ([78.46.96.112]:55613 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754897AbaGEKzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 06:55:11 -0400
Date: Sat, 5 Jul 2014 12:54:57 +0200
From: Borislav Petkov <bp@alien8.de>
To: linux-edac <linux-edac@vger.kernel.org>
Cc: Tony Luck <tony.luck@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v3 2/4] RAS: Add a Corrected Errors Collector
Message-ID: <20140705105457.GA27555@pd.tnic>
References: <1404242623-10094-1-git-send-email-bp@alien8.de>
 <1404242623-10094-3-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1404242623-10094-3-git-send-email-bp@alien8.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2014 at 09:23:41PM +0200, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> A simple data structure for collecting correctable errors along with
> accessors. Larger description in the code itself.
> 
> Signed-off-by: Borislav Petkov <bp@suse.de>
> ---
>  drivers/ras/Kconfig  |  11 ++
>  drivers/ras/Makefile |   3 +-
>  drivers/ras/ce.c     | 296 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/ras.h  |   2 +
>  4 files changed, 311 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/ras/ce.c
> 
> diff --git a/drivers/ras/Kconfig b/drivers/ras/Kconfig
> index f9da613052c2..c6977b943506 100644
> --- a/drivers/ras/Kconfig
> +++ b/drivers/ras/Kconfig
> @@ -1,2 +1,13 @@
>  config RAS
>  	bool
> +
> +config RAS_CE
> +	bool "Correctable Errors Collector"
> +	default y if X86_MCE
> +	select MEMORY_FAILURE

This has an unmet Kconfig dependency on 32-bit due to MEMORY_FAILURE not
enabled there. I readded the RAS menuconfig stuff along with Gong's nice
RAS description. Will be in the next version.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
